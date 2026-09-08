#include <stdio.h>
#include <stdint.h>
#include <stddef.h>

int main(void) {
    uint8_t a8[2];   uint8_t *p8 = a8;
    uint16_t a16[2]; uint16_t *p16 = a16;
    uint64_t a64[2]; uint64_t *p64 = a64;
    
    printf("Step uint_8t*: %zu bytes\n", (size_t)((uintptr_t)(p8 + 1) - (uintptr_t)p8));
    printf("Step uint_16t*: %zu bytes\n", (size_t)((uintptr_t)(p16 + 1) - (uintptr_t)p16));
    printf("Step uint_64t*: %zu bytes\n", (size_t)((uintptr_t)(p64 + 1) - (uintptr_t)p64));

    uint64_t magic = 0x0102030405060708ULL;

    const uint8_t *byte_ptr = (const uint8_t *)&magic;
    for (size_t i = 0; i < sizeof(magic); ++i) {
        printf("Byte %zu: 0x%02X at adress %p\n", i, byte_ptr[i], (void *)(byte_ptr + i));
    }

    return 0;
}