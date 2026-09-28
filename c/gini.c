/*
 * Capa intermedia - Iteracion 1 (C puro, sin ensamblador).
 * En la iteracion 2 el cuerpo de esta funcion se reemplaza por
 * una llamada a la rutina en asm.
 */
#include "gini.h"

long gini_to_int_plus1(double valor)
{
    /* Conversion por TRUNCAMIENTO (equivale a cvttsd2si en asm). */
    long entero = (long)valor;
    return entero + 1;
}
