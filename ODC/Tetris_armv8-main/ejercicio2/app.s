.include "graficos.s" 


.globl main

main:
	//guardo en x19 el GPIO_BASE
	mov x19,GPIO_BASE

	bl pintar_fondo_de_noche
	bl cuadradito
InfLoop:
	b InfLoop
