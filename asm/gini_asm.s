# =====================================================================
#  Capa inferior - Iteracion 2: conversion double -> entero + 1
#  Los datos viajan POR EL STACK (pila), como pide el enunciado.
#
#  gini_asm          -> puerta de entrada (se llama desde C/Python).
#                       Recibe el parametro POR EL STACK, segun la
#                       convencion System V AMD64 (9no argumento double).
#  convertir_stack   -> hace el calculo: lee el parametro del stack
#                       y deja el resultado en el stack
# =====================================================================
        .intel_syntax noprefix
        .text

# ---------------------------------------------------------------------
#  long gini_asm(double r0, ..., double r7, double valor)
#  r0..r7 llegan en xmm0..xmm7 y se ignoran (son relleno).
#  'valor' es el 9no double: no quedan registros, asi que el codigo C
#  lo apilo antes del call (y lo desapila C despues: caller-cleanup).
#
#  Stack despues del prologo (push rbp / mov rbp, rsp):
#     [rbp+16] -> valor (lo apilo C)
#     [rbp+8]  -> direccion de retorno (la puso call)
#     [rbp]    -> rbp de quien nos llamo
# ---------------------------------------------------------------------
        .globl  gini_asm
        .type   gini_asm, @function
gini_asm:
        push    rbp                     # guarda el ancla de quien nos llamo
        mov     rbp, rsp                # nuestra ancla: aca empieza el frame

        sub     rsp, 8                  # relleno: deja rsp alineado a 16 antes del call
        push    QWORD PTR [rbp+16]      # (1) PARAMETRO: lo que apilo C -> tope del stack
        call    convertir_stack         # (2) llama; call apila la dir. de retorno
        mov     rax, QWORD PTR [rsp]    # (3) RESULTADO <- stack (convertir_stack lo dejo ahi)

        mov     rsp, rbp                # libera lo reservado
        pop     rbp                     # devuelve el ancla de quien nos llamo
        ret                             # vuelve a C; el resultado queda en rax
        .size   gini_asm, .-gini_asm

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
        .size   convertir_stack, .-convertir_stack

        .section .note.GNU-stack,"",@progbits
