#include "header.h"

// Функция для генерации случайного числа в диапазоне [min, max]
int rnd(int min, int max) {
    static std::mt19937 generator(std::random_device{}()); // Генератор случайных чисел
    std::uniform_int_distribution<> distribution(min, max); // Распределение чисел между min и max
    return distribution(generator); // Возвращаем случайное число

}