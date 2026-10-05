# =====================================================================
#  Sesion de GDB: estado del stack ANTES, DURANTE y DESPUES de gini_asm
#  Uso:  gdb -q -batch -x docs/gdb_stack.gdb build/main_asm
# =====================================================================
set pagination off
set confirm off
set debuginfod enabled off
set disassembly-flavor intel

break main_asm.c:14
break gini_asm
break convertir_stack
run

echo \n================ ANTES (main, antes de llamar a gini_asm) ================\n
info registers rsp rbp
echo --- stack desde rsp ---\n
x/4gx $rsp
echo --- variable gini leida como double ---\n
x/1fg $rsp

continue
echo \n================ DURANTE 1 (entrada a gini_asm) ================\n
echo call apilo la direccion de retorno a main:\n
info registers rsp
x/2gx $rsp

continue
stepi 2
echo \n================ DURANTE 2 (convertir_stack, frame armado) ================\n
info registers rsp rbp
echo --- [rbp]=rbp viejo  [rbp+8]=dir. retorno  [rbp+16]=PARAMETRO ---\n
x/4gx $rbp
echo --- parametro leido desde el stack ---\n
x/1fg $rbp+16

stepi 4
echo \n================ DURANTE 3 (convertir_stack, resultado escrito) ================\n
x/4gx $rbp
echo --- resultado leido desde el stack ---\n
x/1dg $rbp+16

finish
stepi
echo \n================ DURANTE 4 (gini_asm leyo el resultado del stack) ================\n
p $rax

finish
next
echo \n================ DESPUES (main, linea 16) ================\n
info registers rsp rbp rax
x/4gx $rsp
p resultado

continue