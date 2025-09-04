#include "RingBuffer.h"
#include <iostream>
#include <thread>
#include <unistd.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <csignal>
#include <fstream>

const char* PRODUCER_SOCKET_PATH = "/tmp/producer_consumer/producer.sock";
const char* CONSUMER_SOCKET_PATH = "/tmp/producer_consumer/consumer.sock";
RingBuffer buffer(10);  // Буфер на 10 сообщений
std::ofstream logFile("/var/log/producer_consumer.log");

void producerService() {
    int serverFd, clientFd;
    struct sockaddr_un serverAddr, clientAddr;
    socklen_t clientLen = sizeof(clientAddr);

    unlink(PRODUCER_SOCKET_PATH);

    serverFd = socket(AF_UNIX, SOCK_STREAM, 0);
    if (serverFd == -1) {
        perror("socket");
        exit(1);
    }

    serverAddr.sun_family = AF_UNIX;
    strcpy(serverAddr.sun_path, PRODUCER_SOCKET_PATH);

    if (bind(serverFd, (struct sockaddr*)&serverAddr, sizeof(serverAddr))) {
        perror("bind");
        exit(1);
    }

    if (listen(serverFd, 5)) {
        perror("listen");
        exit(1);
    }

    while (true) {
        clientFd = accept(serverFd, (struct sockaddr*)&clientAddr, &clientLen);
        if (clientFd == -1) {
            perror("accept");
            continue;
        }

        char message[1024];
        ssize_t bytesRead = read(clientFd, message, sizeof(message));
        if (bytesRead > 0) {
            message[bytesRead] = '\0';
            buffer.push(std::string(message));
            logFile << "Received: " << message << std::endl;
        }
        close(clientFd);
    }
}

void consumerService() {
    int serverFd, clientFd;
    struct sockaddr_un serverAddr, clientAddr;
    socklen_t clientLen = sizeof(clientAddr);

    unlink(CONSUMER_SOCKET_PATH);

    serverFd = socket(AF_UNIX, SOCK_STREAM, 0);
    if (serverFd == -1) {
        perror("socket");
        exit(1);
    }

    serverAddr.sun_family = AF_UNIX;
    strcpy(serverAddr.sun_path, CONSUMER_SOCKET_PATH);

    if (bind(serverFd, (struct sockaddr*)&serverAddr, sizeof(serverAddr))) {
        perror("bind");
        exit(1);
    }

    if (listen(serverFd, 5)) {
        perror("listen");
        exit(1);
    }

    while (true) {
        clientFd = accept(serverFd, (struct sockaddr*)&clientAddr, &clientLen);
        if (clientFd == -1) {
            perror("accept");
            continue;
        }

        while (true) {
            std::string message = buffer.pop();
            write(clientFd, message.c_str(), message.size());
            logFile << "Consumed: " << message << std::endl;
        }
    }
}

int main() {
    std::thread producerThread(producerService);
    std::thread consumerThread(consumerService);

    producerThread.detach();
    consumerThread.detach();

    pause();  // Ожидаем сигнал для завершения
    return 0;
}