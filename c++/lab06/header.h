#pragma once
#include <iostream>
#include <cmath>
#include <iomanip>
#include <random>
#include <cstring>

struct I_print{ //данные для печати результатов интегрирования
 char* name;//название функции
 double i_sum; //значение интегральной суммы
 double i_toch; //точное значение интеграла
 int n; //число разбиений области интегрирования 
   //при котором достигнута требуемая точность
};

void PrintTabl(I_print*, int);
double function1(double);
double function2(double);
double function3(double);
double function4(double);
