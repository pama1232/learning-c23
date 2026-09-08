#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>

int main(void) {
    uint64_t val = 0xCAFEBABE11223344ULL;
    uint64_t *ptr = &val;
    printf("val: 0x%016" PRIX64 "\n", val);
    printf("*ptr: %p\n", (void *)ptr);
    printf("Address &val: %p\n", (void *)&val);
    printf("Address &ptr: %p\n", (void *)&ptr);
    *ptr = 0xFEEDC0FFEE00ULL;
    printf("Mutated val: 0x%016" PRIX64 "\n", val);
    return 0;
}