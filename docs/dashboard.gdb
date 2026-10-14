# =====================================================================
#  Sesion interactiva con GDB Dashboard para las capturas del stack.
#  Uso (desde la raiz del repo):  gdb -q -x docs/dashboard.gdb build/main_asm
#  Despues de cada captura, escribir:  paso
# =====================================================================
set debuginfod enabled off
set confirm off
set disassembly-flavor intel

dashboard -layout source assembly registers stack memory expressions !breakpoints !history !threads !variables
dashboard expressions watch $xmm0.v2_double[0]

break main_asm.c:18
break *gini_asm
break gini_asm.s:31
break gini_asm.s:53
break gini_asm.s:58
break main_asm.c:20
run

# Primera parada (ANTES): fija la zona del stack que se observa en todas las capturas
set $base = $rsp - 0x40
dashboard memory watch $base 96

# paso: avanza al siguiente breakpoint y muestra el stack en bloques de 8 bytes
define paso
  continue
  x/12gx $base
end

# Redibuja el dashboard para que el panel de memoria ya aparezca en ANTES
dashboard
x/12gx $base
