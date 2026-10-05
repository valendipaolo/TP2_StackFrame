#ifndef GINI_H
#define GINI_H

/* Convierte el indice GINI (double) a entero y le suma 1. */
long gini_to_int_plus1(double valor);

/* Iteracion 2: misma operacion en asm (asm/gini_asm.s), pasando el dato por el stack. */
long gini_asm(double valor);

#endif