
ORG     0x7c00

        jmp entry
        DB  0x90
        DB  "HARIBOTE"
        DW 512
        DB 1
        DW 1
        DB 2
        DW 224
        DW 2880
        DB 0xf0
        DW 9
        DW 18
        DW 2
        DD 0
        DD 2880
        DB 0, 0, 0x29
        DD 0xffffffff
        DB "HERIBOTEOS "
        DB "FAT12   "
        RESB 18

entry:
        mov ax, 0
        mov ss, ax
        mov sp, 0x7c00
        mov ds, ax

        mov ax, 0x0820
        mov es, ax
        mov ch, 0
        mov dh, 0
        mov cl, 2

        mov ah, 0x02
        mov al, 1
        mov bx, 0
        mov dl, 0x00
        int 0x13
        jc error



fin:
        hlt
        jmp fin

error:
        mov si, msg
putloop:
        mov al, [si]
        add si, 1
        cmp al, 0
        je fin
        mov ah, 0x0e
        mov bx, 15
        int 0x10
        jmp putloop

msg:
        db 0x0a, 0x0a
        db "load error"
        db 0x0a
        db 0
        resb 0x7dfe - $
        db 0x55, 0xaa
