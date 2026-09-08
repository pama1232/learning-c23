#include <stdio.h>
#include <stdint.h>

int main(void) {
    printf("uint8_t size: %zu bytes\n", sizeof(uint8_t));
    printf("uint16_t size: %zu bytes\n", sizeof(uint16_t));
    printf("uint32_t size: %zu bytes\n", sizeof(uint32_t));
    printf("uint64_t size: %zu bytes\n", sizeof(uint64_t));
    printf("void* size: %zu bytes\n", sizeof(void*));
    return 0;
}