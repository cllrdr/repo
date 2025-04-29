// Файл MyStack.cpp
#include "stack.h"
#include <stdexcept>

// Конструктор стека
template<class INF>
MyStack<INF>::MyStack(void) {
    top = nullptr;
}

// Деструктор стека - освобождает память
template<class INF>
MyStack<INF>::~MyStack(void) {
    while (!empty()) {
        pop();
    }
}

// Проверка на пустоту стека
template<class INF>
bool MyStack<INF>::empty(void) {
    return top == nullptr;
}

// Добавление элемента в вершину стека
template<class INF>
bool MyStack<INF>::push(INF n) {
    Node *newNode = new Node;
    newNode->d = n;
    newNode->next = top;
    top = newNode;
    return true;
}

// Удаление элемента из вершины стека
template<class INF>
bool MyStack<INF>::pop(void) {
    if (empty()) {
        return false;
    }
    
    Node *temp = top;
    top = top->next;
    delete temp;
    return true;
}

// Получение информации из вершины стека
template<class INF>
INF MyStack<INF>::top_inf(void) {
    if (empty()) {
        throw std::runtime_error("Stack is empty");
    }
    return top->d;
}