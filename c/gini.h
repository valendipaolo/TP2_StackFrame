#ifndef GINI_H
#define GINI_H

/* Convierte el indice GINI (double) a entero y le suma 1. */
long gini_to_int_plus1(double valor);

/*
 * Iteracion 2: misma operacion en asm (asm/gini_asm.s).
 * System V AMD64 pasa los primeros 8 doubles en xmm0..xmm7. r0..r7 son
 * relleno (van en 0): ocupan esos registros para que 'valor', el 9no,
 * lo apile el compilador de C en el stack. En el asm queda en [rbp+16].
 * Mismo truco que suma_por_pila en el ejemplo de la catedra.
 */
long gini_asm(double r0, double r1, double r2, double r3,
              double r4, double r5, double r6, double r7,
              double valor);

#endif
