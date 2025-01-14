#include <iostream>
#include <random>

// Функция для генерации случайного числа в диапазоне [min, max]
int generateRandomNumber(int min, int max) {
    static std::mt19937 generator(std::random_device{}()); // Генератор случайных чисел
    std::uniform_int_distribution<> distribution(min, max); // Распределение чисел между min и max
    return distribution(generator); // Возвращаем случайное число
}

int main() {
    int randomNumber = generateRandomNumber(1, 100); // Генерация случайного числа от 1 до 100
    std::cout << "Случайное число: " << randomNumber << std::endl;
    return 0;
}