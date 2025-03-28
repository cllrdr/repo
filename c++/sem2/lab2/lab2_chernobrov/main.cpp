#include "loader.cpp"  // Подключаем файл с классом Array

int main() {
    // Создаем объект PlanetArray
    Loader load;
    PlanetArray planetArray = load.loadFromCSV("data.csv");
  

    //// Создаем несколько планет
    //Planet earth("Земля", 12742.0, true, 1);
    //Planet mars("Марс", 6779.0, false, 2);
    //Planet jupiter("Юпитер", 139820.0, false, 79);

    //// Добавляем планеты в массив
    //planetArray.addPlanet(earth);
    //planetArray.addPlanet(mars);
    //planetArray.addPlanet(jupiter);

    // Выводим информацию о всех планетах
    std::cout << "Все планеты (в формате текста):" << std::endl;
    planetArray.printAllPlanets();

    // Поиск планеты по названию
    std::string planetName = "Марс";
    Planet* foundPlanet = planetArray.findPlanet(planetName);
    if (foundPlanet) {
        std::cout << "Планета найдена: " << foundPlanet->getName() << std::endl;
    } else {
        std::cout << "Планета не найдена." << std::endl;
    }

    // Удаление планеты по названию
    std::string planetToRemove = "Mars";
    if (planetArray.removePlanet(planetToRemove)) {
        std::cout << "Планета " << planetToRemove << " удалена." << std::endl;
    } else {
        std::cout << "Планета " << planetToRemove << " не найдена." << std::endl;
    }

    // Выводим информацию о всех планетах после удаления
    std::cout << "Все планеты после удаления (в json виде):" << std::endl;
    //planetArray.printAllPlanets();
    planetArray.jsonAllPlanets();

    // Получаем количество планет в массиве
    std::cout << "Количество планет: " << planetArray.getNumberOfPlanets() << std::endl;

    return 0;
}