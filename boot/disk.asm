[bits 16]

ldisk:	
	pusha
	push dx

	mov ah, 0x02	; read
	mov al, dh		; number of sectors to read
	mov cl, 0x02	; starting sector 0x02
	mov ch, 0x00 	; cylinder 0x00
	mov dh, 0x00	; head 0x00

	int 0x13
	jc _lderr		; carry -> read error

	
	mov bx, scmsg
	call puts

	mov dx, ax
	and dx, 0x00ff
	call prhex

	mov bx, scmsg2
	call puts

	pop dx			; wanted # of sectors
	ror dx, 8
	and dx, 0x00ff
	call prhex

	call newl

	cmp al, dl		; compare to actual # read
	jne _lderr
	popa
	ret

_ldend:	
	jmp $			; we probably don't want to continue 
					; execution at this point

_lderr:	
mov bx, ldmsg
	call puts
	xor dx, dx
	mov dl, ah		; error code
	call prhex
	call newl
	jmp _ldend


ldmsg:	db "lddisk read error ", 0
scmsg:	db "sectors loaded: ", 0
scmsg2:	db "/", 0
