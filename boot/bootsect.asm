[bits 16]

; offset set by BIOS
[org 0x7c00]

jmp 0:init


%include "boot/puts.asm"
%include "boot/disk.asm"

%macro print 1
	push si
	mov si, %1
	call puts
	call newl
	pop si
%endmacro


BOOTABLE_MAGIC_NUMBER equ 0xaa55

STAGE2_LOCATION equ 0x1000
STAGE2_SIZE 	equ 50		; sectors (x 512 bytes)

init:
	xor ax, ax
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, 0x9000			; move the stack pointer safely away from us

	mov [BOOT_DRIVE], dl	; save boot drive ID set by BIOS

	print MSG_REAL_MODE

	call ldstage2			; load stage 2 into memory
	jmp $

	call stage2				; proceed to stage 2, noreturn


ldstage2:
	mov si, MSG_LOAD_STAGE2

	call puts
	mov dx, STAGE2_LOCATION
	call prhex
	call newl

	mov bx, dx
	mov dh, STAGE2_SIZE

	mov dl, [BOOT_DRIVE]
	call ldisk
	ret

stage2:
	print MSG_STAGE2
	jmp STAGE2_LOCATION


BOOT_DRIVE		db 0
MSG_REAL_MODE 	db "started in real mode", 0
MSG_STAGE2 		db "calling stage 2", 0
MSG_LOAD_STAGE2	db "loading stage 2 at ", 0


times 510-($-$$) db 0 		; padding - align to 512 bytes
dw BOOTABLE_MAGIC_NUMBER	; set the block as bootable for the bios
