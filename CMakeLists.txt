cmake_minimum_required(VERSION 3.5)
project(distributed_rate_limiter)

set(CMAKE_CXX_STANDARD 17)

include_directories(
    ${CMAKE_SOURCE_DIR}/include
    ${CMAKE_SOURCE_DIR}/external
    ${CMAKE_SOURCE_DIR}/external/hiredis
    ${CMAKE_SOURCE_DIR}/external/crow
)

add_executable(rate_limiter src/main.cpp src/rate_limiter.cpp)

# Prefer a local vendored hiredis build when the source is available.
if (EXISTS "${CMAKE_SOURCE_DIR}/external/hiredis/hiredis.c")
    add_subdirectory(external/hiredis)
endif()

if (TARGET hiredis)
    target_link_libraries(rate_limiter PRIVATE hiredis)
else()
    find_library(HIREDIS_LIB hiredis)
    if (HIREDIS_LIB)
        target_link_libraries(rate_limiter PRIVATE ${HIREDIS_LIB})
    else()
        message(WARNING "hiredis library not found. Install hiredis or place its sources in external/hiredis")
    endif()
endif()

# On Unix/Windows, link pthread if available
find_package(Threads)
if (CMAKE_THREAD_LIBS_INIT)
    target_link_libraries(rate_limiter PRIVATE ${CMAKE_THREAD_LIBS_INIT})
endif()
