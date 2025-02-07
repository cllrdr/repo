#!/bin/bash
# Запрашиваем новый токен и записываем в файл current_token
curl -L -X POST 'https://ngw.devices.sberbank.ru:9443/api/v2/oauth' \
-H 'Content-Type: application/x-www-form-urlencoded' \
-H 'Accept: application/json' \
-H 'RqUID: ec2e6e9a-58a2-4ad1-9fd2-a4fbe11ddf44' \
-H 'Authorization: Basic ZWMyZTZlOWEtNThhMi00YWQxLTlmZDItYTRmYmUxMWRkZjQ0OmU0NjIzZDc4LWJkMjAtNGRjYi05ZWU3LTE0NTk4ODM5NTc1OQ==' \
--data-urlencode 'scope=GIGACHAT_API_PERS' | jq .access_token -r > current_token
