#include <iostream>

int main() {

    int a = 7;
    int *p;

    p = &a;

    int **pp = &p;

    std::cout << a << ' ' << &a << ' ' << p << std::endl;
    std::cout << *p << std::endl;
    std::cout << *pp << std::endl;
    std::cout << **pp << std::endl;

    **pp+=1;
    std::cout << a << std::endl;

    std::cout << std::endl;

    int b = 10;
    int &ref = b; // создание ссылки ref



    return 0;

}