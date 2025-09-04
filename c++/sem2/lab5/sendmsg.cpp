#include <iostream>
#include <unistd.h>
#include <sys/socket.h>
#include <sys/un.h>

//const char* SOCKET_PATH = "/tmp/producer_consumer_socket";
const char* SOCKET_PATH = "/tmp/producer_consumer/producer.sock";
//const char* CONSUMER_SOCKET_PATH = "/var/run/producer_consumer/consumer.sock";

int main(int argc, char* argv[]) {
    if (argc < 2) {
        std::cerr << "Usage: sendmsg <message>" << std::endl;
        return 1;
    }

    int sockFd = socket(AF_UNIX, SOCK_STREAM, 0);
    if (sockFd == -1) {
        perror("socket");
        return 1;
    }

    struct sockaddr_un addr;
    addr.sun_family = AF_UNIX;
    strncpy(addr.sun_path, SOCKET_PATH, sizeof(addr.sun_path) - 1);

    if (connect(sockFd, (struct sockaddr*)&addr, sizeof(addr))) {
        perror("connect");
        close(sockFd);
        return 1;
    }

    std::string message = argv[1];
    if (write(sockFd, message.c_str(), message.size()) == -1) {
        perror("write");
    }

    close(sockFd);
    return 0;
}