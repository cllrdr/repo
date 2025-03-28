#include <vector>
#include <fstream>
#include <sstream>
#include <stdexcept>
#include "planet.cpp"


// Класс PlanetArray для работы с массивом планет
class PlanetArray {

public:

    std::vector<Planet> planets;  // Вектор для хранения планет

    // Добавление планеты в массив
    void addPlanet(const Planet& planet) {
        planets.push_back(planet);
    }

    // Удаление планеты по названию
    bool removePlanet(const std::string& name) {
        for (auto it = planets.begin(); it != planets.end(); ++it) {
            if (it->getName() == name) {
                planets.erase(it);
                return true;  // Планета найдена и удалена
            }
        }
        return false;  // Планета не найдена
    }

    // Поиск планеты по названию
    Planet* findPlanet(const std::string& name) {
        for (auto& planet : planets) {
            if (planet.getName() == name) {
                return &planet;  // Возвращаем указатель на найденную планету
            }
        }
        return nullptr;  // Планета не найдена
    }

    // Вывод информации о всех планетах
    void printAllPlanets() const {
        for (auto planet : planets) {
            planet.printInfo();
            std::cout << "-------------------" << std::endl;
        }
    }

    // Вывод информации о всех планетах
    void jsonAllPlanets() const {
        for (auto planet : planets) {
            std::cout << planet.jsonInfo();
            std::cout << std::endl << "-------------------" << std::endl;
        }
    }

    // Получение количества планет в массиве
    int getNumberOfPlanets() const {
        return planets.size();
    }
    
};