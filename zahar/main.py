import json
import requests
from fastapi import FastAPI
from psycopg2 import connect
from pydantic import BaseModel

from dotenv import load_dotenv
import os

load_dotenv()

app = FastAPI()

DB = connect(
    dbname=os.getenv("PG_DB"),
    user=os.getenv("PG_USER"),
    password=os.getenv("PG_PASS"),
    host=os.getenv("PG_HOST"),
    port=os.getenv("PG_PORT")
)

GIGACHAT_TOKEN = os.getenv("GIGACHAT_TOKEN")
print("Loaded GigaChat token:", GIGACHAT_TOKEN)


def call_gigachat(messages):
    url = "https://gigachat.devices.sberbank.ru/api/v1/chat/completions"

    headers = {
        "Authorization": f"Bearer {GIGACHAT_TOKEN}",
        "Content-Type": "application/json"
    }

    payload = {
        "model": "GigaChat",
        "messages": messages,
        "creativity": 0
    }

    r = requests.post(url, headers=headers, json=payload, verify=False)
    r.raise_for_status()
    return r.json()["choices"][0]["message"]["content"]


# ---------- модель входа ----------
class AssistantRequest(BaseModel):
    user_message: str


@app.post("/assistant")
def assistant(req: AssistantRequest):
    user_message = req.user_message

    # ---- STEP 1 -----
    step1_prompt = open("system_step1.txt").read()

    step1_messages = [
        {
            "role": "user",
            "content": f"SYSTEM INSTRUCTIONS:\n{step1_prompt}"
        },
        {
            "role": "user",
            "content": user_message
        }
    ]

    step1_response = call_gigachat(step1_messages)

    # Должен быть JSON
    try:
        step1_json = json.loads(step1_response)
    except Exception:
        return {"error": "LLM вернула не JSON", "raw": step1_response}

    # Если SQL не нужен
    if step1_json["action"] == "respond":
        return {"answer": step1_json["message"]}

    # ---- STEP 2: SQL ----
    sql = step1_json["sql"]
    cur = DB.cursor()

    try:
        cur.execute(sql)
        try:
            sql_result = cur.fetchall()
        except:
            sql_result = "OK"

        DB.commit()

    except Exception as e:
        DB.rollback()
        return {"error": str(e), "sql": sql}

    # ---- STEP 3: финальный ответ ----
    step2_prompt = open("system_step2.txt").read()

    final_messages = [
        {
            "role": "user",
            "content": f"SYSTEM INSTRUCTIONS:\n{step2_prompt}"
        },
        {
            "role": "user",
            "content": f"Исходный запрос пользователя: {user_message}"
        },
        {
            "role": "assistant",
            "content": f"Ответ шага 1: {step1_response}"
        },
        {
            "role": "assistant",
            "content": f"SQL result: {json.dumps(sql_result)}"
        }
    ]

    final_response = call_gigachat(final_messages)

    return {"answer": final_response, "data": sql_result}
