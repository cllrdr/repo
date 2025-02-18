#!/bin/bash

# Список доступных сортов пива
beers=("Пшеничное" "Светлое" "Темное" "Крафтовое")

PS3="Выберите сорт пива: "

select beer in "${beers[@]}" "Выход"; do
    case $beer in
        "Выход") break ;;
        *) echo "Вы выбрали: $beer"; break;;
    esac
done

echo "До свидания!"