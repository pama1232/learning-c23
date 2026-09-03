#!/usr/bin/env bash
set -euo pipefail

# 1. Инициализация Git-репозитория
if [ ! -d ".git" ]; then
  git init -b main
fi

# 2. Формирование .gitignore
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

# 3. Формирование оптимизированного CMakeLists.txt (Clang + LLD + ThinLTO + Zen4)
cat <<'EOF' >CMakeLists.txt
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
EOF

# 4. Формирование C23-исходника с корректной семантикой типов
mkdir -p src
cat <<'EOF' >src/main.c
#include <stdio.h>

[[nodiscard]] static inline unsigned long long get_zen4_mask(void) {
    return 0xFEEDC0FFEE00ULL;
}

int main(void) {
    constexpr unsigned long long static_mask = 0xFEEDC0FFEE00ULL;
    auto dynamic_mask = get_zen4_mask();
    void *ptr = nullptr;

    if (ptr == nullptr && dynamic_mask == static_mask) {
        printf("[OK] Zen4 ThinLTO C23 Executable Online. Mask: 0x%llX\n", dynamic_mask);
    }

    return 0;
}
EOF

# 5. Сборка и запуск бинарника
cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=clang
cmake --build build
./build/sys_core
