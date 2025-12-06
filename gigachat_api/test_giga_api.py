import requests
from dotenv import load_dotenv
import os

load_dotenv()
token = os.getenv("GIGACHAT_TOKEN")
print(token)
print("XXXXXXX")
prompt = "Ты готов поработать?"
#prompt = f"В рамках курсовой работы о совершенствовании технологий подбора персонала. Напиши текст размером примерно 0.5 А4 на тему: {topic}. Пиши как студентка второкурсница"

# Формирование запроса
url = "https://gigachat.devices.sberbank.ru/api/v1/chat/completions"
headers = {
    "Content-Type": "application/json",
    "Authorization": f"Bearer {token}" 
}

data = {
    "model": "GigaChat",
    "messages": [
        {
            "role": "user",
            "content": f"{prompt}"
        }
    ],
    "creativity": 0.8
}

# Отправка запроса
response = requests.post(url, headers=headers, json=data)

if response.status_code == 200:
    result = response.json()
    print('===== ТЕМА ====== ')
    print()
    print(result['choices'][0]['message']['content'])
    print()
    print("Использовано токенов: ", result['usage']['total_tokens'])
    print()
    print()
else:
    print(f"Ошибка: {response.status_code}")