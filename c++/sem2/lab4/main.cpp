// Файл main.cpp
#include <iostream>
#include "stack.h"
#include "stack.cpp"  // Подключаем реализацию, так как шаблонные классы нужно включать полностью

int main() {
    // 1. Создаем стек целых чисел
    MyStack<int> intStack;

    // 2. Проверяем, пуст ли стек
    std::cout << "Стек пуст? " << (intStack.empty() ? "Да" : "Нет") << std::endl;

    // 3. Добавляем элементы в стек
    std::cout << "\nДобавляем элементы 10, 20, 30 в стек:" << std::endl;
    intStack.push(10);
    intStack.push(20);
    intStack.push(30);

    // 4. Выводим вершину стека
    std::cout << "Вершина стека: " << intStack.top_inf() << std::endl;

    // 5. Извлекаем элементы из стека
    std::cout << "\nИзвлекаем элементы из стека:" << std::endl;
    while (!intStack.empty()) {
        std::cout << "Извлечено: " << intStack.top_inf() << std::endl;
        intStack.pop();
    }

    // 6. Проверяем, пуст ли стек после извлечения
    std::cout << "\nСтек пуст? " << (intStack.empty() ? "Да" : "Нет") << std::endl;

    // 7. Пробуем извлечь из пустого стека
    std::cout << "\nПопытка извлечь из пустого стека:" << std::endl;
    if (!intStack.pop()) {
        std::cout << "Не удалось извлечь - стек пуст!" << std::endl;
    }

    // 8. Пробуем прочитать вершину пустого стека (с обработкой исключения)
    std::cout << "\nПопытка прочитать вершину пустого стека:" << std::endl;
    try {
        std::cout << intStack.top_inf() << std::endl;
    } catch (const std::runtime_error& e) {
        std::cout << "Ошибка: " << e.what() << std::endl;
    }

    // 9. Демонстрация работы с другим типом данных (стек строк)
    MyStack<std::string> stringStack;
    stringStack.push("Hello");
    stringStack.push("World");
    
    std::cout << "\nСтек строк:" << std::endl;
    while (!stringStack.empty()) {
        std::cout << stringStack.top_inf() << " ";
        stringStack.pop();
    }
    std::cout << std::endl;

    return 0;
}