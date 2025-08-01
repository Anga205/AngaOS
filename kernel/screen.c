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

// Function to read a string from keyboard input
void read_string(char *buffer) {
    // For now, we'll simulate some basic commands for testing
    // In a real OS, this would read from the keyboard controller
    static int command_count = 0;
    static char* test_commands[] = {"ls", "help", "mkdir test", "cd test", "touch file.txt", "rm file.txt", ""};
    
    // Cycle through test commands and then stop with empty commands
    if (command_count < 6) {
        // Copy the test command to buffer
        char* test_cmd = test_commands[command_count];
        int i = 0;
        while (test_cmd[i] != '\0' && i < 99) {
            buffer[i] = test_cmd[i];
            i++;
        }
        buffer[i] = '\0';
        
        // Print the command as if user typed it
        print_string(test_cmd);
        command_count++;
    } else {
        // After test commands, just provide empty input to keep the shell running
        buffer[0] = '\0';
    }
}

// Function to compare two strings
int strcmp(const char *str1, const char *str2) {
    while (*str1 && *str2 && *str1 == *str2) {
        str1++;
        str2++;
    }
    return *str1 - *str2;
}

// Function to compare two strings up to n characters
int strncmp(const char *str1, const char *str2, int n) {
    while (n > 0 && *str1 && *str2 && *str1 == *str2) {
        str1++;
        str2++;
        n--;
    }
    if (n == 0) {
        return 0;
    }
    return *str1 - *str2;
}