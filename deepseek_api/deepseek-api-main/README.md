# DeepSeek4Free (Russian fork)

Пакет Python для взаимодействия с API чата DeepSeek AI. Этот пакет предоставляет чистый интерфейс для взаимодействия с моделью чата DeepSeek, с поддержкой потоковых ответов, видимости процесса размышлений и возможности поиска в интернете.

### (реклама удалена)

> ⚠️ **Уведомление об услугах**: API DeepSeek в настоящее время испытывает большую нагрузку. Ведется работа по интеграции дополнительных поставщиков API. Ожидайте периодические ошибки.


## ✨ Возможности

- 🔄 **Потоковые ответы**: Взаимодействие в реальном времени с выводом по токенам
- 🤔 **Процесс размышлений**: Опциональная видимость шагов рассуждений модели
- 🔍 **Поиск в интернете**: Опциональная интеграция для актуальной информации
- 💬 **Управление сессиями**: Постоянные чат-сессии с историей разговоров
- ⚡ **Эффективный PoW**: Реализация доказательства работы на основе WebAssembly
- 🛡️ **Обработка ошибок**: Всесторонняя обработка ошибок с конкретными исключениями
- ⏱️ **Без тайм-аутов**: Разработано для долгих разговоров без тайм-аутов
- 🧵 **Поддержка потоков**: Отслеживание родительских сообщений для разговоров с потоками

## 📦 Установка

1. Клонируйте репозиторий:
```bash
git clone https://github.com/yourusername/deepseek4free.git
cd deepseek4free
```
Установите зависимости:
```bash
pip install -r requirements.txt
```
## 🔑 Аутентификация
Для использования этого пакета вам нужен токен авторизации DeepSeek. Вот как его получить:

### Метод 1: Из LocalStorage (Рекомендуется)
<img width="1150" alt="image" src="https://github.com/user-attachments/assets/b4e11650-3d1b-4638-956a-c67889a9f37e" />

1. Перейдите на сайт chat.deepseek.com
2. Войдите в свою учетную запись
3. Откройте инструменты разработчика в браузере (F12 или щелкните правой кнопкой мыши > Исследовать)
4. Перейдите на вкладку "Приложение" (если она не видна, щелкните >> для отображения дополнительных вкладок)
5. В левой панели разверните "Local Storage"
6. Нажмите на "https://chat.deepseek.com"
7. Найдите ключ с именем userToken
8. Скопируйте значение "value" — это ваш токен аутентификации

### Метод 2: Из вкладки Сеть
Также вы можете получить токен из сетевых запросов:

1. Перейдите на сайт chat.deepseek.com
2. Войдите в свою учетную запись
3. Откройте инструменты разработчика в браузере (F12)
4. Перейдите на вкладку "Сеть"
5. Сделайте любой запрос в чате
6. Найдите заголовки запроса
7. Скопируйте токен authorization (без префикса 'Bearer ')

## 📚 Использование
Простой пример
```python
from dsk.api import DeepSeekAPI

# Инициализация с вашим токеном авторизации
api = DeepSeekAPI("ВАШ_ТОКЕН_АУТЕНТИФИКАЦИИ")

# Создание новой чат-сессии
chat_id = api.create_chat_session()

# Простой чат-комплешн
prompt = "Что такое Python?"
for chunk in api.chat_completion(chat_id, prompt):
    if chunk['type'] == 'text':
        print(chunk['content'], end='', flush=True)
```
Расширенные возможности
- Видимость процесса размышлений
- Процесс размышлений показывает шаги рассуждений модели:

```python
# С включенным процессом размышлений
for chunk in api.chat_completion(
    chat_id,
    "Объясните квантовые вычисления",
    thinking_enabled=True
):
    if chunk['type'] == 'thinking':
        print(f"🤔 Размышление: {chunk['content']}")
    elif chunk['type'] == 'text':
        print(chunk['content'], end='', flush=True)
```
- Интеграция поиска в интернете
- - Включите поиск в интернете для получения актуальной информации:

```python
# С включенным поиском в интернете
for chunk in api.chat_completion(
    chat_id,
    "Какие последние разработки в области ИИ?",
    thinking_enabled=True,
    search_enabled=True
):
    if chunk['type'] == 'thinking':
        print(f"🔍 Поиск: {chunk['content']}")
    elif chunk['type'] == 'text':
        print(chunk['content'], end='', flush=True)
```
- Поточные разговоры
- - Создайте потоковые разговоры, отслеживая родительские сообщения:

```python
# Начинаем разговор
chat_id = api.create_chat_session()

# Отправляем первоначальное сообщение
parent_id = None
for chunk in api.chat_completion(chat_id, "Расскажите о нейронных сетях"):
    if chunk['type'] == 'text':
        print(chunk['content'], end='', flush=True)
    elif 'message_id' in chunk:
        parent_id = chunk['message_id']

# Отправляем следующий вопрос в потоке
for chunk in api.chat_completion(
    chat_id,
    "Как они сравниваются с другими моделями ML?",
    parent_message_id=parent_id
):
    if chunk['type'] == 'text':
        print(chunk['content'], end='', flush=True)
```
- Обработка ошибок
- - Пакет предоставляет специфические исключения для различных ошибок:

```python
from dsk.api import (
    DeepSeekAPI, 
    AuthenticationError,
    RateLimitError,
    NetworkError,
    APIError
)

try:
    api = DeepSeekAPI("ВАШ_ТОКЕН_АУТЕНТИФИКАЦИИ")
    chat_id = api.create_chat_session()
    
    for chunk in api.chat_completion(chat_id, "Ваш запрос здесь"):
        if chunk['type'] == 'text':
            print(chunk['content'], end='', flush=True)
            
except AuthenticationError:
    print("Ошибка аутентификации. Пожалуйста, проверьте ваш токен.")
except RateLimitError:
    print("Превышен лимит запросов. Пожалуйста, подождите перед отправкой новых запросов.")
except NetworkError:
    print("Ошибка сети. Проверьте ваше интернет-соединение.")
except APIError as e:
    print(f"Ошибка API: {str(e)}")
Вспомогательные функции
```
- Для более чистой обработки вывода, вы можете использовать вспомогательные функции, как в example.py:
```python
def print_response(chunks):
    """Вспомогательная функция для вывода ответов в чистом формате"""
    thinking_lines = []
    text_content = []
    
    for chunk in chunks:
        if chunk['type'] == 'thinking':
            if chunk['content'] not in thinking_lines:
                thinking_lines.append(chunk['content'])
                print(f"🤔 {chunk['content']}")
        elif chunk['type'] == 'text':
            text_content.append(chunk['content'])
            print(chunk['content'], end='', flush=True)
```
### 🧪 Формат ответа
API возвращает чанки в следующем формате:

```python
{
    'type': str,        # 'thinking' или 'text'
    'content': str,     # Содержимое ответа
    'finish_reason': str,  # 'stop', когда ответ завершен
    'message_id': str   # (опционально) Для потоковых разговоров
}
```
### 🤝 Вклад
Вклады приветствуются! Пожалуйста, не стесняйтесь отправить Pull Request. Вот несколько способов, как вы можете внести вклад:

- 🐛 Сообщать об ошибках
- ✨ Запрашивать новые функции
- 📝 Улучшать документацию
- 🔧 Предлагать исправления ошибок
- 🎨 Добавлять примеры
- 📄 Лицензия
Этот проект лицензирован по лицензии MIT - см. файл LICENSE для подробностей.

## ⚠️ Отказ от ответственности
Этот пакет не является официальным и не связан с DeepSeek. Используйте его ответственно и в соответствии с условиями обслуживания DeepSeek.

## Ссылки
- Проект создан пользователем [xtekky]([https://chat.deepseek.com](https://github.com/xtekky)
- Репозиторий переведён на русский язык пользователем [PARAPOPOVICH](https://github.com/KOSFin)

- Видео-гайд на YouTube: (скоро появится)

