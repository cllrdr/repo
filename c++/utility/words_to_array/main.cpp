#include <iostream>
#include <fstream>
#include <cstring>

// Максимальное количество слов в файле
#define MAX_keys 1000

int main() {
    const int maxWordLength = 50; // Максимальная длина одного слова
    
    char buffer[maxWordLength]; // Буфер для временного хранения слов
    char keys[MAX_keys][maxWordLength]; // Массив для хранения всех слов
    int numKeys = 0; // Количество слов в массиве

    std::ifstream keyFile("input.txt");

    if (!keyFile.is_open()) {
        std::cout << "error";
        return 1;
    }

    keyFile.read(buffer, sizeof(buffer)); // Чтение блока данных
    int length = strlen(buffer); // Длина прочитанного блока
    int start = 0; // Начальная позиция слова в блоке
    for (int i = 0; i <= length; ++i) {
        if (buffer[i] == ' ' or buffer[i] == '\n' or buffer[i] == '\0') { // Найдено слово
            strncpy(keys[numKeys], &buffer[start], i - start); // Копируем слово в массив
            start = i + 1; // Сдвигаем начальную позицию к следующему слову
            ++numKeys; // Увеличиваем счётчик слов
        }
    }
    
    memset(buffer, 0, sizeof(buffer)); // Очищаем буфер
    keyFile.close();

    for (int i = 0; i < numKeys; ++i) {
        std::cout << keys[i] << "\n"; // Выводим каждое слово
    }

    return 0;
}