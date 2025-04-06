#include "array.cpp"

// Класс PlanetArray для работы с массивом планет
class Loader {

public:

    // Метод для загрузки планет из CSV-файла
    PlanetArray loadFromCSV(const std::string& filename) {

        PlanetArray planets;
        std::ifstream file(filename);

        if (!file.is_open()) {
            throw std::runtime_error("Failed to open file: " + filename);
        }

        std::string line;
        while (std::getline(file, line)) {
            std::stringstream ss(line);
            std::string token;
            std::vector<std::string> tokens;

            // Разбиваем строку на токены по запятым
            while (std::getline(ss, token, ',')) {
                tokens.push_back(token);
            }

            // Проверяем, что строка содержит все необходимые поля
            if (tokens.size() != 4) {
                continue; // Пропускаем некорректные строки
            }
            std::string name = tokens[0];
            
            try {
                Planet p(
                    name, 
                    std::stod(tokens[1]), 
                    std::stoi(tokens[2]) != 0, 
                    std::stoi(tokens[3])
                );
                planets.addPlanet(p);
            } catch (const std::exception& e) {
                // Пропускаем строки с некорректными данными
                continue;
             }
            // Создаем и добавляем планету в вектор
            

        } return planets;    
    }
};