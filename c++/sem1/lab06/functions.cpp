#include "header.h"

double function1(double x) {
      return x;
}

double function2(double x) {
      return sin(22*x);
}

double function3(double x) {
      return pow(x, 4);
}

double function4(double x) {
      return atan(x);
}

double IntRect(double (*function)(double), double a, double b, double eps, int i, int& count) {
      double dx = b - a;
      double S1 = 0;
      double S2 = function(a + dx/2) * dx;
      int n = 1;
      do {
          n *= 2;
          S1 = S2;
          S2 = 0;
          dx = (b - a)/n;
          for (int j = 0; j < n; ++j) {
              S2 = S2 + function(a + j*dx + dx/2) * dx;
          }
          count += 1;
      } while ( std::abs(S2 - S1) > eps );
      return S2;
}

double IntTrap(double a, double b, double eps, int i, int& count) {
      double (*function[])(double) = {function1, function2, function3, function4};
      double dx = b - a;
      double S1 = 0;
      double S2 = (function[i](a) + function[i](b)) * dx/2;
      int n = 1;
      do {
          n *= 2;
          S1 = S2;
          S2 = 0;
          dx /= 2;
          for (int j = 0; j < n; ++j) {
              S2 = S2 + (function[i](a + j*dx) + function[i](a + (j+1)*dx)) * dx/2;
          }
          count += 1;
      } while ( std::abs(S2 - S1) > eps );
      return S2;
}