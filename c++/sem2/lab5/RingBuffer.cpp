#include "RingBuffer.h"
#include <stdexcept>

RingBuffer::RingBuffer(size_t capacity) 
    : capacity_(capacity), buffer_(capacity) {}

void RingBuffer::push(const std::string& message) {
    std::unique_lock<std::mutex> lock(mutex_);
    notFull_.wait(lock, [this] { return size_ < capacity_; });
    
    buffer_[tail_] = message;
    tail_ = (tail_ + 1) % capacity_;
    ++size_;
    
    notEmpty_.notify_one();
}

std::string RingBuffer::pop() {
    std::unique_lock<std::mutex> lock(mutex_);
    notEmpty_.wait(lock, [this] { return size_ > 0; });
    
    std::string message = buffer_[head_];
    head_ = (head_ + 1) % capacity_;
    --size_;
    
    notFull_.notify_one();
    return message;
}

// Итератор
RingBuffer::Iterator RingBuffer::iter() {
    return Iterator(*this, head_);
}

RingBuffer::Iterator::Iterator(RingBuffer& buffer, size_t index)
    : buffer_(buffer), currentIndex_(index) {}

std::string RingBuffer::Iterator::next() {
    if (!hasNext()) {
        throw std::runtime_error("No more messages");
    }
    std::string message = buffer_.buffer_[currentIndex_];
    currentIndex_ = (currentIndex_ + 1) % buffer_.capacity_;
    return message;
}

bool RingBuffer::Iterator::hasNext() const {
    return currentIndex_ != buffer_.tail_ || buffer_.size_ == buffer_.capacity_;
}