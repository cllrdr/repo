#!/bin/bash

topic_number=$1;
for i in {1,3}; do
    # Создаем временный файл для хранения текста промпта
    touch topic
    yq .items[].slide$i.prompt plans/list$topic_number.yml | grep -v null > topic
    echo "Слайд "$i
    python3 api_query.py
    rm topic
done > /home/aach/repo/sociology/topic_$topic_number