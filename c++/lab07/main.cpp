#include <iostream>
#include <fstream>
#include <string>
#include <cstring>

#define MAX_WORDS 100  // Максимальное количество слов в файле key.txt
#define MAX_PLAINTEXT_LENGTH 1024  // Максимальная длина строки в файле text.txt

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
    textFile.getline(plaintext, MAX_PLAINTEXT_LENGTH);
    textFile.close();

    // Чтение ключей из файла key.txt
    std::ifstream keyFile("key.txt");
    if (!keyFile.is_open()) {
        std::cerr << "Ошибка открытия файла key.txt" << std::endl;
        return 1;
    }
    char words[MAX_WORDS][MAX_PLAINTEXT_LENGTH];
    int numWords = 0;
    while (keyFile.getline(words[numWords], MAX_PLAINTEXT_LENGTH)) {
        numWords++;
    }
    keyFile.close();

    // Расчет шагов шифрования
    int steps[MAX_WORDS];
    for (int i = 0; i < numWords; i++) {
        steps[i] = calculateStep(words[i]);
    }

    // Шифрование строки
    encryptString(plaintext, steps, numWords);

    // Запись зашифрованной строки в файл encode.txt
    std::ofstream encodeFile("encode.txt");
    if (!encodeFile.is_open()) {
        std::cerr << "Ошибка открытия файла encode.txt" << std::endl;
        return 1;
    }
    encodeFile << plaintext;
    encodeFile.close();

    std::cout << "Шифровка завершена. Результат сохранён в файл encode.txt" << std::endl;

    // Чтение зашифрованной строки из файла encode.txt
    std::ifstream inputFile("encode.txt");
    if (!inputFile.is_open()) {
        std::cerr << "Ошибка открытия файла encode.txt" << std::endl;
        return 1;
    }
    char ciphertext[MAX_PLAINTEXT_LENGTH];
    inputFile.getline(ciphertext, MAX_PLAINTEXT_LENGTH);
    inputFile.close();

    // Расшифровка строки
    decryptString(ciphertext, steps, numWords);

    // Запись расшифрованной строки в файл decode.txt
    std::ofstream decodeFile("decode.txt");
    if (!decodeFile.is_open()) {
        std::cerr << "Ошибка открытия файла decode.txt" << std::endl;
        return 1;
    }
    decodeFile << ciphertext;
    decodeFile.close();

    std::cout << "Расшифровка завершена. Результат сохранён в файл decode.txt" << std::endl;

    return 0;
}