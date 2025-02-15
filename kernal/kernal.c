#include "screen.h"

// Entry point of the kernel
void main() {
    clear_screen(); // Clear the screen to start fresh
    print_logo();   // Print the AngaOS logo
    
    while(1) {
        // Infinite loop to keep the kernel running
        // TODO: Add command processing logic here
    }
}

// Function to print the AngaOS logo
void print_logo() {
    // Print the ASCII art logo of AngaOS
    print_string(
        "\n"
        "                               ____   _____ \n"
        "      /\\                      / __ \\ / ____|\n"
        "     /  \\   _ __   __ _  __ _| |  | | (___  \n"
        "    / /\\ \\ | '_ \\ / _` |/ _` | |  | |\\___ \\ \n"
        "   / ____ \\| | | | (_| | (_| | |__| |____) |\n"
        "  /_/    \\_\\_| |_|\\__, |\\__,_|\\____/|_____/ \n"
        "                   __/ |                    \n"
        "                  |___/                     v1.0.0\n"
    );
}