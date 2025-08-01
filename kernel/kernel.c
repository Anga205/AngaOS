// Minimal C kernel - most functionality is in assembly
// Assembly function declarations
extern void _start(void);

// This is now just a fallback - main functionality is in kernel_asm.asm
void main() {
    // Assembly kernel handles everything
    _start();
}