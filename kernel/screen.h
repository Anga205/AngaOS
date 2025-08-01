#ifndef SCREEN_H
#define SCREEN_H

void clear_screen();
void print_string(const char *str);
void print_logo(void);
void read_string(char *buffer);
int strcmp(const char *str1, const char *str2);
int strncmp(const char *str1, const char *str2, int n);

#endif