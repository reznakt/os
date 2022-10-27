[32 bits]

check_cpuid:
    pushad

    ; FLAGS -> eax
    pushfd
    pop eax

    ; store for later comparison
    mov ecx, eax 

    ; flip the ID bit
    xor eax, 1 << 21

    ; eax -> FLAGS
    push eax
    popfd

    ; FLAGS -> eax
    pushfd
    pop eax

    popad

    ; no change -> no cpuid
    cmp eax, ecx
    je no_cpuid

    ret

check_ext_cpuid:
    pushad

    mov eax, 0x80000000
    cpuid
    popad
    cmp eax, 0x80000001
    jb no_ext_cpuid

    ret

check_long_mode:
    pushad

    mov eax, 0x80000001
    cpuid

    popad

    test edx, 1 << 29
    jz no_long_mode
    
    ret

no_cpuid:
    mov ebx, NO_CPUID
    call puts32
    jmp $

no_ext_cpuid:
    mov ebx, NO_EXT_CPUID
    call puts32
    jmp $

no_long_mode:
    mov ebx, NO_LONG_MODE
    call puts32
    jmp $


NO_CPUID:       db "cpuid not available", 0
NO_EXT_CPUID    db "extended cpuid not avaiable", 0
NO_LONG_MODE    db "long mode not available", 0
