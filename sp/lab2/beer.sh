#!/bin/bash

# Список доступных сортов пива
beers=("Пшеничное" "Светлое" "Темное" "Крафтовое")

# Функция для отображения меню
show_menu() {
    echo "Выберите сорт пива:"
    for ((i = 0; i < ${#beers[@]}; i++)); do
        echo $((i+1)) "${beers[i]}";
    done
    echo "5 Инфо о студенте"
}

# Основная логика программы
while true; do
    choice=$1
    clear
    show_menu
    
    read -p "Ваш выбор (введите номер от 1 до ${#beers[@]} или 'q' для выхода): " choice

    # Проверка ввода
    if [[ "$choice" == "q" ]]; then
        break
    elif [[ "$choice" -eq 5 ]]; then
        clear
        cat info
    elif [[ "$choice" =~ ^[0-${#beers[@]}]+$ ]]; then
        selected_beer=${beers[$((choice-1))]}
        clear
        echo "Вы выбрали: $selected_beer"
        echo $selected_beer >> bill_tmp
    else
        clear
        echo "Такого пункта нет в меню. Попробуйте еще раз."
    fi
    echo "Нажмите любую клавишу для продолжения..."
    read -n 1 -s
    clear
done

rm bill_tmp
clear
echo "До свидания!"