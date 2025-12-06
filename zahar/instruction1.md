Отлично — сделаем **минимальный, но рабочий прототип** ассистента на Python + FastAPI, который:

✓ принимает запрос пользователя
✓ спрашивает Gigachat: нужен ли SQL (step 1)
✓ если нужен — выполняет SQL
✓ отправляет результат обратно в Gigachat (step 2)
✓ выдает финальный ответ пользователю

Дальше ты сможешь развернуть это у себя и расширять.

---

# 🚀 Готовая минимальная структура проекта

```
project/
│
├── main.py
├── system_step1.txt
├── system_step2.txt
└── requirements.txt
```

---

# 📌 requirements.txt

```
fastapi
uvicorn
psycopg2-binary
requests
python-dotenv
```

---

# 📌 system_step1.txt

(первый промпт: решить, нужен ли SQL)

```
Ты — ассистент, который анализирует запрос пользователя и решает, нужно ли выполнить SQL.

Вот схема базы данных:

TABLE notes:
  id SERIAL PRIMARY KEY
  text TEXT NOT NULL
  created_at TIMESTAMP DEFAULT now()

TABLE tasks:
  id SERIAL PRIMARY KEY
  title TEXT NOT NULL
  is_done BOOLEAN DEFAULT false

Правила:
- используй только эти таблицы и поля
- не придумывай новые таблицы
- не придумывай новые поля
- SQL должен быть строго совместим с Postgres
- если пользователь просит сохранить, обновить, удалить, найти данные — используй SQL

Если SQL нужен:
{
  "action": "run_sql",
  "sql": "<SQL>"
}

Если SQL не нужен:
{
  "action": "respond",
  "message": "<текст>"
}

Верни только JSON.

```

---

# 📌 system_step2.txt

(второй промпт: финальный ответ на основе данных)

```
Ты — ассистент, который формирует финальный ответ пользователю.

Тебе дают:
- исходное сообщение пользователя,
- SQL-код, который ты сгенерировал ранее,
- результат выполнения SQL.

Ответь пользователю человеческим текстом, не показывай SQL и JSON.
Просто объясни результат.
```

---

# 🧠 Основной backend — main.py

```python
import json
import requests
from fastapi import FastAPI
from psycopg2 import connect

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


def call_gigachat(messages):
    url = "https://gigachat.devices.sberbank.ru/api/v1/chat/completions"

    headers = {
        "Authorization": f"Bearer {GIGACHAT_TOKEN}",
        "Content-Type": "application/json"
    }

    payload = {
        "model": "GigaChat",
        "messages": messages,
        "temperature": 0
    }

    r = requests.post(url, headers=headers, json=payload)
    r.raise_for_status()
    return r.json()["choices"][0]["message"]["content"]


@app.post("/assistant")
def assistant(user_message: str):
    # ---- STEP 1: Решение: нужен ли SQL ----
    step1_prompt = open("system_step1.txt").read()

    step1_response = call_gigachat([
        {"role": "system", "content": step1_prompt},
        {"role": "user", "content": user_message}
    ])

    try:
        step1_json = json.loads(step1_response)
    except:
        return {"error": "LLM вернула не JSON", "raw": step1_response}

    # ---- Если SQL не нужен ----
    if step1_json["action"] == "respond":
        return {"answer": step1_json["message"]}

    # ---- STEP 2: Выполнение SQL ----
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

    # ---- STEP 3: Финальный ответ ----
    step2_prompt = open("system_step2.txt").read()

    final_response = call_gigachat([
        {"role": "system", "content": step2_prompt},
        {"role": "user", "content": user_message},
        {"role": "assistant", "content": step1_response},
        {"role": "tool", "content": json.dumps(sql_result)}
    ])

    return {"answer": final_response, "data": sql_result}
```

---

# 📌 Пример .env

```
PG_DB=postgres
PG_USER=postgres
PG_PASS=mysecretpassword
PG_HOST=localhost
PG_PORT=5432

GIGACHAT_TOKEN=ВашТокен
```

---

# ▶ Как запустить

```
pip install -r requirements.txt
uvicorn main:app --reload
```

---

# 🔥 Пример того, как будет работать

## Запрос:

```
POST localhost:8000/assistant
"сохрани заметку: купить молоко"
```

## Step 1: LLM вернёт:

```json
{
  "action": "run_sql",
  "sql": "INSERT INTO notes (text) VALUES ('купить молоко') RETURNING id;"
}
```

## Step 2: SQL выполнится

## Step 3: LLM даст финальный ответ:

```
Заметка сохранена. ID: 5
```
