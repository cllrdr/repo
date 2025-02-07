#include <iostream>
#include <fstream>
#include <string>
#include <cstring>

#define MAX_KEYS 100  // Максимальное количество слов в файле key.txt
#define MAX_PLAINTEXT_LENGTH 1024  // Максимальное кол-во символов в файле text.txt

// Функция для расчета шага шифрования на основе слова
int calculateStep(char* word) {
    int step = 0;
    for (int i = 0; word[i] != '\0'; i++) {
        step += (int)word[i];
    }
    return step % 26; // Ограничиваем шаг диапазоном алфавита (26 символов)
}

// Функция для шифрования строки с использованием шифра Цезаря
void encryptString(char* plaintext, int* steps, int numSteps) {
    int index = 0;
    for (int i = 0; plaintext[i] != '\0'; i++) {
        if (plaintext[i] >= 'a' && plaintext[i] <= 'z') {
            int shift = steps[index % numSteps];
            plaintext[i] = (plaintext[i] - 'a' + shift) % 26 + 'a'; // Применение шифра Цезаря
            index++;
        }
    }
}

// Функция для расшифровки строки с использованием шифра Цезаря
void decryptString(char* ciphertext, int* steps, int numSteps) {
    int index = 0;
    for (int i = 0; ciphertext[i] != '\0'; i++) {
        if (ciphertext[i] >= 'a' && ciphertext[i] <= 'z') {
            int shift = steps[index % numSteps];
            ciphertext[i] = (ciphertext[i] - 'a' - shift + 26) % 26 + 'a'; // Применение обратного шифра Цезаря
            index++;
        }
    }
}

int main() {
    // Чтение текста из файла text.txt
    std::ifstream textFile("text.txt");
    if (!textFile.is_open()) {
        std::cerr << "Ошибка открытия файла text.txt" << std::endl;
        return 1;
    }
    char plaintext[MAX_PLAINTEXT_LENGTH];
    textFile.read(plaintext, MAX_PLAINTEXT_LENGTH);
    textFile.close();

    std::cout << "исходный текст:" << std::endl << plaintext << std::endl; 

    // Чтение ключей из файла key.txt
    const int maxWordLength = 50; // Максимальная длина одного слова
    char buffer[maxWordLength]; // Буфер для временного хранения слов
    char keys[MAX_KEYS][maxWordLength]; // Массив для хранения всех слов
    int numKeys = 0; // Количество слов в массиве

    std::ifstream keyFile("key.txt");
    if (!keyFile.is_open()) {
        std::cout << "Ошибка открытия файла key.txt" << std::endl;
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

    std::cout << "Список слов для ключей:" << std::endl;
    for (int i = 0; i < numKeys; ++i) {
        std::cout << keys[i] << std::endl;
    }

    // Расчет шагов шифрования
    int steps[MAX_KEYS];
    for (int i = 0; i < numKeys; i++) {
        steps[i] = calculateStep(keys[i]);
    }

    std::cout << "Список ключей:" << std::endl;
    for (int i = 0; i < numKeys; ++i) {
        std::cout << steps[i] << std::endl;
    }

    // Шифрование строки
    encryptString(plaintext, steps, numKeys);

    // Запись зашифрованной строки в файл encode.txt
    std::ofstream encodeFile("encode.txt", std::ios::binary);
    if (!encodeFile.is_open()) {
        std::cerr << "Ошибка открытия файла encode.txt" << std::endl;
        return 1;
    }

//    for (int i = 0; strlen(plaintext); i++) {
//        encodeFile << plaintext[i];
    encodeFile.write(plaintext, strlen(plaintext));
//    }
    encodeFile.close();

    std::cout << "Шифровка завершена. Результат сохранён в файл encode.txt" << std::endl;

    // Чтение зашифрованной строки из файла encode.txt
    std::ifstream inputFile("encode.txt");
    if (!inputFile.is_open()) {
        std::cerr << "Ошибка открытия файла encode.txt" << std::endl;
        return 1;
    }
    char ciphertext[MAX_PLAINTEXT_LENGTH];
    inputFile.read(ciphertext, MAX_PLAINTEXT_LENGTH);
    inputFile.close();

    std::cout << ciphertext << std::endl;

    // Расшифровка строки
    decryptString(ciphertext, steps, numKeys);

    // Запись расшифрованной строки в файл decode.txt
    std::ofstream decodeFile("decode.txt");
    if (!decodeFile.is_open()) {
        std::cerr << "Ошибка открытия файла decode.txt" << std::endl;
        return 1;
    }
    decodeFile << ciphertext;
    decodeFile.close();

    std::cout << "Расшифровка завершена. Результат сохранён в файл decode.txt" << std::endl;

    std::cout  << ciphertext << std::endl;

    return 0;
}