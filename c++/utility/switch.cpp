#include <iostream>

int main() {
    int grade;
    std::cin >> grade;
    switch (grade) {
        case 1:
            std::cout << "Отлично!" << std::endl;
            break;
        case 4:
            std::cout << "Хорошо!" << std::endl;
            break;
        case 3:
            std::cout << "Удовлетворительно." << std::endl;
            break;
        default:
            std::cout << "Неизвестный символ." << std::endl;
            break;
    }
}
