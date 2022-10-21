[bits 16]
pmjmp:
	cli
	lgdt [gdesc]
	mov eax, cr0
	or eax, 0x1
	mov cr0, eax
	jmp CODE_SEG:pminit


[bits 32]
pminit:
	mov ax, DATA_SEG
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov ebp, 0x9000
	mov esp, ebp

	call begin32
