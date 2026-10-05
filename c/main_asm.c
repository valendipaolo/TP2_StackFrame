/*
 * Iteracion 2 - Programa de C puro que llama a la rutina en asm.
 * Sirve para depurar con GDB y mostrar el stack antes, durante
 * y despues de la llamada (lo pide el enunciado).
 *
 * Los primeros 8 doubles viajan en xmm0..xmm7 (System V AMD64).
 * Los ocupamos con ceros para que el 9no (gini) lo apile el
 * compilador en el stack antes del call.
 */
#include <stdio.h>
#include "gini.h"

int main(void)
{
    double gini = 41.99;            /* dato de prueba */
    long resultado;

    resultado = gini_asm(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, gini);   /* <-- llamada observada */

    printf("GINI %.2f -> %ld\n", gini, resultado);
    return 0;
}
