.include "procedimientos_basicos.s" 

pintar_sol:
	
	sub sp, sp, #8 // Guardo el puntero de retorno en el stack
        str lr, [sp]
	
	//linea superior que decora el sol
	ldr x10,color_del_sol		
	mov x1,45	 	// posicion x inicial del pixel
	mov x2,35	       // posicion y inicial del pixel
	mov x3,200  //posicion x final del pixel
	mov x4,37            // posicion y final del pixel

	bl ubicar_pixel
	bl pintar_rectangulo
	
	//lineas inferiores que  decoran el sol
	
	//linea 1

	ldr x10,color_del_sol		
	mov x1,35	 	// posicion x inicial del pixel
	mov x2,104	       // posicion y inicial del pixel
	mov x3,300  //posicion x final del pixel
	mov x4,106            // posicion y final del pixel

	bl ubicar_pixel
	bl pintar_rectangulo
		
	// linea 2

	ldr x10,color_del_sol		
	mov x1,45	 	// posicion x inicial del pixel
	mov x2,110	       // posicion y inicial del pixel
	mov x3,200  //posicion x final del pixel
	mov x4,112            // posicion y final del pixel

	bl ubicar_pixel
	bl pintar_rectangulo
			







	//Pinto el sol
	ldr x10,color_del_sol
	mov x1,120  //valor de coordenada x central del circulo
	mov x2,70   //valor de coordenada y central del circulo
	mov x4,30   //uso el x4 como radio del circulo	
	
	bl pintarCirculo

	ldr lr, [sp] // Recupero el puntero de retorno del stack
    	add sp, sp, #8 

    	br lr 






pintar_piramides_de_dia:

		sub sp,sp,#8
		str lr,[sp]
		
		ldr x10,color_piramide_cara_frente

		//triangulo de la derecha al fondo
		mov x1,480               // posicion x inicial del pixel
		mov x2,350		       // posicion y inicial del pixel
		mov x3,640		      //posicion x final del pixel
		mov x4,110           // posicion y final del pixel
		mov x13,#2			//indica la cantidad de veces que que pinta una seccion del triangulo
		mov x14,#1        //indica cuanto pixeles se debe achicar de los lados al triangulo cada fila
		bl ubicar_pixel
		bl pintar_triangulo

		//bl pintar_relieve

		//triangulo de la izquierda al fondo
		mov x1,300               // posicion x inicial del pixel
		mov x2,350		       // posicion y inicial del pixel
		mov x3,460		      //posicion x final del pixel
		mov x4,100           // posicion y final del pixel
		mov x13,#1			//indica la cantidad de veces que que pinta una seccion del triangulo

		bl ubicar_pixel
		bl pintar_triangulo



		//sombra piramide izquierda

		ldr x10,color_sombra_en_suelo

        mov x1,460              // posicion x inicial del pixel
        mov x2,430             // posicion y inicial del pixel
        mov x3,300            //posicion x final del pixel
        mov x4,350           // posicion y final del pixel

        bl ubicar_pixel
        bl pintar_triangulo_rectangulo
         

        //sombra piramide derecha

		ldr x10,color_sombra_en_suelo

        mov x1,640              // posicion x inicial del pixel
        mov x2,440            // posicion y inicial del pixel
        mov x3,480            //posicion x final del pixel
        mov x4,350           // posicion y final del pixel
        mov x13,#1
        bl ubicar_pixel
        bl pintar_triangulo_rectangulo

		ldr lr,[sp]
		add sp,sp,#8
        br lr 

pintar_cielo_de_dia:

	sub sp,sp,#8
	str lr,[sp]

	ldr x10,color_cielo_dia_1

	mov x1,0                // posicion x inicial del pixel
	mov x2,0		       // posicion y inicial del pixel
	mov x3,SCREEN_WIDTH   //posicion x final del pixel
	mov x4,20           // posicion y final del pixel

	bl ubicar_pixel
	bl pintar_rectangulo


	ldr x10,color_cielo_dia_2
	mov x2,21		       // posicion y inicial del pixel
	mov x4,41           // posicion y final del pixel
	bl ubicar_pixel
	bl pintar_rectangulo

	ldr x10,color_cielo_dia_3
	mov x2,42		       // posicion y inicial del pixel
	mov x4,62           // posicion y final del pixel
	bl ubicar_pixel
	bl pintar_rectangulo

	ldr x10,color_cielo_dia_4
	mov x2,63		       // posicion y inicial del pixel
	mov x4,83           // posicion y final del pixel
	bl ubicar_pixel
	bl pintar_rectangulo

	ldr x10,color_cielo_dia_5
	mov x2,84		       // posicion y inicial del pixel
	mov x4,104           // posicion y final del pixel
	bl ubicar_pixel
	bl pintar_rectangulo

	ldr x10,color_cielo_dia_6
	mov x2,105		       // posicion y inicial del pixel
	mov x4,125           // posicion y final del pixel
	bl ubicar_pixel
	bl pintar_rectangulo


	ldr x10,color_cielo_dia_7
	mov x2,126		       // posicion y inicial del pixel
	mov x4,146           // posicion y final del pixel
	bl ubicar_pixel
	bl pintar_rectangulo
	
	ldr x10,color_cielo_dia_8
	mov x2,147		       // posicion y inicial del pixel
	mov x4,167           // posicion y final del pixel
	bl ubicar_pixel
	bl pintar_rectangulo
	
	ldr x10,color_cielo_dia_9
	mov x2,168		       // posicion y inicial del pixel
	mov x4,188           // posicion y final del pixel
	bl ubicar_pixel
	bl pintar_rectangulo
	
	ldr x10,color_cielo_dia_10
	mov x2,189		       // posicion y inicial del pixel
	mov x4,209           // posicion y final del pixel
	bl ubicar_pixel
	bl pintar_rectangulo
	
	ldr x10,color_cielo_dia_11
	mov x2,210		       // posicion y inicial del pixel
	mov x4,230           // posicion y final del pixel
	bl ubicar_pixel
	bl pintar_rectangulo

	ldr x10,color_cielo_dia_12
	mov x2,231		       // posicion y inicial del pixel
	mov x4,251           // posicion y final del pixel
	bl ubicar_pixel
	bl pintar_rectangulo


	ldr x10,color_cielo_dia_13
	mov x2,252		       // posicion y inicial del pixel
	mov x4,272           // posicion y final del pixel
	bl ubicar_pixel
	bl pintar_rectangulo
	
	ldr x10,color_cielo_dia_14
	mov x2,273		       // posicion y inicial del pixel
	mov x4,293           // posicion y final del pixel
	bl ubicar_pixel
	bl pintar_rectangulo
	
	ldr x10,color_cielo_dia_15
	mov x2,273		       // posicion y inicial del pixel
	mov x4,293           // posicion y final del pixel
	bl ubicar_pixel
	bl pintar_rectangulo
	
	ldr x10,color_cielo_dia_16
	mov x2,294		       // posicion y inicial del pixel
	mov x4,304           // posicion y final del pixel
	bl ubicar_pixel
	bl pintar_rectangulo
	

	ldr x10,color_cielo_dia_17
	mov x2,305		       // posicion y inicial del pixel
	mov x4,315           // posicion y final del pixel
	bl ubicar_pixel
	bl pintar_rectangulo
	

	ldr x10,color_cielo_dia_18
	mov x2,316		       // posicion y inicial del pixel
	mov x4,326           // posicion y final del pixel
	bl ubicar_pixel
	bl pintar_rectangulo
	
	ldr x10,color_cielo_dia_19
	mov x2,327		       // posicion y inicial del pixel
	mov x4,337           // posicion y final del pixel
	bl ubicar_pixel
	bl pintar_rectangulo
	
	ldr x10,color_cielo_dia_20
	mov x2,338		       // posicion y inicial del pixel
	mov x4,349           // posicion y final del pixel
	bl ubicar_pixel
	bl pintar_rectangulo
	
	ldr lr,[sp]
	add sp,sp,#8

	br lr

pintar_desierto_de_dia:
		
		sub sp,sp,#8
		str lr,[sp]

		ldr x10,color_desierto

		mov x1,0                // posicion x inicial del pixel
		mov x2,350		       // posicion y inicial del pixel
		mov x3,SCREEN_WIDTH   //posicion x final del pixel		
		mov x4,480           // posicion y final del pix20el

		bl ubicar_pixel

		bl pintar_rectangulo

		ldr lr,[sp]
		add sp,sp,#8

		br lr



pintar_fondo_de_dia:

		sub sp,sp,#8
		str lr,[sp]

		bl pintar_desierto_de_dia
		bl pintar_cielo_de_dia
		bl pintar_piramides_de_dia
		bl pintar_sol
		leer_tecla:

			str wzr,[x19,GPIO_GPFSEL0]
			ldr w18,[x19,GPIO_GPLEV0]
			and w17,w18,0b00000010
			cbnz w17,pintar_fondo_de_noche		

			b leer_tecla 
		
		ldr lr,[sp]
		add sp,sp,#8
		br lr


//SECCION PINTADO DE NOCHE


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

pintar_luna:
	
	sub sp,sp,#8
	str lr,[sp]	


	//Pinto la luna
	ldr x10,color_de_la_luna
	mov x1,120  //valor de coordenada x central del circulo
	mov x2,70   //valor de coordenada y central del circulo
	mov x4,30   //uso el x4 como radio del circulo	
	
	bl pintarCirculo

	ldr lr,[sp]
	add sp,sp,#8

	br lr	



pintar_fondo_de_noche:

		sub sp,sp,#8
		str lr,[sp]

		bl pintar_desierto_noche
		bl pintar_cielo_noche
		bl pintar_piramides_noche

		bl pintar_luna

		ldr lr,[sp]
		add sp,sp,#8
		br lr
