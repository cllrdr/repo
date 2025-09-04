#include "RingBuffer.h"
#include <iostream>
#include <thread>

void producer(RingBuffer& buffer) {
    for (int i = 0; i < 10; ++i) {
        std::string message = "Message " + std::to_string(i);
        buffer.push(message);
        std::cout << "Produced: " << message << std::endl;
        std::this_thread::sleep_for(std::chrono::milliseconds(100));
    }
}

void consumer(RingBuffer& buffer) {
    for (int i = 0; i < 10; ++i) {
        std::string message = buffer.pop();
        std::cout << "Consumed: " << message << std::endl;
        std::this_thread::sleep_for(std::chrono::milliseconds(150));
    }
}

int main() {
    RingBuffer buffer(5);  // Буфер на 5 сообщений

    std::thread producerThread(producer, std::ref(buffer));
    std::thread consumerThread(consumer, std::ref(buffer));

    producerThread.join();
    consumerThread.join();

    // Тест итератора
    RingBuffer::Iterator it = buffer.iter();
    while (it.hasNext()) {
        std::cout << "Iter: " << it.next() << std::endl;
    }

    return 0;
}