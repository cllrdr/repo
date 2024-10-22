#include <iostream>

// Найдите сумму натуральных чисел, которые делятся на 5 и не делятся на m (m<n).
// Количество натуральных чисел n и значение m введите с клавиатуры.

int main() {
    
    int m;
    int n;
    int sum=0;

// ввод m, n
    std::cout << "Введите m:" << std::endl;
    std::cin >> m;
    std::cout << "Введите n:" << std::endl;
    std::cin >> n;
    if (m > n) {
        std::cout << "Введено m > n, решений нет" << std::endl;
        return 0;
    }
// находим ближайшее меньшее n, которое кратно 5, и перебираем с шагом 5 все значания n до 0
    n = n - n%5;
    while (n > 0) { 
        if (n%m != 0) { sum = sum + n; }
        n = n - 5;
    }

    std::cout << "Ответ: " << sum << std::endl;
    return 0;
}