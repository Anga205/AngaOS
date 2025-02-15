```bash
                               ____   _____ 
      /\                      / __ \ / ____|
     /  \   _ __   __ _  __ _| |  | | (___  
    / /\ \ | '_ \ / _` |/ _` | |  | |\___ \ 
   / ____ \| | | | (_| | (_| | |__| |____) |
  /_/    \_\_| |_|\__, |\__,_|\____/|_____/ 
                   __/ |                    
                  |___/                     v1.0.0

>> AngaOS is a very bare bones implementation of an operating system
```


# AngaOS
This project is still under development, but i've added some basic features like `ls`, `mkdir`, `cd`, `rmdir`, `create` & `delete`, and they all do exactly what you think they do, and should work they same as on linux

## Building AngaOS
- Before building and running AngaOS, ensure you have NASM, GCC, QEMU and GNU make installed
- once thats done, just build and execute the makefile like any other codebase
```bash
make
make run
```
This will launch QEMU and boot the OS image.