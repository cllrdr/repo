import requests

# Чтение содержимого текстового файла
#with open('source.txt', 'r') as file:
#    file_content = file.read()

with open('current_token', 'r') as token:
    token = token.readline().strip()

with open('topic', 'r') as topic:
    topic = topic.readline().strip()

#prompt = "Ты готов поработать?"
prompt = f"Напиши текст для слайда на тему: {topic}"

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
    ]
}

# Отправка запроса
response = requests.post(url, headers=headers, json=data)

if response.status_code == 200:
    result = response.json()
    print(result['choices'][0]['message']['content'])
    print()
    print("Использовано токенов: ", result['usage']['total_tokens'])
    print()
    print()
else:
    print(f"Ошибка: {response.status_code}")