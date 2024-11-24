.include "procedimientos_basicos.s" 

//SECCION PINTADO DE NOCHE


cuadradito:
	
	sub sp,sp,#8
	str lr,[sp]

	
	ldr x10,color_cajita

	mov x1,5               // posicion x inicial del pixel
	mov x2,50	      // posicion y inicial del pixel
	mov x3,55	     //posicion x final del pixel
	mov x4,100           // posicion y final del pixel

	bl ubicar_pixel
	bl pintar_cuadrado

	ldr lr,[sp]
	add sp,sp,#8

	br lr

	






pintar_cielo_noche:

	sub sp,sp,#8
	str lr,[sp]

	ldr x10,color_cielo_noche_1

	mov x1,0                // posicion x inicial del pixel
	mov x2,0		       // posicion y inicial del pixel
	mov x3,SCREEN_WIDTH   //posicion x final del pixel
	mov x4,20           // posicion y final del pixel

	bl ubicar_pixel
	bl pintar_rectangulo


	ldr x10,color_cielo_noche_2
	mov x2,21		       // posicion y inicial del pixel
	mov x4,41           // posicion y final del pixel
	bl ubicar_pixel
	bl pintar_rectangulo

	ldr x10,color_cielo_noche_3
	mov x2,42		       // posicion y inicial del pixel
	mov x4,62           // posicion y final del pixel
	bl ubicar_pixel
	bl pintar_rectangulo

	ldr x10,color_cielo_noche_4
	mov x2,63		       // posicion y inicial del pixel
	mov x4,83           // posicion y final del pixel
	bl ubicar_pixel
	bl pintar_rectangulo

	ldr x10,color_cielo_noche_5
	mov x2,84		       // posicion y inicial del pixel
	mov x4,104           // posicion y final del pixel
	bl ubicar_pixel
	bl pintar_rectangulo

	ldr x10,color_cielo_noche_6
	mov x2,105		       // posicion y inicial del pixel
	mov x4,125           // posicion y final del pixel
	bl ubicar_pixel
	bl pintar_rectangulo


	ldr x10,color_cielo_noche_7
	mov x2,126		       // posicion y inicial del pixel
	mov x4,146           // posicion y final del pixel
	bl ubicar_pixel
	bl pintar_rectangulo
	
	ldr x10,color_cielo_noche_8
	mov x2,147		       // posicion y inicial del pixel
	mov x4,167           // posicion y final del pixel
	bl ubicar_pixel
	bl pintar_rectangulo
	
	ldr x10,color_cielo_noche_9
	mov x2,168		       // posicion y inicial del pixel
	mov x4,188           // posicion y final del pixel
	bl ubicar_pixel
	bl pintar_rectangulo
	
	ldr x10,color_cielo_noche_10
	mov x2,189		       // posicion y inicial del pixel
	mov x4,209           // posicion y final del pixel
	bl ubicar_pixel
	bl pintar_rectangulo
	
	ldr x10,color_cielo_noche_11
	mov x2,210		       // posicion y inicial del pixel
	mov x4,230           // posicion y final del pixel
	bl ubicar_pixel
	bl pintar_rectangulo

	ldr x10,color_cielo_noche_12
	mov x2,231		       // posicion y inicial del pixel
	mov x4,251           // posicion y final del pixel
	bl ubicar_pixel
	bl pintar_rectangulo


	ldr x10,color_cielo_noche_13
	mov x2,252		       // posicion y inicial del pixel
	mov x4,272           // posicion y final del pixel
	bl ubicar_pixel
	bl pintar_rectangulo
	
	ldr x10,color_cielo_noche_14
	mov x2,273		       // posicion y inicial del pixel
	mov x4,314           // posicion y final del pixel
	bl ubicar_pixel
	bl pintar_rectangulo


	ldr x10,color_cielo_noche_15
	mov x2,315		       // posicion y inicial del pixel
	mov x4,335           // posicion y final del pixel
	bl ubicar_pixel
	bl pintar_rectangulo
	

	ldr x10,color_cielo_noche_16
	mov x2,336		       // posicion y inicial del pixel
	mov x4,356           // posicion y final del pixel
	bl ubicar_pixel
	bl pintar_rectangulo
	

	ldr x10,color_cielo_noche_17
	mov x2,357		       // posicion y inicial del pixel
	mov x4,377           // posicion y final del pixel
	bl ubicar_pixel
	bl pintar_rectangulo
	
	ldr x10,color_cielo_noche_18
	mov x2,378		       // posicion y inicial del pixel
	mov x4,389           // posicion y final del pixel
	bl ubicar_pixel
	bl pintar_rectangulo
	
	
	ldr lr,[sp]
	add sp,sp,#8

	br lr



pintar_piramides_noche:

		sub sp,sp,#8
		str lr,[sp]
		
		ldr x10,color_piramide_frente_noche

		//triangulo de la derecha al fondo
		mov x1,180               // posicion x inicial del pixel
		mov x2,480		       // posicion y inicial del pixel
		mov x3,640		      //posicion x final del pixel
		mov x4,300           // posicion y final del pixel
		mov x13,#2			//indica la cantidad de veces que se pinta una seccion del triangulo
		mov x14,#4			//indica cuanto pixeles se debe achicar de los lados al triangulo en  cada fila

		bl ubicar_pixel
		bl pintar_triangulo

		//piramide izquierda

		ldr x10,color_piramide_atras_noche

		//triangulo de la derecha al fondo
		mov x1,80               // posicion x inicial del pixel
		mov x2,390		       // posicion y inicial del pixel
		mov x3,250		      //posicion x final del pixel
		mov x4,300           // posicion y final del pixel
		mov x13,#1			//indica la cantidad de veces que se pinta una seccion del triangulo
		mov x14,#2			//indica cuanto pixeles se debe achicar de los lados al triangulo en  cada fila

		bl ubicar_pixel
		bl pintar_triangulo

		ldr lr,[sp]
		add sp,sp,#8
        br lr 

pintar_desierto_noche:	

		sub sp,sp,#8
		str lr,[sp]

		ldr x10,color_suelo_inferior_noche

		mov x1,0                // posicion x inicial del pixel
		mov x2,420		       // posicion y inicial del pixel
		mov x3,SCREEN_WIDTH   //posicion x final del pixel
		mov x4,480           // posicion y final del pixel

		bl ubicar_pixel
		bl pintar_rectangulo


		ldr x10,color_suelo_superior_noche

		mov x1,0                // posicion x inicial del pixel
		mov x2,390		       // posicion y inicial del pixel
		mov x3,SCREEN_WIDTH   //posicion x final del pixel
		mov x4,420           // posicion y final del pixel

		bl ubicar_pixel
		bl pintar_rectangulo

		ldr lr,[sp]
		add sp,sp,#8

		br lr
	
pintar_fondo_de_noche:

		sub sp,sp,#8
		str lr,[sp]

		bl pintar_desierto_noche
		bl pintar_cielo_noche
		bl pintar_piramides_noche

		ldr lr,[sp]
		add sp,sp,#8
		br lr
