# =====================================================================
#  Sesion de GDB: estado del stack ANTES, DURANTE y DESPUES de gini_asm
#  Uso:  gdb -q -batch -x docs/gdb_stack.gdb build/main_asm   (o: make gdb)
#
#  OJO: los breakpoints usan numeros de linea de c/main_asm.c y
#  asm/gini_asm.s. Si editan esos archivos, actualicen las lineas.
# =====================================================================
set pagination off
set confirm off
set debuginfod enabled off
set disassembly-flavor intel

break main_asm.c:18
break *gini_asm
break gini_asm.s:31
break gini_asm.s:53
break gini_asm.s:58
break gini_asm.s:36
break gini_asm.s:38
break main_asm.c:20
run

# --- bp main_asm.c:18 ------------------------------------------------
echo \n================ ANTES (main, todavia no apilo nada) ================\n
info registers rsp rbp
echo --- stack desde rsp: [rsp]=gini  [rsp+8]=resultado (sin valor aun) ---\n
x/4gx $rsp
echo --- variable gini leida como double ---\n
x/1fg $rsp

# --- bp *gini_asm (primera instruccion, antes de push rbp) ------------
continue
echo \n================ DURANTE 1 (entrada a gini_asm) ================\n
echo C hizo: sub rsp,8 / push gini / call  ->  rsp bajo 24 bytes\n
info registers rsp
echo --- [rsp]=dir. retorno a main  [rsp+8]=GINI APILADO POR C  [rsp+16]=relleno ---\n
x/3gx $rsp
x/1fg $rsp+8
echo --- xmm0 es relleno: el dato NO vino por registro ---\n
p $xmm0.v2_double[0]

# --- bp gini_asm.s:31 (prologo de gini_asm ejecutado) -----------------
continue
echo \n================ DURANTE 2 (gini_asm, frame armado) ================\n
info registers rsp rbp
echo --- [rbp]=rbp de main  [rbp+8]=dir. retorno  [rbp+16]=PARAMETRO de C ---\n
x/3gx $rbp
x/1fg $rbp+16

# --- bp gini_asm.s:53 (prologo de convertir_stack ejecutado) ----------
continue
echo \n================ DURANTE 3 (convertir_stack, frame armado) ================\n
info registers rsp rbp
echo --- [rbp]=rbp de gini_asm  [rbp+8]=dir. retorno  [rbp+16]=PARAMETRO ---\n
x/4gx $rbp
x/1fg $rbp+16

# --- bp gini_asm.s:58 (resultado ya escrito) --------------------------
continue
echo \n================ DURANTE 4 (convertir_stack, resultado escrito) ================\n
echo --- el slot [rbp+16] ahora tiene el RESULTADO (entero) ---\n
x/4gx $rbp
x/1dg $rbp+16

# --- bp gini_asm.s:36 (gini_asm ya leyo el resultado) -----------------
continue
echo \n================ DURANTE 5 (gini_asm leyo el resultado del stack) ================\n
info registers rsp rbp
x/1dg $rsp
p $rax

# --- bp gini_asm.s:38 (ret) + stepi: de vuelta en main ----------------
continue
stepi
echo \n================ DURANTE 6 (main, justo despues del call) ================\n
echo --- el argumento sigue apilado: lo limpia C con add rsp,0x10 (caller-cleanup) ---\n
x/2i $pc
info registers rsp
x/2gx $rsp

# --- bp main_asm.c:20 --------------------------------------------------
continue
echo \n================ DESPUES (main, linea 20) ================\n
info registers rsp rbp rax
echo --- rsp volvio al valor de ANTES; [rsp+8]=resultado ---\n
x/4gx $rsp
p resultado

continue
