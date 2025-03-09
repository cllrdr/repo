#include <iostream>

#define GOODBYE std::cout << "Goodbye World" << std::endl; 
//#define KIDDING

int main() {
    std::cout << "Hello WOrld" << std::endl;
    GOODBYE;

#ifdef KIDDING
    std::cout << "Just kidding" << std::endl;
#endif

}