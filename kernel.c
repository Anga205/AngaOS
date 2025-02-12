void _start() {
    char* video_memory = (char*)0xB8000;
    *video_memory = 'A';  // Print 'A' to screen
}