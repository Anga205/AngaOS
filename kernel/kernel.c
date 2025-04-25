#include "screen.h"

// Entry point of the kernel
void main() {
    clear_screen(); // Clear the screen to start fresh
    print_logo();   // Print the AngaOS logo
    
    char command[100];

    while (1) {
        print_string("\nAngaOS> ");
        read_string(command);

        if (strcmp(command, "ls") == 0) {
            print_string("Listing directory contents...\n");
        } else if (strncmp(command, "cd ", 3) == 0) {
            print_string("Changing directory to ");
            print_string(command + 3);
            print_string("\n");
        } else if (strncmp(command, "mkdir ", 6) == 0) {
            print_string("Creating directory ");
            print_string(command + 6);
            print_string("\n");
        } else if (strncmp(command, "touch ", 6) == 0) {
            print_string("Creating file ");
            print_string(command + 6);
            print_string("\n");
        } else if (strncmp(command, "rm ", 3) == 0) {
            print_string("Removing ");
            print_string(command + 3);
            print_string("\n");
        } else {
            print_string("Unknown command: ");
            print_string(command);
            print_string("\n");
        }
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