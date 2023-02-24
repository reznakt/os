; --------------------------------------------------------------------------------------
; |           Type Field        | Descriptor Type | Description                        |
; |-----------------------------|-----------------|------------------------------------|
; | Decimal                     |                 |                                    |
; |             0    E    W   A |                 |                                    |
; | 0           0    0    0   0 | Data            | Read-Only                          |
; | 1           0    0    0   1 | Data            | Read-Only, accessed                |
; | 2           0    0    1   0 | Data            | Read/Write                         |
; | 3           0    0    1   1 | Data            | Read/Write, accessed               |
; | 4           0    1    0   0 | Data            | Read-Only, expand-down             |
; | 5           0    1    0   1 | Data            | Read-Only, expand-down, accessed   |
; | 6           0    1    1   0 | Data            | Read/Write, expand-down            |
; | 7           0    1    1   1 | Data            | Read/Write, expand-down, accessed  |
; |                  C    R   A |                 |                                    |
; | 8           1    0    0   0 | Code            | Execute-Only                       |
; | 9           1    0    0   1 | Code            | Execute-Only, accessed             |
; | 10          1    0    1   0 | Code            | Execute/Read                       |
; | 11          1    0    1   1 | Code            | Execute/Read, accessed             |
; | 12          1    1    0   0 | Code            | Execute-Only, conforming           |
; | 14          1    1    0   1 | Code            | Execute-Only, conforming, accessed |
; | 13          1    1    1   0 | Code            | Execute/Read, conforming           |
; | 15          1    1    1   1 | Code            | Execute/Read, conforming, accessed |
; --------------------------------------------------------------------------------------

; the GDT always starts by a quad zero
gstart:
	dq 0x0

; code segment
gcode:
	dw 0xffff		; segment length
	dw 0x0			; segment base
	db 0x0			; segment base
	db 10011010b		; flags
	db 11001111b		; flags
	db 0x0			; segment base

; data segment
gdata:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0

gend:

; GDT descriptor
gdesc:
	dw gend - gstart - 1
	dd gstart

; offsets for convenience
CODE_SEG equ gcode - gstart
DATA_SEG equ gdata - gstart
