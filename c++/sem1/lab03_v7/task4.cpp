#include <iostream>
#include <cmath>
#include <iomanip>

int main() {

    int n;
    double y;
    double start;

    std::cout << "Введите n: ";
    std::cin >> n;

    start = pow(2*n+1, 0.5);

    if (n == 0) {
    std::cout << std::fixed << std::setprecision(4) << start << std::endl;    
    }

    while (n > 0) {
        start = pow(2*(n-1)+1 + start, 0.5);
        n -= 1;
    }

    std::cout << "Результат: ";
    std::cout << std::fixed << std::setprecision(4) << start << std::endl;
}