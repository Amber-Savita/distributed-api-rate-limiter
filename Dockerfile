# Build stage
FROM ubuntu:22.04 as builder

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    libhiredis-dev \
    libasio-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy project files
COPY CMakeLists.txt ./
COPY include/ ./include/
COPY src/ ./src/
COPY external/ ./external/

# Download Crow if not present
RUN if [ ! -f external/crow_all.h ]; then \
    mkdir -p external && \
    curl -sSL https://raw.githubusercontent.com/CrowCpp/Crow/master/include/crow_all.h -o external/crow_all.h; \
    fi

# Build the project
RUN mkdir -p build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    cmake --build .

# Runtime stage
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    redis-server \
    libhiredis-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy the built executable
COPY --from=builder /app/build/rate_limiter ./

# Expose ports
EXPOSE 6379 18080

# Start Redis and the rate limiter
CMD redis-server --daemonize yes && \
    echo "Starting distributed rate limiter..." && \
    ./rate_limiter
