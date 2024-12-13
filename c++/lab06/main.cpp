#include "header.h"

int main() {

    bool flag;
    double x, a = -1, b = 3, dx, delta, S1, S2;
    const int N = 4;
    I_print arr[N];
    double (*function[])(double) = {function1, function2, function3, function4};

    arr[0].name = "y = x";
    arr[1].name = "y = sin(22x)";
    arr[2].name = "y = x^4";
    arr[3].name = "y = arctg(x)";

    arr[0].i_toch = (b*b - a*a)/2.0;
    arr[1].i_toch = (cos(a*22.0) - cos(b*22.0))/22.0;
    arr[2].i_toch = (b*b*b*b*b - a*a*a*a*a)/5.0;
    arr[3].i_toch = b*atan(b) - a*atan(a) - (log(b*b+1) - log(a*a+1))/2.0;

    for (double eps = 0.1; eps > 1e-6; eps /= 10) {
        for (int i = 0; i < N; ++i) {
            dx = b - a;
            S2 = function[i](a + dx/2) * dx;
            int n = 1;
            int count = 0;
            do {
                n *= 2;
                S1 = S2;
                S2 = 0;
                dx = (b - a)/n;
                for (int j = 0; j < n; ++j) {
                    S2 = S2 + function[i](a + j*dx + dx/2) * dx;
                }
                count += 1;
            } while ( std::abs(S2 - S1) > eps );
            
            arr[i].i_sum = S2;
            arr[i].n = count;
        }

        std::cout << "Точность: " << eps << std::endl;
        PrintTabl(arr, N);
        std::cout << std::endl;
    }

    return 0;
}