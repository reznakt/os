[bits 16]

; prints a null-terminated string pointed to by bx
puts:	
	pusha
	mov ah, 0x0e
_puts:	
	mov al, [bx]
	cmp al, 0
	je _rputs
	int 0x10
	inc bx
	jmp _puts
_rputs:
	popa
	ret

; prints a newline to the screen
newl:	
	pusha
	mov ah, 0x0e
	mov al, 0x0a
	int 0x10
	mov al, 0x0d
	int 0x10
	popa
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
	mov bx, _hexout
	call puts
	popa
	ret

_hexout: db "0x0000", 0
