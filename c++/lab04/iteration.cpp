#include "header.h"

void iteration(double eps, int k) {

    double xStart, xEnd, xStartTmp;
    int i=0;

    std::cout << "Метод итераций" << std::endl;
    std::cout << "Стартовый x = ";
    std::cin >> xStart;

    do {
        xEnd = k*cos(xStart);
        xStartTmp = xStart;
        xStart = xEnd;
        i += 1;
    } while (fabs(function(xStartTmp, k)) > eps);
        
//       std::cout << "Шаг "<< i << std::endl;
//       std::cout << function(x, k) << std::endl;
//       std::cout << x << std::endl;

    std::cout << "Кол-во итераций n = "<< i << std::endl;
    std::cout << "x = " << xEnd << std::endl;
    std::cout << std::endl;

}