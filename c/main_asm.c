/*
 * Iteracion 2 - Programa de C puro que llama a la rutina en asm.
 * Sirve para depurar con GDB y mostrar el stack antes, durante
 * y despues de la llamada (lo pide el enunciado).
 */
#include <stdio.h>
#include "gini.h"

int main(void)
{
    double gini = 41.99;            /* dato de prueba */
    long resultado;

    resultado = gini_asm(gini);     /* <-- la llamada que vamos a observar */

    printf("GINI %.2f -> %ld\n", gini, resultado);
    return 0;
}