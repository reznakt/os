[bits 16]

; offset set by BIOS
[org 0x7c00]

jmp 0:init


%include "boot/puts32.asm"
%include "boot/puts.asm"
%include "boot/pmjmp.asm"
%include "boot/gdt.asm"
%include "boot/disk.asm"


KERNEL_OFFSET equ 0x1000
KERNEL_SIZE_SECT equ 50

init:
	xor ax, ax
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, 0x9000

	mov [BOOT_DRIVE], dl	; set by BIOS

	mov bx, MSG_REAL_MODE
	call puts
	call newl

	call ldkernel			; load the kernel into memory
	call pmjmp				; switch to 32-bit protected mode


[bits 16]
ldkernel:
	mov bx, MSG_LOAD_KERNEL
	call puts
	mov dx, KERNEL_OFFSET
	call prhex
	call newl

	mov bx, dx
	mov dh, KERNEL_SIZE_SECT
	mov dl, [BOOT_DRIVE]
	call ldisk
	ret

; entry point for 32-bit instructions
[bits 32]
begin32:
	mov ebx, MSG_PROT_MODE
	call puts32

	jmp KERNEL_OFFSET	; transfer control to the kernel
	

BOOT_DRIVE			db 0
MSG_REAL_MODE 		db "starting in real mode", 0
MSG_PROT_MODE 		db "we are in protected mode; transfering control to kernel", 0
MSG_LOAD_KERNEL 	db "loading kernel to address ", 0


times 510-($-$$) db 0 	; padding - align to 512 bytes
dw 0xaa55				; set the block as bootable for the bios
