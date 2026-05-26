cmake_minimum_required(VERSION 3.5)
project(distributed_rate_limiter)

set(CMAKE_CXX_STANDARD 17)

include_directories(${CMAKE_SOURCE_DIR}/include ${CMAKE_SOURCE_DIR}/external)

add_executable(rate_limiter src/main.cpp src/rate_limiter.cpp)

find_library(HIREDIS_LIB hiredis)
if (HIREDIS_LIB)
    target_link_libraries(rate_limiter ${HIREDIS_LIB})
endif()

# On Unix, link pthread if available
find_package(Threads)
if (CMAKE_THREAD_LIBS_INIT)
    target_link_libraries(rate_limiter ${CMAKE_THREAD_LIBS_INIT})
endif()
