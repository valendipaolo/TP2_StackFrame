/*
 * Capa intermedia - Iteracion 2.
 * Python llama a esta funcion (via ctypes). Ya no hace la cuenta en C:
 * se la delega a la rutina en ensamblador (asm/gini_asm.s), que recibe
 * el parametro y devuelve el resultado a traves del stack.
 *
 * Version de la iteracion 1 (C puro), como referencia:
 *     long entero = (long)valor;   // truncamiento, equivale a cvttsd2si
 *     return entero + 1;
 */
#include "gini.h"

long gini_to_int_plus1(double valor)
{
    return gini_asm(valor);
}