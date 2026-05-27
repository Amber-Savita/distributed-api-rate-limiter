cmake_minimum_required(VERSION 3.5)

if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/hiredis.c")
    add_library(hiredis STATIC
        hiredis.c
        async.c
        net.c
        read.c
        sds.c
    )
    target_include_directories(hiredis PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
else()
    message(STATUS "No hiredis source files in ${CMAKE_CURRENT_SOURCE_DIR}; local hiredis build skipped.")
endif()
