#include <iostream>
#include <iomanip>

int main() {

    double a;
    double S = 1;

    std::cout << "Введите a:" << std::endl;
    std::cin >> a;

    if ( a >= 0) {
        for (int i=2; i<=8; i+=2) {
            S=S*(i*i);
            }
            S=S-a;
        }
    else {
        for (int i=3; i<=9; i+=3) {S=S*(i-2);}
    }
    
    std::cout << std::fixed << std::setprecision(3) << S << std::endl;

    return 0; 
}