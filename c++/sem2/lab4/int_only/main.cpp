#include <iostream>
#include <string>
#include "stack.cpp"


void test_int(Stack<int> &x) {
        
    x.push(5);
    x.push(23);
    std::cout << x.top_inf() << std::endl;

}

void test_string(Stack<std::string> &x) {
        
    x.push("alex");
    x.push("john");
    std::cout << x.top_inf() << std::endl;

}


int main() {

    ArrayStack<int> a;
    Stack<int>& link_a = a;
    test_int(link_a);

    ListStack<int> b;
    Stack<int>& link_b = b;
    test_int(link_b);

    ArrayStack<std::string> str1;
    Stack<std::string>& link_str1 = str1;
    test_string(link_str1);

    ListStack<std::string> str2;
    Stack<std::string>& link_str2 = str2;
    test_string(link_str2);

    return 0;

}