#include <iostream>
#include <unistd.h>
#include <sys/socket.h>
#include <sys/un.h>

//const char* CONSUMER_SOCKET_PATH = "/tmp/consumer_output_socket";
//const char* SOCKET_PATH = "/var/run/producer_consumer/producer.sock";
const char* CONSUMER_SOCKET_PATH = "/tmp/producer_consumer/consumer.sock";

int main() {
    int sockFd = socket(AF_UNIX, SOCK_STREAM, 0);
    if (sockFd == -1) {
        perror("socket");
        return 1;
    }

    struct sockaddr_un addr;
    addr.sun_family = AF_UNIX;
    strncpy(addr.sun_path, CONSUMER_SOCKET_PATH, sizeof(addr.sun_path) - 1);

    if (connect(sockFd, (struct sockaddr*)&addr, sizeof(addr))) {
        perror("connect");
        close(sockFd);
        return 1;
    }

    char message[1024];
    while (true) {
        ssize_t bytesRead = read(sockFd, message, sizeof(message));
        if (bytesRead <= 0) break;
        message[bytesRead] = '\0';
        std::cout << message << std::endl;
    }

    close(sockFd);
    return 0;
}