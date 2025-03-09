#include "header.h"

int main() {

    int k, n;
    double eps;

    std::cout << "Введите требуюмую точность eps = 10e";
    std::cin >> n;
    eps = pow(10, n);
    std::cout << "Введите k = ";
    std::cin >> k;
    std::cout << std::endl;    

    halfer(eps, k);
    newton(eps, k);
    iteration(eps,k);

    return 0;

}