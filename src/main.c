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
