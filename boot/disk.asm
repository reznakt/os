[bits 16]

INT13_READ 		equ 0x02

LOAD_HEAD 		equ 0x0
LOAD_CYLINDER 	equ 0x0
LOAD_SECTOR 	equ 0x02


; load <dh> sectors from sidk <dl> into memory at address <bx>
; prints info about loaded sectors and error code in case of error
ldisk:	
	pusha
	push dx

	mov ah, INT13_READ		; read
	mov al, dh				; number of sectors to read
	mov cl, LOAD_SECTOR		; starting sector 0x02
	mov ch, LOAD_CYLINDER 	; cylinder 0x00
	mov dh, LOAD_HEAD		; head 0x00

	int 0x13
	jc _lderr		; carry -> read error

	; print number of loaded/expected sectors
	mov si, scmsg
	call puts

	mov dx, ax
	and dx, 0x00ff
	call prhex

	mov si, scmsg2
	call puts

	pop dx			; wanted # of sectors
	ror dx, 8
	and dx, 0x00ff
	call prhex

	call newl

	; check if all sectors were loaded
	cmp al, dl		; compare to actual # read
	jne _lderr
	popa
	ret

_ldend:	
	jmp $			; we probably don't want to continue 
					; execution at this point

_lderr:	
mov si, ldmsg
	call puts
	xor dx, dx
	mov dl, ah		; error code
	call prhex
	call newl
	jmp _ldend


ldmsg:	db "lddisk read error ", 0
scmsg:	db "sectors loaded: ", 0
scmsg2:	db "/", 0
