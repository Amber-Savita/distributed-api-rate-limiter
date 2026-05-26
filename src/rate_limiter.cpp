#include "../include/rate_limiter.h"
#include <hiredis/hiredis.h>
#include <chrono>
#include <string>
#include <memory>
#include <cstdlib>

struct RateLimiter::Impl {
    redisContext* c;
    double refill_rate;
    int capacity;
    std::string script;

    Impl(const std::string& host, int port, double refill, int cap)
        : c(nullptr), refill_rate(refill), capacity(cap) {
        c = redisConnect(host.c_str(), port);
        script =
            "local key = KEYS[1]\n"
            "local now = tonumber(ARGV[1])\n"
            "local refill = tonumber(ARGV[2])\n"
            "local capacity = tonumber(ARGV[3])\n"
            "local requested = tonumber(ARGV[4])\n"
            "local data = redis.call('HMGET', key, 'tokens', 'timestamp')\n"
            "local tokens = tonumber(data[1]) or capacity\n"
            "local ts = tonumber(data[2]) or now\n"
            "local delta = math.max(0, now - ts)\n"
            "tokens = math.min(capacity, tokens + delta * refill)\n"
            "local allowed = tokens >= requested\n"
            "if allowed then tokens = tokens - requested end\n"
            "redis.call('HMSET', key, 'tokens', tokens, 'timestamp', now)\n"
            "redis.call('EXPIRE', key, 3600)\n"
            "if allowed then return 1 else return 0 end\n";
    }

    ~Impl() {
        if (c) redisFree(c);
    }
};

RateLimiter::RateLimiter(const std::string& redis_host, int redis_port, double refill_rate, int capacity)
    : pimpl_(new Impl(redis_host, redis_port, refill_rate, capacity)) {}

RateLimiter::~RateLimiter() { delete pimpl_; }

bool RateLimiter::allow(const std::string& key) {
    if (!pimpl_->c) return false;
    using namespace std::chrono;
    double now = duration_cast<duration<double>>(system_clock::now().time_since_epoch()).count();
    int requested = 1;

    // Call EVAL with the script. Script and arguments are passed via printf-style formatting.
    redisReply* reply = (redisReply*)redisCommand(pimpl_->c,
        "EVAL %s 1 %s %f %f %d %d",
        pimpl_->script.c_str(), key.c_str(), now, pimpl_->refill_rate, pimpl_->capacity, requested);

    if (!reply) return false;
    bool allowed = false;
    if (reply->type == REDIS_REPLY_INTEGER) allowed = (reply->integer == 1);
    freeReplyObject(reply);
    return allowed;
}
