```bash
                               ____   _____ 
      /\                      / __ \ / ____|
     /  \   _ __   __ _  __ _| |  | | (___  
    / /\ \ | '_ \ / _` |/ _` | |  | |\___ \ 
   / ____ \| | | | (_| | (_| | |__| |____) |
  /_/    \_\_| |_|\__, |\__,_|\____/|_____/ 
                   __/ |                    
                  |___/                     v1.0.0

>> AngaOS is a very bare bones implementation of a bootloader, kernel & operating system
```


# AngaOS
This project is still under development, but i've added some basic features like `ls`, `mkdir`, `cd`, `rm` & `touch`, and they all do exactly what you think they do, and should work they same as on linux

Most of the code is self documenting and i've tried to make the comments as easy to understand as possible, but if you are a beginner and need help, feel free to contact me :D

## Building AngaOS
- Before building and running AngaOS, ensure you have NASM, GCC, QEMU and GNU make installed
- once thats done, just build and execute the makefile like any other codebase
```bash
make
make run
```
This will launch QEMU and boot the OS image.

## Preview

![AngaOS Preview](https://i.anga.codes/i/97hl2n1md1yw/preview.png)
