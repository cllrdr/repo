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
    Planet(const std::string name, double diameter, bool isLifePossible, int numberOfSatellites)
        : name(name), diameter(diameter), isLifePossible(isLifePossible), numberOfSatellites(numberOfSatellites) {}

    // Геттеры
    std::string getName() const { return name; }
    double getDiameter() const { return diameter; }
    bool getIsLifePossible() const { return isLifePossible; }
    int getNumberOfSatellites() const { return numberOfSatellites; }

    void setD() { diameter = 30; }

    // Метод для вывода информации о планете
    void printInfo() {
        std::cout << "Название: " << name << std::endl;
        std::cout << "Диаметр: " << diameter << " км" << std::endl;
        std::cout << "Возможна ли жизнь: " << (isLifePossible ? "Да" : "Нет") << std::endl;
        std::cout << "Количество спутников: " << numberOfSatellites << std::endl;
    }

    std::string jsonInfo() {
        return R"({
        "name": ")" + name + R"(",
        "diameter": )" + std::to_string(diameter) + R"(,
        "isLifePossible": )" + (isLifePossible ? "true" : "false") + R"(,
        "numberOfSatellites": )" + std::to_string(numberOfSatellites) + R"(
    })";
    }


};
