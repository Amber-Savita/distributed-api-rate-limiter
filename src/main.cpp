#include "../include/rate_limiter.h"
#include "../external/crow/crow_all.h"

#include <iostream>

int main()
{
    try
    {
        RateLimiter limiter("127.0.0.1", 6379, 5.0 / 60.0, 5);

        crow::SimpleApp app;

        CROW_ROUTE(app, "/request").methods("POST"_method)([&limiter](const crow::request &req)
                                                           {
            auto body = crow::json::load(req.body);
            if (!body) return crow::response(400);
            std::string user;
            if (body.has("user") && body["user"].t() == crow::json::type::String) user = body["user"].s();
            if (user.empty()) return crow::response(400);

            bool ok = limiter.allow(user);
            crow::json::wvalue res;
            res["status"] = ok ? "allowed" : "blocked";
            crow::response r(ok ? 200 : 429);
            r.set_header("Content-Type", "application/json");
            r.write(res.dump());
            return r; });

        std::cout << "Starting server on :18080\n";
        app.port(18080).multithreaded().run();
    }
    catch (const std::exception &e)
    {
        std::cerr << "Fatal error: " << e.what() << std::endl;
        return 1;
    }
    return 0;
}
