#include "header.h"

void newton(double eps, int k) {

    double x;
    int i=0;

    std::cout << "Метод Ньютона" << std::endl;
    std::cout << "Стартовый x = ";
    std::cin >> x;

    while (fabs(function(x, k)) > eps) {
        x = x - function(x, k)/(1 + k*sin(x));
        i += 1;
        
//       std::cout << "Шаг "<< i << std::endl;
//       std::cout << function(x, k) << std::endl;
//       std::cout << x << std::endl;

    }

    std::cout << "Кол-во итераций n = "<< i << std::endl;
    std::cout << "x = " << x << std::endl;
    std::cout << std::endl;

}