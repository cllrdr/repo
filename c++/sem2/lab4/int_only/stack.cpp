#include <iostream>

template <typename T>
class Stack {
    
    public:        
       virtual bool empty() = 0;       
       virtual bool push(T d) = 0;       
       virtual bool pop() = 0;         
       virtual T top_inf() = 0;

};

// Класс стека на основе односвязного списка
template <typename T>
class ListStack : public Stack<T> {
    private:
        // Узел списка
        struct Node {
            T data;
            Node* next;
            Node(T d) : data(d), next(nullptr) {}
        };
        
        Node* top_node; // Вершина стека
    
    public:
        // Конструктор
        ListStack() : top_node(nullptr) {}
        
        // Деструктор
        ~ListStack() {
            while (!empty()) {
                pop();
            }
        }
        
        // Проверка на пустоту
        bool empty() {
            return top_node == nullptr;
        }
        
        // Добавление элемента
        bool push(T d) {
            Node* new_node = new Node(d);
            new_node->next = top_node;
            top_node = new_node;
            return true;
        }
        
        // Удаление элемента
        bool pop() {
            if (empty()) {
                return false;
            }
            Node* temp = top_node;
            top_node = top_node->next;
            delete temp;
            return true;
        }
        
        // Получение верхнего элемента
        T top_inf() {
            if (empty()) {
                std::cerr << "Stack is empty!" << std::endl;
                return 0;
            }
            return top_node->data;
        }

    };

template <typename T>
class ArrayStack : public Stack<T> {
    private:
        int i;
        int size; 
        T* data;
             
    public:
        ArrayStack() : i(0), size(1) {
            data = new T[size];
        }
    
        ~ArrayStack() {
            delete[] data;
        }

        bool empty() {
            return size == 0;
        }
    
        bool push(T d) {
            if (i == size) { 
                size = size*2;
                T* data_tmp = new T[size];
                for (int j=0; j < i; j++) {
                    data_tmp[j] = data[j];
                }
                delete[] data;
                data = new T[size];
                data = data_tmp;            
            }
            data[i++] = d;
            return true;
        }
    
        bool pop() {
            if (empty()) {
                return false;
            }
            --i;
            return true;
        }
    
        T top_inf() {
            if (empty()) {
                std::cerr << "Stack is empty!\n";
                return 0;  // Можно бросить исключение вместо возврата 0
            }
            return data[i - 1];
        }
    };