#include <stdio.h>
#include <stdint.h>
#include <stddef.h>

struct BadLayout {
       uint8_t  a; /* 1 байт */
       uint64_t b; /* 8 байт */
       uint16_t c; /* 2 байта */
};

struct GoodLayout {
       uint64_t b; /* 8 байт */
       uint16_t c; /* 2 байта */
       uint8_t  a; /* 1 байт */
};

int main(void) {
    // ====================БЛОК 1====================
    printf("==========БЛОК 1==========\n\n");

    printf("размер BadLayout: %zu bytes\n", sizeof(struct BadLayout));
    printf("выравнивание BadLayout: %zu bytes\n\n", alignof(struct BadLayout));

    printf("смещение поля a (BadLayout): %zu bytes\n", offsetof(struct BadLayout, a));
    printf("смещение поля b (BadLayout): %zu bytes\n", offsetof(struct BadLayout, b));
    printf("смещение поля c (BadLayout): %zu bytes\n\n", offsetof(struct BadLayout, c));

    printf("потеря байтов: %zu bytes\n\n", sizeof(struct BadLayout) - (sizeof(uint8_t) + sizeof(uint64_t) + sizeof(uint16_t)));

    // ====================БЛОК 2====================
    printf("==========БЛОК 2==========\n\n");

    printf("размер GoodLayout: %zu bytes\n", sizeof(struct GoodLayout));
    printf("выравнивание GoodLayout: %zu bytes\n\n", alignof(struct GoodLayout));

    printf("смещение поля b (GoodLayout): %zu bytes\n", offsetof(struct GoodLayout, b));
    printf("смещение поля c (GoodLayout): %zu bytes\n", offsetof(struct GoodLayout, c));
    printf("смещение поля a (GoodLayout): %zu bytes\n\n", offsetof(struct GoodLayout, a));

    printf("потеря байтов: %zu bytes\n\n", sizeof(struct GoodLayout) - (sizeof(uint64_t) + sizeof(uint16_t) + sizeof(uint8_t)));

    // ====================БЛОК 3====================
    printf("==========БЛОК 3==========\n\n");

    printf("экономия памяти: %zu bytes\n", sizeof(struct BadLayout) - sizeof(struct GoodLayout));
    return 0;
}