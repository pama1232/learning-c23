#!/usr/bin/env bash
set -euo pipefail

PROJECT="${1:-project-1}"
BUILD_TYPE="${2:-Debug}"

if [ ! -d ".git" ]; then
  git init -b main
fi

cat <<'EOF' >.gitignore
build/
bin/
lib/
compile_commands.json
.ninja_log
.ninja_deps
*.o
*.obj
*.so
*.a
*.elf
.clangd/
.cache/
.vscode/*
!.vscode/settings.json
!.vscode/tasks.json
!.vscode/launch.json
.idea/
*.swp
*~
EOF

cat <<'EOF' >CMakeLists.txt
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
EOF

mkdir -p src/project-1
cat <<'EOF' >src/project-1/main.c
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>

[[nodiscard]] static inline uint64_t get_zen4_mask(void) {
    return 0xFEEDC0FFEE00ULL;
}

int main(void) {
    constexpr uint64_t static_mask = 0xFEEDC0FFEE00ULL;
    auto dynamic_mask = get_zen4_mask();
    void *ptr = nullptr;

    if (ptr == nullptr && dynamic_mask == static_mask) {
        printf("[OK] Project-1 Zen4 C23 Executable Online. Mask: 0x%016" PRIX64 "\n", dynamic_mask);
    }

    return 0;
}
EOF

cmake -B build -DCMAKE_BUILD_TYPE="${BUILD_TYPE}" -DCMAKE_C_COMPILER=clang
cmake --build build --target "${PROJECT}"
"./build/${PROJECT}"
