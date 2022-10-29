[bits 16]


%macro print 1
	push si
	mov si, %1
	call puts
	call newl
	pop si
%endmacro


; prints a null-terminated string pointed to by bx
puts:	
	pusha
	mov ah, 0x0e
_puts:
	lodsb
	or al, al
	jnz _putsint
	popa
	ret
_putsint:
	int 0x10
	jmp _puts

; prints a newline to the screen
newl:	
	push ax
	mov ah, 0x0e
	mov al, 0x0a
	int 0x10
	mov al, 0x0d
	int 0x10
	pop ax
	ret

; prints a hex number stored in dx
prhex:	
	pusha
	xor cx, cx
_prhex: cmp cx, 4
	je _prend
	mov ax, dx
	and ax, 0x00f
	add al, '0'
	cmp al, '9'
	jle _prsnd
	add al, 7
_prsnd:	
	mov bx, _hexout + 5
	sub bx, cx
	mov [bx], al
	ror dx, 4
	inc cx
	jmp _prhex
_prend: 
	mov si, _hexout
	call puts
	popa
	ret

_hexout: 
	db "0x0000", 0
