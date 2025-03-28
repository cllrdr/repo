#include <string>
#include <iostream>

class Planet {
private:
    std::string name;
    double diameter;
    bool isLifePossible;
    int numberOfSatellites;

public:
    // Конструктор
    Planet(const std::string name, double diameter, bool isLifePossible, int numberOfSatellites);

    // Метод для вывода информации о планете
    void printInfo();
};
