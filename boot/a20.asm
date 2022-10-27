[bits 32]

check_a20:
    pushad

    mov edi, 0x112345   ; odd MB
    mov esi, 0x012345   ; even MB

    mov [esi], esi
    mov [edi], edi

    cmpsd
    popad

    jne enable_a20      ; enable A20 if not already
    ret

enable_a20:
    in al, 0x92
    test al, 2