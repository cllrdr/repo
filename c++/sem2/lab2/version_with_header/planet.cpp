#include "planet.h"

// Реализация конструктора
Planet::Planet(const std::string name, double diameter, bool isLifePossible, int numberOfSatellites)
    : name(name), diameter(diameter), isLifePossible(isLifePossible), numberOfSatellites(numberOfSatellites) {}

// Реализация метода printInfo
void Planet::printInfo() {
    std::cout << "Название: " << name << std::endl;
    std::cout << "Диаметр: " << diameter << " км" << std::endl;
    std::cout << "Возможна ли жизнь: " << (isLifePossible ? "Да" : "Нет") << std::endl;
    std::cout << "Количество спутников: " << numberOfSatellites << std::endl;
}