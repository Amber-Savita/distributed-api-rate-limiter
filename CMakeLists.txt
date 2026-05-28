cmake_minimum_required(VERSION 3.5)
project(distributed_rate_limiter)

set(CMAKE_CXX_STANDARD 17)

include_directories(
    ${CMAKE_SOURCE_DIR}/include
    ${CMAKE_SOURCE_DIR}/external
)

add_executable(rate_limiter src/main.cpp src/rate_limiter.cpp)

# Try to find hiredis from system
find_library(HIREDIS_LIB hiredis)
find_path(HIREDIS_INCLUDE hiredis/hiredis.h)

if (HIREDIS_LIB AND HIREDIS_INCLUDE)
    include_directories(${HIREDIS_INCLUDE})
    target_link_libraries(rate_limiter PRIVATE ${HIREDIS_LIB})
    message(STATUS "Found system hiredis: ${HIREDIS_LIB}")
else()
    message(WARNING "hiredis library not found. Install hiredis development packages.")
    message(WARNING "On Windows with MinGW, building from source has compatibility issues.")
    message(WARNING "Consider installing pre-built binaries or using WSL/Docker.")
endif()

# Link pthread if available
find_package(Threads)
if (CMAKE_THREAD_LIBS_INIT)
    target_link_libraries(rate_limiter PRIVATE ${CMAKE_THREAD_LIBS_INIT})
endif()

