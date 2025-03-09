#include <iostream>

int main() {

    char name[15];
    std::cout << "G++ version: " << __GNUC__ << "." << __GNUC_MINOR__ << std::endl;
    std::cout << "Hello, what's your name? \n";
    std::cin >> name;
    std::cout << "Your name is " << name << std::endl;
    return 0;

}