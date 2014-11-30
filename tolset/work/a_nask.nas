[FORMAT "WCOFF"]
[INSTRSET "i486p"]
[BITS 32]
[FILE "a_nask.nas"]

      GLOBAL _api_putchar
      GLOBAL _api_putstr0
      GLOBAL _api_end
      GLOBAL _api_openwin
[SECTION .text]

_api_putchar:
        mov edx, 1
        mov al, [esp + 4]
        int 0x40
        ret

_api_putstr0:
        push ebx
        mov edx, 2
        mov ebx, [esp + 8]
        int 0x40
        pop ebx
        ret

_api_end:
        mov edx, 4
        int 0x40

_api_openwin:
        push edi
        push esi
        push ebx
        mov edx, 5
        mov ebx, [esp + 16]
        mov esi, [esp + 20]
        mov edi, [esp + 24]
        mov eax, [esp + 28]
        mov ecx, [esp + 32]
        int 0x40
        pop ebx
        pop esi
        pop edi
        ret
