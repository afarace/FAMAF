#include <stdio.h>
#include <stdbool.h>

#include "APIG23.h"
#include "APIParte2.h"

static void swap(u32* coloreo_ip, u32* coloreo_j ){
    u32 *aux = coloreo_ip;
    coloreo_ip = coloreo_j;
    coloreo_j = aux;
}

u32* copy_array(u32* array, u32 size) {
    u32* copy = malloc(sizeof(u32) * size);
    for (u32 i = 0; i < size; i++) {
        copy[i] = array[i];
    }

    return copy;
}

int main(void) {
    Grafo g = ConstruirGrafo(stdin);            //retorna NULL en caso de error (documentación)
    if (g == NULL) {
        printf("Hubo un error en la construcción del grafo\n");
        return 1;
    }
    printf("Grafo construído correctamente\n\n");

    u32 n = NumeroDeVertices(g);

    u32* Orden = malloc(sizeof(u32) * n);
    u32* Color = malloc(sizeof(u32) * n);

    if (Orden == NULL || Color == NULL) {
        DestruirGrafo(g);
        printf("Hubo un error en el pedido de memoria\n");
        return 1;
    }

    // Definimos el orden natural de los vertices
    for (u32 i = 0; i < n; i++) {
        Orden[i] = i;
    }
    
    u32 coloreo = Greedy(g, Orden, Color);
    
    printf("Coloreo Orden Natural = %u\n\n", coloreo);

    // Arreglos para guardar los coloreos de OrdenImparPar y OrdenJedi
    u32* coloreo1 = copy_array(Color, n);
    u32* coloreo2 = copy_array(Color, n);

    // Arreglos para guardar los ordenes de IP y Jedi
    u32* orden1 = copy_array(Orden, n);
    u32* orden2 = copy_array(Orden, n);

    free(Orden);
    free(Color);

    /* Comentario respecto al código que sigue debajo:
    Corren en total 512 veces cada Orden, en total 1024 iteraciones, 
    cada 16 iteraciones swapeamos arrays de colores. En esta implementación, 
    podemos ver que ya en la primera ejecución del for se swapea, pero es un 
    detalle menor, ya que coloreo1 y coloreo2 entran ambos con los valores de 
    Color. Para evitar esto podríamos inicializar i = 1, pero esto haría que 
    la primer tanda de greedys se ejecute 15 veces cada orden, en lugar de 16.
    */
    u32 valor_ret = 0u;    // variable para retornar, 0 si no hubo errores, 1 si hubo alguno.

    /* estas dos variables son para chequear que no se rompa el Very Important Theorem
    se inicializan con el coloreo del orden natural, y chequeamos que cada coloreo
    nuevo, no sea mayor al coloreo anterior */
    u32 vit_ip = coloreo;
    u32 vit_jd = coloreo;

    for (u32 i = 0; i < 512; i++) {
        if (i % 16 == 0) {
            swap(coloreo1, coloreo2);
        } 

        u32 err = OrdenImparPar(n, orden1, coloreo1);
        // en caso de error retorna 1
        if (err == 1) {
            valor_ret = err;
            break;
        }
        u32 coloreoip = Greedy(g, orden1, coloreo1);
        if (coloreoip == 0xffffffffU || coloreoip > vit_ip) {
            printf("Hubo un error en greedy o se rompió el V.I.T en ImparPar\n");
            valor_ret = 1;
            break;
        }
        vit_ip = coloreoip;
        
        printf("Coloreo IP n° %u = %u\n", i, coloreoip); 
        
        // Ahora para Jedi
        err = OrdenJedi(g, orden2, coloreo2);
        if (err == 1) {
            valor_ret = err;
            break;
        }
        u32 coloreojedi = Greedy(g, orden2, coloreo2);
        if (coloreojedi == 0xffffffffU || coloreojedi > vit_jd) {
            printf("Hubo un error en greedy o se rompió el V.I.T en Jedi\n");
            valor_ret = 1;
            break;
        }
        vit_jd = coloreojedi;

        printf("\t\t\tColoreo JEDI n° %u = %u\n", i, coloreojedi); 
    } 

    free(coloreo1);
    free(coloreo2);
    free(orden1);
    free(orden2);
    DestruirGrafo(g);
    return valor_ret;
}
