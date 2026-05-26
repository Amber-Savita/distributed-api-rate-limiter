#pragma once

#include <string>

class RateLimiter {
public:
    // refill_rate: tokens per second, capacity: max tokens
    RateLimiter(const std::string& redis_host = "127.0.0.1", int redis_port = 6379,
                double refill_rate = 5.0/60.0, int capacity = 5);
    ~RateLimiter();

    // Returns true if request is allowed, false if rate-limited
    bool allow(const std::string& key);

private:
    struct Impl;
    Impl* pimpl_;
};
