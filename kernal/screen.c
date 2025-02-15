// VGA text mode memory address
#define VGA_ADDR 0xB8000
unsigned short *terminal = (unsigned short *)VGA_ADDR; // Pointer to the VGA text buffer

// Function to clear the screen
void clear_screen() {
    // Loop through all 80x25 screen cells (80 columns x 25 rows)
    for(int i = 0; i < 80*25; i++) {
        // Set each cell to a blank space (' ') with the default attribute (0x07)
        terminal[i] = (0x07 << 8) | ' ';
    }
}

// Function to print a string to the screen
void print_string(const char *str) {
    static int pos = 0; // Keeps track of the current position in the VGA buffer

    // Loop through each character in the string
    while(*str) {
        if(*str == '\n') {
            // If the character is a newline, move to the next line
            pos += 80 - (pos % 80); // Move to the start of the next row
        } else {
            // Otherwise, write the character to the current position
            terminal[pos++] = (0x07 << 8) | *str; // Default attribute (0x07) + character
        }
        str++; // Move to the next character in the string
    }
}