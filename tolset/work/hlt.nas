[BITS 32]
      mov al, 'A'
      call 2*8:0xbe8
      retf
fin:
        hlt
        jmp fin
