cmake_minimum_required(VERSION 3.25)

project(sys_core
    VERSION 0.1.0
    LANGUAGES C
)

set(CMAKE_C_STANDARD 23)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_executable(sys_core src/main.c)

# Архитектурные флаги компилятора Clang под AMD Zen4
target_compile_options(sys_core PRIVATE
    -march=native
    -O3
    -pipe
    -fno-plt
    -fexceptions
    -Wformat
    -Werror=format-security
    -fstack-clash-protection
    -fcf-protection
    -fno-omit-frame-pointer
    -mno-omit-leaf-frame-pointer
    -flto=thin
    -Wall
    -Wextra
    -Wpedantic
    -Wconversion
    -Wshadow
    -Wundef
)

# Защита памяти (активна строго в Release)
target_compile_definitions(sys_core PRIVATE
    $<$<CONFIG:Release>:_FORTIFY_SOURCE=3>
)

# Параметры компоновщика LLVM LLD и межпроцедурная оптимизация
target_link_options(sys_core PRIVATE
    -fuse-ld=lld
    -flto=thin
    -Wl,-O1
    -Wl,--sort-common
    -Wl,--as-needed
    -Wl,-z,relro
    -Wl,-z,now
    -Wl,-z,pack-relative-relocs
)
