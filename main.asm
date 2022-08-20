SYS_EXIT equ 0x1
SYS_READ equ 0x3
SYS_WRITE equ 0x4
SYS_TIME equ 0xD

STDIN equ 0x0
STDOUT equ 0x1
STDERR equ 0x2

section .data
	inputMsg db "[rock paper scissors] > ", 0x0
	inputLen equ $ - inputMsg
	lostMsg db "You lost!", 0xA, 0x0
	lostLen equ $ - lostMsg
	drawMsg db "It's a draw!", 0xA, 0x0
	drawLen equ $ - drawMsg
	wonMsg db "You won!", 0xA, 0x0
	wonLen equ $ - wonMsg

section .bss
	input resq 1
	exitCode resb 1
	time resq 1

section .text
	global _start

_start:
	mov r8, 0
	mov [exitCode], r8

	mov rax, SYS_WRITE
	mov rbx, STDOUT
	mov rcx, inputMsg
	mov rdx, inputLen
	int 0x80

	mov rax, SYS_READ
	mov rbx, STDIN
	mov rcx, input
	mov rdx, 8
	int 0x80

	rdtsc
	xor edx, edx
	mov ecx, 3 - 1 + 1 ; max - min + 1
	div ecx
	mov eax, edx
	add eax, 0x1

	cmp eax, 1
	je random1
	cmp eax, 2
	je random2
	cmp eax, 3
	je random3

	random1:
	mov rax, SYS_WRITE
	mov rbx, STDOUT
	mov rcx, wonMsg
	mov rdx, wonLen
	int 0x80
	jmp exit

	random2:
	mov rax, SYS_WRITE
	mov rbx, STDOUT
	mov rcx, lostMsg
	mov rdx, lostLen
	int 0x80
	jmp exit

	random3:
	mov rax, SYS_WRITE
	mov rbx, STDOUT
	mov rcx, drawMsg
	mov rdx, drawLen
	int 0x80
	jmp exit

	exit:
	mov rax, SYS_EXIT
	mov rbx, [exitCode]
	int 0x80

