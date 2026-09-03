cmake_minimum_required(VERSION 3.25)

project(systems_learning_c23
    VERSION 0.1.0
    LANGUAGES C
)

set(CMAKE_C_STANDARD 23)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Централизованный интерфейс настроек тулчейна Clang/LLD под Zen4
add_library(sys_compiler_flags INTERFACE)

target_compile_options(sys_compiler_flags INTERFACE
    -Wall
    -Wextra
    -Wpedantic
    -Wconversion
    -Wshadow
    -Wundef
    -Wformat=2
    -Werror=format-security
    $<$<CONFIG:Debug>:-O0>
    $<$<CONFIG:Debug>:-g3>
    $<$<CONFIG:Debug>:-fno-omit-frame-pointer>
    $<$<CONFIG:Debug>:-mno-omit-leaf-frame-pointer>
    $<$<CONFIG:Debug>:-fsanitize=address,undefined>
    $<$<CONFIG:Release>:-march=native>
    $<$<CONFIG:Release>:-O3>
    $<$<CONFIG:Release>:-pipe>
    $<$<CONFIG:Release>:-fno-plt>
    $<$<CONFIG:Release>:-fstack-clash-protection>
    $<$<CONFIG:Release>:-fcf-protection>
    $<$<CONFIG:Release>:-flto=thin>
)

target_compile_definitions(sys_compiler_flags INTERFACE
    $<$<CONFIG:Release>:_FORTIFY_SOURCE=3>
)

target_link_options(sys_compiler_flags INTERFACE
    -fuse-ld=lld
    $<$<CONFIG:Debug>:-fsanitize=address,undefined>
    $<$<CONFIG:Release>:-flto=thin>
    $<$<CONFIG:Release>:-Wl,-O1>
    $<$<CONFIG:Release>:-Wl,--as-needed>
    $<$<CONFIG:Release>:-Wl,-z,relro>
    $<$<CONFIG:Release>:-Wl,-z,now>
    $<$<CONFIG:Release>:-Wl,-z,pack-relative-relocs>
)

# Регистрация целей (Монолитная схема)
add_executable(project-1 src/project-1/main.c)
target_link_libraries(project-1 PRIVATE sys_compiler_flags)
