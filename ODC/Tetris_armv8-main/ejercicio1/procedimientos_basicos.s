.include "datos.s" 

pintar_un_pixel:

	str w10, [x0, x5]		

	br lr

pintarLineaVertical:
	sub sp, sp, #16 // Guardo el puntero de retorno en la pila
        stur lr, [sp, #8]
        stur x2, [sp] // Guardo en la pila la coordenada en y del comienzo de la linea 

    loop_pintarLineaVertical:
        cmp x2, x4
        b.lt end_loop_pintarLineaVertical
        bl pintar_un_pixel
        sub x2,x2,#1
        bl ubicar_pixel;
        b loop_pintarLineaVertical

    end_loop_pintarLineaVertical:
        ldur lr, [sp, #8] // Recupero el puntero de retorno del stack
        ldur x2,[sp] // Recupero la coordenada en x del comienzo de la linea
        add sp, sp, #16 

        br lr 



pintar_triangulo_rectangulo:

	sub sp,sp,#8
	str lr,[sp]

    loop_triangulo_rectangulo: // loop para avanzar en y
		cmp x1,x3
       	b.lt end_loop_pintarTriangulo_rectangulo
       
       	add x11,xzr,xzr //inicializo x11 en cero
       	
       	loop_t_rec: 
			cmp x11,x13
			b.gt nueva_seccion_triangulo_rectangulo
				
			bl pintarLineaVertical	
			
			add x11,x11,#1
			sub x1,x1,#1 //decremento x_i inicial
       		bl ubicar_pixel

		b loop_t_rec 	

        nueva_seccion_triangulo_rectangulo:
			
        	sub x2,x2,#1
        	b loop_triangulo_rectangulo        

		b loop_triangulo_rectangulo

	end_loop_pintarTriangulo_rectangulo:
		ldr lr,[sp]
		add sp,sp,#8

        br lr

pintarLineaHorizontal:
        sub sp, sp, #16 // Guardo el puntero de retorno en la pila
        stur lr, [sp, #8]
        stur x1, [sp] // Guardo en la pila la coordenada en x del comienzo de la linea 

    loop_pintarLineaHorizontal:
        cmp x1, x3
        b.gt end_loop_pintarLineaHorizontal
        bl pintar_un_pixel
        add x1, x1, #1
        bl ubicar_pixel;
        b loop_pintarLineaHorizontal

    end_loop_pintarLineaHorizontal:
        ldur lr, [sp, #8] // Recupero el puntero de retorno del stack
        ldur x1, [sp] // Recupero la coordenada en x del comienzo de la linea
        add sp, sp, #16 

        br lr 



pintar_triangulo:

	sub sp,sp,#8
	str lr,[sp]

    loop_pintarTriangulo: // loop para avanzar en y
        cmp x2,x4
       	b.lt end_loop_pintarTriangulo

		add x11,xzr,xzr //inicializo x11 en cero
       	loop: 
			cmp x11,x13
			b.gt nueva_seccion_triangulo
			bl pintarLineaHorizontal	
			add x11,x11,#1
			sub x2,x2,#1 //decremento y_i inicial
        	bl ubicar_pixel
		b loop

		nueva_seccion_triangulo:
			add x1,x1,x14 // recupero x1 y aumento 1
        	sub x3,x3,x14 //decremento x1_f final
    		b loop_pintarTriangulo        

        b loop_pintarTriangulo
    
    end_loop_pintarTriangulo:

	    ldr lr,[sp]
		add sp,sp,#8

        br lr 

pintarCirculo:
        sub sp, sp, #8 // Guardo el puntero de retorno en el stack
        str lr, [sp]

        mov x15, x1 // Guardo en x15 la condenada del centro en x
        mov x16, x2 // Guardo en x16 la condenada del centro en y
        add x17, x1, x4 // Guardo en x17 la posición final en x
        add x11, x2, x4 // Guardo en x11 la posición final en y
        mul x12, x4, x4 // x12 = r^2 // para comparaciones en el loop
        sub x1, x1, x4 // Pongo en x2 la posición inicial en x

    loop0_pintarCirculo: // loop para avanzar en x
        cmp x1, x17
        b.gt end_loop0_pintarCirculo
        sub x2, x11, x4
        sub x2, x2, x4 // Pongo en x3 la posición inicial en y

    loop1_pintarCirculo: // loop para avanzar en y
        cmp x2, x11
        b.gt end_loop1_pintarCirculo // Veo si tengo que pintar el pixel actual
        sub x13, x1, x15 // x13 = distancia en x desde el pixel actual al centro
        smull x13, w13, w13 // x13 = w13 * w13 // Si los valores iniciales estaban en el rango permitido, x13 = w13 		//(sumll es producto signado)
        sub x14, x2, x16 // x14 = distancia en y desde el pixel actual al centro
        smaddl x13, w14, w14, x13 // x13 = x14*x14 + x13 // x13 = cuadrado de la distancia entre el centro y el pixel actual
        cmp x13, x12
        b.gt fi_pintarCirculo 
	bl ubicar_pixel
        bl pintar_un_pixel // Pinto el pixel actual

    fi_pintarCirculo:
        add x2, x2, #1
        b loop1_pintarCirculo

    end_loop1_pintarCirculo:
        add x1, x1, #1
        b loop0_pintarCirculo

    end_loop0_pintarCirculo:
        mov x1, x15 // Restauro en x2 la condenada del centro en x
        mov x2, x16 // Restauro en x3 la condenada del centro en y
 

       ldr lr, [sp] // Recupero el puntero de retorno del stack
        add sp, sp, #8 

        br lr // return


pintar_rectangulo:
		
		sub sp,sp,#8
		str lr,[sp]
		
	
    loop_pintarRectangulo: 
        cmp x2, x4
        b.gt end_loop_pintarRectangulo
        bl pintarLineaHorizontal
        add x2, x2, #1
        bl ubicar_pixel
        b loop_pintarRectangulo
    
    end_loop_pintarRectangulo:

	    ldr lr,[sp]
		add sp,sp,#8

        br lr 

ubicar_pixel : 
		
		sub sp,sp,#8
		str lr,[sp]
		
		mov x5,SCREEN_WIDTH //cargo el valor de 640 
		madd x5, x5,x2,x1 //x5 =(x5*y) + x 
		lsl x5,x5,2   // 4*(x+(640*y))

		ldr lr,[sp]
		add sp,sp,#8
		br lr
