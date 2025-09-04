#pragma once
#include <vector>
#include <string>
#include <mutex>
#include <condition_variable>

class RingBuffer {
public:
    explicit RingBuffer(size_t capacity);
    
    // Добавление сообщения (блокируется, если буфер полон)
    void push(const std::string& message);
    
    // Извлечение сообщения (блокируется, если буфер пуст)
    std::string pop();
    
    // Итератор для обхода сообщений
    class Iterator {
    public:
        Iterator(RingBuffer& buffer, size_t index);
        std::string next();  // Получить следующее сообщение
        bool hasNext() const;  // Есть ли еще сообщения?
    private:
        RingBuffer& buffer_;
        size_t currentIndex_;
    };
    
    Iterator iter();  // Создать итератор

private:
    std::vector<std::string> buffer_;
    size_t capacity_;
    size_t head_ = 0;  // Индекс для чтения
    size_t tail_ = 0;  // Индекс для записи
    size_t size_ = 0;  // Текущее количество элементов
    
    std::mutex mutex_;
    std::condition_variable notEmpty_;  // Ожидание, пока буфер не пуст
    std::condition_variable notFull_;   // Ожидание, пока буфер не полон
};