#!/bin/bash
IFS=$'\n'
for i in $(cat list); do
    # Создаем временный файл для хранения текста промпта
    touch topic
    echo $i > topic
    python3 api_query.py
    rm topic
done >> /home/aach/repo/diana/result