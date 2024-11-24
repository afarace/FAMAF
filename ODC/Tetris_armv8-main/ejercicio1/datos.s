.equ SCREEN_WIDTH,   640
.equ SCREEN_HEIGH,   480
.equ BITS_PER_PIXEL, 32

.equ GPIO_BASE,    0x3f200000
.equ GPIO_GPFSEL0, 0x00
.equ GPIO_GPLEV0,  0x34

//SECCION COLORES 


//Colores de fondo

color_sombra_en_suelo: .word 0xdb9d60
color_desierto: .word 0xe8a669
color_piramide_cara_frente: .word 0xb98450


//COLORES PARA EL CIELO DE DIA

color_cielo_dia_1 : .word 0xb0f2ff
color_cielo_dia_2 : .word  0xb8eefa
color_cielo_dia_3 : .word 0xbef1f5
color_cielo_dia_4 : .word 0xc0f0f0
color_cielo_dia_5 : .word 0xcaeeec
color_cielo_dia_6 : .word 0xceefe8
color_cielo_dia_7 : .word 0xddefe1
color_cielo_dia_8 : .word 0xdfedd6

//parte de atardecer
color_cielo_dia_9 : .word 0xedecce
color_cielo_dia_10: .word 0xe5edd5
color_cielo_dia_11: .word 0xf2ecc8
color_cielo_dia_12: .word 0xefeccd
color_cielo_dia_13: .word 0xf1ebcb
color_cielo_dia_14: .word 0xf2ecc8
color_cielo_dia_15: .word 0xf6ecc8
color_cielo_dia_16: .word 0xf8ecc6
color_cielo_dia_17: .word 0xfdebc3
color_cielo_dia_18: .word 0xf9ebc4
color_cielo_dia_19: .word 0xfdebc3
color_cielo_dia_20: .word 0xfeecbe

//COLORES PARA EL CIELO DE NOCHE

color_cielo_noche_1 : .word 0x010f32
color_cielo_noche_2 : .word 0x04163e
color_cielo_noche_3 : .word 0x011a43
color_cielo_noche_4 : .word 0x001c4a
color_cielo_noche_5 : .word 0x032555
color_cielo_noche_6 : .word 0x053065
color_cielo_noche_7 : .word 0x033675
color_cielo_noche_8 : .word 0x023977

//parte noche iluminada
color_cielo_noche_9 : .word 0x014286
color_cielo_noche_10: .word 0x014489
color_cielo_noche_11: .word 0x02478c
color_cielo_noche_12: .word 0x03488d
color_cielo_noche_13: .word 0x034b96
color_cielo_noche_14: .word 0x01509d
color_cielo_noche_15: .word 0x024ca6
color_cielo_noche_16: .word 0x0455a4
color_cielo_noche_17: .word 0x0158a8
color_cielo_noche_18: .word 0x0358a9


color_piramide_frente_noche: .word 0x010812
color_piramide_atras_noche:  .word 0x06182c
color_suelo_inferior_noche:   .word 0x010b14
color_suelo_superior_noche:   .word 0x0a253a
color_de_la_luna: .word 0xf5f9fa
color_del_sol: .word 0xf5a51c
