#include "header.h"

int main() {

    double x, a = -1, b = 3;
    int count;
    const int N = 4;
    I_print arr[N];
    double (*function[])(double) = {function1, function2, function3, function4};
    const char* name_arr[N] = {"y = x", "y = sin(22x)", "y = x^4", "y = arctg(x)"};
    double i_toch_arr[N] = {
        (b*b - a*a)/2.0,
        (cos(a*22.0) - cos(b*22.0))/22.0,
        (b*b*b*b*b - a*a*a*a*a)/5.0,
        b*atan(b) - a*atan(a) - (log(b*b+1) - log(a*a+1))/2.0  
    };

    for (int i = 0; i < N; ++i) {
        arr[i].name = new char [strlen(name_arr[i]) + 1];
        strcpy(arr[i].name, name_arr[i]);
        arr[i].i_toch = i_toch_arr[i];
    };

    for (double eps = 0.1; eps > 1e-6; eps /= 10) {
        for (int i = 0; i < N; ++i) {        
            arr[i].i_sum = IntRect(function[i], a, b, eps, i, arr[i].n = 0);
        }

        std::cout << "Точность: " << eps << std::endl;
        PrintTabl(arr, N);
        std::cout << std::endl;
    }

    for (double eps = 0.1; eps > 1e-6; eps /= 10) {
        for (int i = 0; i < N; ++i) {        
            arr[i].i_sum = IntTrap(a, b, eps, i, count = 0);
            arr[i].n = count;
        }

        std::cout << "Точность: " << eps << std::endl;
        PrintTabl(arr, N);
        std::cout << std::endl;
    }

    return 0;
}