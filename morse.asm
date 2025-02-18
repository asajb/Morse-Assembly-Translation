global _start

STDIN equ 0
STDOUT equ 1
SYS_READ equ 0
SYS_WRITE equ 1
SYS_EXIT equ 60
MORSE_LEN equ 37
BUF_LEN equ 128

section .bss

code: resq 1 
codelen: resb 1
buf: resb 128

section .rodata

morse: db ".- ",   "-... ", "-.-. ", "-.. ",  ". ",    "..-. ",  "--. ",  ".... ", ".. ",   ".--- ", "-.- ",  ".-.. ", "-- ",   "-. ",   "--- ",  ".--. ", "--.- ", ".-. ", "... ",  "- ",    "..- ",  "...- ", ".-- ",  "-..- ", "-.-- ", "--.. ", "----- ",".---- ", "..--- ", "...-- ", "....- ", "..... ", "-.... ", "--... ", "---.. ", "----. ", " "

morselen: db 3, 5, 5, 4, 2, 5, 4, 5, 3, 5, 4, 5, 3, 3, 4, 5, 5, 4, 4, 2, 4, 5, 4, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 1

letters: db "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", " "

section .text

_start:
	
.readloop:
	mov rax, SYS_READ
	mov rdi, STDIN
	mov rsi, buf
	mov rdx, BUF_LEN
	syscall
	
	test rax, rax
	jz .exit ; if EOF
	js .exiterror ; rax is negative which means some error during sys_read
	
	xor rcx, rcx ; rcx will be the handle of loop thru buffer
.loopbuffer:
	mov sil, [buf + rcx] ; char in sil (rsi)
	inc byte [codelen] ; increase the len
	mov dl, [codelen] ; put length in dl (rdx)
	mov [code + (rdx - 1)], sil ; put the char in code
	
	; the idea now is that whenever a different char than '.', '-' or length 
	; is too long then we jump to the code process
	
	cmp byte [codelen], 8 
	je .exiterror
	cmp sil, '.'
	je .aftercodeprocess
	cmp sil, '-'
	je .aftercodeprocess

.codeprocess:
	xor r9, r9 ; index
	xor rsi, rsi ; indes in bytes
	
.loopprocess:
	cmp dl, byte [morselen + r9] ; compare lengths
	jne .endcompare
	
	mov r8b, dl ; r8b index through code processing
.loopcmp: ; compare chars (morse -> letters)
	dec r8b
	push rdx
	mov dl, [code + r8]
	cmp dl, byte [morse + rsi + r8]
	pop rdx
	jne .endcompare
	cmp r8b, 0
	jne .loopcmp
	cmp rax, rax
.endcompare:
	jne .skip1
	
	push rax ; printing the result if possible
	push rdi
	push rsi
	push rdx
	push rcx
	push r11
	
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    lea rsi, [letters + r9]
	mov rdx, 1
	syscall
	
	pop r11
	pop rcx
	pop rdx      ; restore values from the stack
	pop rsi
	pop rdi
	pop rax
	
	jmp .deletecode

.skip1:
	cmp dl, 1 ; do the same now comparing letters -> morse
	jne .endcompare1
	
	mov r8b, dl
.loopcmp1:
	dec r8b
	push rdx
	mov dl, [code + r8]
	cmp dl, byte [letters + r9 + r8]
	pop rdx
	jne .endcompare1
	cmp r8, 0
	jne .loopcmp1
	cmp rax, rax
.endcompare1:
	jne .skip2
	
	push rax
	push rdi
	push rsi
	push rdx
	push rcx
	push r11
	
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    lea rsi, [morse + rsi]
	mov dl, [morselen + r9]
	syscall 
	
	pop r11
	pop rcx
	pop rdx      ; restore values from the stack
	pop rsi
	pop rdi
	pop rax
	
	jmp .deletecode
.skip2:
	add sil, byte [morselen + r9] ; handle the loop through morse coes and letter
	inc r9
	cmp r9, MORSE_LEN
	jne .loopprocess
	
	jmp .exiterror
	
.deletecode: 	
		mov byte [codelen], 0    ; set codelength to 0
.aftercodeprocess:
	inc rcx
	cmp rcx, rax
	jne .loopbuffer
	
	jmp .readloop
.exit: 
	mov rax, SYS_EXIT   ; exit with code 0
	xor rdi, rdi
	syscall
.exiterror:
	mov rax, SYS_EXIT   ; exit with code 1 (error)
	mov rdi, 1
	syscall
