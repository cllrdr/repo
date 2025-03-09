#include <iostream>
#include <cmath>
#include <iomanip>

int main() {

    double x;
    double S;
    double Y;
    double e;
    double n;

        std::cout << std::setw(5) << 'x';
        std::cout << std::setw(15) << "Y(x)";
        std::cout << std::setw(15) << "S(x)";
        std::cout << std::setw(10) << 'n' << std::endl;

    for (x=0; x<=1; x+=0.2) {
        n = 0;
        S = std::pow(-1,n)*pow(x,2*n+3)/(2*n+1);
        Y = pow(x,2)*atan(x);
        e = fabs(S-Y);
        while (e>0.000001) {
            n = n + 1;
            S = S + pow(-1,n)*pow(x,2*n+3)/(2*n+1);
            Y = pow(x,2)*atan(x);
            e = fabs(S-Y);
            }
        std::cout << std::setw(5) << x;
        std::cout << std::setw(15) << Y;
        std::cout << std::setw(15) << S;
        std::cout << std::setw(10) << n << std::endl;
    }

    return 0;    

}


// Пример использования setw
//    std::cout << std::left;
//    std::cout << std::setw(COLUMN_WIDTH) << "Номер ряда" << std::setw(COLUMN_WIDTH) << "Первый элемент" << std::setw(COLUMN_WIDTH) << "Второй элемент" << std::endl;