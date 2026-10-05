# =====================================================================
#  Capa inferior - Iteracion 2: conversion double -> entero + 1
#  Los datos viajan POR EL STACK (pila), como pide el enunciado.
#
#  gini_asm          -> puerta de entrada (se llama desde C/Python)
#  convertir_stack   -> hace el calculo: lee el parametro del stack
#                       y deja el resultado en el stack
# =====================================================================
        .intel_syntax noprefix
        .text

# ---------------------------------------------------------------------
#  long gini_asm(double valor)
#  Llega con la convencion normal de Linux 64 bits: valor en xmm0.
#  Lo pasa a convertir_stack a traves del stack.
# ---------------------------------------------------------------------
        .globl  gini_asm
        .type   gini_asm, @function
gini_asm:
        push    rbp                     # guarda el ancla de quien nos llamo
        mov     rbp, rsp                # nuestra ancla: aca empieza el frame
        sub     rsp, 16                 # reserva 16 bytes en el stack

        movsd   QWORD PTR [rsp], xmm0   # (1) PARAMETRO -> stack
        call    convertir_stack         # (2) llama; call apila la dir. de retorno
        mov     rax, QWORD PTR [rsp]    # (3) RESULTADO <- stack

        mov     rsp, rbp                # libera lo reservado
        pop     rbp                     # devuelve el ancla de quien nos llamo
        ret                             # vuelve; el resultado queda en rax

# ---------------------------------------------------------------------
#  convertir_stack
#  Stack al entrar (despues de push rbp / mov rbp,rsp):
#     [rbp+16] -> parametro (double)  y luego resultado (entero)
#     [rbp+8]  -> direccion de retorno (la puso call)
#     [rbp]    -> rbp viejo
# ---------------------------------------------------------------------
        .type   convertir_stack, @function
convertir_stack:
        push    rbp
        mov     rbp, rsp

        movsd   xmm0, QWORD PTR [rbp+16]    # lee el parametro desde el stack
        cvttsd2si rax, xmm0                 # convierte truncando: 41.99 -> 41
        add     rax, 1                      # suma 1: 41 -> 42
        mov     QWORD PTR [rbp+16], rax     # escribe el resultado en el stack

        pop     rbp
        ret

        .section .note.GNU-stack,"",@progbits
        