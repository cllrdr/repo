.section .data
msg:
    .ascii "Hello, World!\n"
len = . - msg

.section .text
.global _start
_start:
    movl $4, %eax       # системный вызов write
    movl $1, %ebx       # стандартный вывод
    movl $msg, %ecx     # адрес сообщения
    movl $len, %edx     # длина сообщения
    int $0x80           # вызов ядра

    movl $1, %eax       # системный вызов exit
    movl $0, %ebx       # статус выхода
    int $0x80           # вызов ядра