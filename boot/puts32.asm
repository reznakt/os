[bits 32]

VIDEO_MEMORY equ 0xb8000
TEXT_COLOR equ 0x0f	; white on black

; prints a string pointed to by ebx
puts32:	
	pushad
	mov edx, VIDEO_MEMORY
_puts32:
	mov al, [ebx]
	cmp al, 0
	je _puts3e
	mov ah, TEXT_COLOR
	mov [edx], ax
	add ebx, 1
	add edx, 2
	jmp _puts32
_puts3e:
	popad
	ret
