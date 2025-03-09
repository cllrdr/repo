#include "header.h"

void halfer(double eps, int k) {

    double x, a, b;
    int i=0;

    std::cout << "Метод половинного деления" << std::endl;
    std::cout << "Введите a = ";
    std::cin >> a;
    std::cout << "Введите b = ";
    std::cin >> b;

    if (function(a, k)*function(b, k) >= 0) {
        std::cout << "Неверные a, b" << std::endl;        
        return;
    }

    while (fabs(a-b) > eps) {
        x = (a + b)/2;
        if (function(a, k)*function(x, k)>0) {
            a = x;
        } else b = x;

        i += 1;
//        std::cout << "Шаг "<< i << std::endl;
//        std::cout << function(x, k) << std::endl;
//        std::cout << x << std::endl;
    }
    
    std::cout << "Кол-во итераций: "<< i << std::endl;
    std::cout << "x = "<< x << std::endl;
    std::cout << std::endl;

}