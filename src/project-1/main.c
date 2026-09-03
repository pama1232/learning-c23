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
