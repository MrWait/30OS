;
;
[FORMAT "WCOFF"]
[INSTRSET "i486p"]
[BITS 32]
[FILE "naskfunc.nas"]
      GLOBAL _io_hlt, _io_cli, _io_sti, _io_stihlt
      GLOBAL _io_in8, _io_in16, _io_in32
      GLOBAL _io_out8, _io_out16, _io_out32
      GLOBAL _io_load_eflags, _io_store_eflags
      GLOBAL _load_gdtr, _load_idtr
      GLOBAL _load_cr0, _store_cr0
      GLOBAL _load_tr
      GLOBAL _asm_inthandler20, _asm_inthandler21
      GLOBAL _asm_inthandler27, _asm_inthandler2c
      GLOBAL _asm_inthandler0c, _asm_inthandler0d
      GLOBAL _asm_end_app, _memtest_sub
      GLOBAL _farjmp, _farcall
      GLOBAL _asm_hrb_api, _start_app
      EXTERN _inthandler20, _inthandler21
      EXTERN _inthandler27, _inthandler2c
      EXTERN _inthandler0c, _inthandler0d
      EXTERN _hrb_api
[SECTION .text]

_io_hlt:
        hlt
        ret

_io_cli:
        cli
        ret

_io_sti:
        sti
        ret

_io_stihlt:
        sti
        hlt
        ret

_io_in8:
        mov edx, [esp + 4]
        mov eax, 0
        in al, dx
        ret

_io_in16:
        mov edx,  [esp + 4]
        mov eax, 0
        in ax, dx
        ret

_io_in32:
        mov edx, [esp + 4]
        in eax, dx
        ret

_io_out8:
        mov edx, [esp + 4]
        mov al, [esp + 8]
        out dx, al
        ret

_io_out16:
        mov edx, [esp + 4]
        mov eax, [esp + 8]
        out dx, ax
        ret

_io_out32:
        mov edx, [esp + 4]
        mov eax, [esp + 8]
        out dx, eax
        ret

_io_load_eflags:
        pushfd
        pop eax
        ret

_io_store_eflags:
        mov eax, [esp + 4]
        push eax
        popfd
        ret


_load_gdtr:
        mov ax, [esp + 4]
        mov [esp + 6], ax
        lgdt [esp + 6]
        ret


_load_idtr:
        mov ax, [esp + 4]
        mov [esp + 6], ax
        lidt [esp + 6]
        ret

_load_cr0:
        mov eax, cr0
        ret

_store_cr0:
        mov eax, [esp + 4]
        mov cr0, eax
        ret

_load_tr:
        ltr [esp + 4]
        ret

_asm_inthandler20:
        push es
        push ds
        pushad
        mov eax, esp
        push eax
        mov ax, ss
        mov ds, ax
        mov es, ax
        call _inthandler20
        pop eax
        popad
        pop ds
        pop es
        iretd

_asm_inthandler21:
        push es
        push ds
        pushad
        mov eax, esp
        push eax
        mov ax, ss
        mov ds, ax
        mov es, ax
        call _inthandler21
        pop eax
        popad
        pop ds
        pop es
        iretd


_asm_inthandler27:
        push es
        push ds
        pushad
        mov eax, esp
        push eax
        mov ax, ss
        mov ds, ax
        mov es, ax
        call _inthandler27
        pop eax
        popad
        pop ds
        pop es
        iretd


_asm_inthandler2c:
        push es
        push ds
        pushad
        mov eax, esp
        push eax
        mov ax, ss
        mov ds, ax
        mov es, ax
        call _inthandler2c
        pop eax
        popad
        pop ds
        pop es
        iretd

_asm_inthandler0c:
        sti
        push es
        push ds
        pushad
        mov eax, esp
        push eax
        mov ax, ss
        mov ds, ax
        mov es, ax
        call _inthandler0c
        cmp eax, 0
        jne _asm_end_app
        pop eax
        popad
        pop ds
        pop es
        add esp, 4
        iretd

_asm_inthandler0d:
        sti
        push es
        push ds
        pushad
        mov eax, esp
        push eax
        mov ax, ss
        mov ds, ax
        mov es, ax
        call _inthandler0d
        cmp eax, 0
        jne _asm_end_app
        pop eax
        popad
        pop ds
        pop es
        add esp, 4
        iretd

_memtest_sub:
        push edi
        push esi
        push ebx
        mov esi, 0xaa55aa55
        mov edi, 0x55aa55aa
        mov eax, [esp + 12 + 4]

mts_loop:
        mov ebx, eax
        add ebx, 0xffc
        mov edx, [ebx]
        mov [ebx], esi
        xor dword [ebx], 0xffffffff
        cmp edi, [ebx]
        jne mts_fin
        xor dword [ebx], 0xffffffff
        cmp esi, [ebx]
        jne mts_fin
        mov [ebx], edx
        add eax, 0x1000
        cmp eax, [esp + 12 + 8]
        jbe mts_loop
        pop ebx
        pop esi
        pop edi
        ret

mts_fin:
        mov [ebx], edx
        pop ebx
        pop esi
        pop edi
        ret

_farjmp:
        jmp far [esp + 4]
        ret

_farcall:
        call far [esp + 4]
        ret

_asm_hrb_api:
        sti
        push ds
        push es
        pushad
        pushad
        mov ax, ss
        mov ds, ax
        mov es, ax
        call _hrb_api
        cmp eax, 0
        jne _asm_end_app
        add esp, 32
        popad
        pop es
        pop ds
        iretd

_asm_end_app:
        mov esp, [eax]
        mov dword [eax + 4], 0
        popad
        ret

_start_app:
        pushad
        mov eax, [esp + 36]
        mov ecx, [esp + 40]
        mov edx, [esp + 44]
        mov ebx, [esp + 48]
        mov ebp, [esp + 52]
        mov [ebp], esp
        mov [ebp + 4], ss

        mov es, bx
        mov ds, bx
        mov fs, bx
        mov gs, bx
        or ecx, 3
        or ebx, 3
        push ebx
        push edx
        push ecx
        push eax
        retf
