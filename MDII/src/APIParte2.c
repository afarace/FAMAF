#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

#include "APIParte2.h"


/* GREEDY */

/* Función que calcula el mínimo número natural (incluído el 0), que no existe en un array.
   En este caso aplicado a greedy, buscamos el mínimo color que no existe en el array de
   colores de los vecinos de un vértice, i.e color con el que lo vamos a pintar.
   Retorna el mínimo natural no existente en el array
*/
static u32 minimo_no_existente(u32* array, u32 size) {
    // Arreglo de booleanos que indica si el color i (i = 0..size+1) está presente en el array de colores de los vecinos.
    u32* colores_presentes = calloc(size+1, sizeof(u32));
    // Sabemos que calloc inicializa todo en 0 (CleanALLOC), por lo que no hace falta inicializar el array en false.
    if (colores_presentes == NULL) return 0xffffffffU;          // 2^32-1

    // Recorreremos el array de colores de los vecinos, y marcamos en el arreglo de booleanos los colores que estén presentes.
    for (u32 i = 0; i < size; i++) {
        if (array[i] <= size) {
            colores_presentes[array[i]] = 1;
        }
    }

    // Recorremos el array de booleanos, y devolvemos el primer índice que sea false, osea, el menor color que no está.  
    for (u32 i = 0; i < size+1; i++) {
        if (colores_presentes[i] == 0) {
            free(colores_presentes);
            return i;
        }
    }
    
    // Si todos los colores están presentes, el mínimo color no existente es size+1.
    free(colores_presentes);
    return size+1;
}

static u32 pintar_vertice(Grafo G, u32 vertice_k, u32* Color) {
    // pido memoria para un array de Grado(vertice_k) elementos
    u32* colores_vecinos = malloc(sizeof(u32) * Grado(vertice_k, G));
    if (colores_vecinos == NULL) return 0xffffffffU;  

    // leo vecinos, guardo sus colores en el array
    for (u32 j = 0; j < Grado(vertice_k, G); j++) {
        colores_vecinos[j] = Color[IndiceVecino(j, vertice_k, G)];
    }

    // encuentro el color con el que voy a pintar k.
    u32 color_k = minimo_no_existente(colores_vecinos, Grado(vertice_k, G));

    free(colores_vecinos);
    return color_k;
}

// Corre Greedy en el orden 'Orden', carga el coloreo en Color 
// y devuelve el numero de colores usado
u32 Greedy(Grafo G, u32* Orden, u32* Color) {
    assert(Orden != NULL && Color != NULL);
    u32 cant_colores = 0;               // valor a retornar. Cantidad de colores con los que se pintó.
    u32 no_pintado = 0xffffffffU;
    
    //inicializo Color. Si Color[i] = 2^32-1, asumimos que no está pintado. 
    for (u32 c = 0; c < NumeroDeVertices(G); c++) {
        Color[c] = no_pintado;
    }
    Color[Orden[0]] = 0u;       //pintamos primer vértice con color 0.
    
    // Greedy. Criterio de selección: pinto el vértice con el color más chico que pueda.
    for (u32 i = 1; i < NumeroDeVertices(G); i++) {
        // vértice cuyo índice es k en el Orden Natural, i.e el vértice procesado en Greedy en el lugar i.
        u32 k = Orden[i];            

        // pinto vértice k, en caso de no pintarse por algún error devuelve 2^32-1   
        Color[k] = pintar_vertice(G, k, Color);
        
        // chequeo error
        if (Color[k] == no_pintado)  return no_pintado;
        
        // actualizo cant. colores que estoy usando, en caso que pinte con un nuevo color.
        if (Color[k] > cant_colores)  cant_colores = Color[k];
    }
    
    //como los colores se cuentan desde 0, y usé nro_color asignar el color más grande con el que pinté, le sumo 1 al retornar.
    return cant_colores+1;              
}




/* ORDEN IMPARPAR */

struct Vertices {
    u32 VColor;
    u32 VIndice;
};

// Función de comparación para qsort en imparpar
static int cmpImparPar(const void *a, const void *b) {
    const struct Vertices *vertice1 = (const struct Vertices *) a;
    const struct Vertices *vertice2 = (const struct Vertices *) b;
    if (vertice1->VColor > vertice2->VColor)  return -1;
    
	else if (vertice1->VColor < vertice2->VColor)  return 1;
	
    else  return 0;
}

// Ordena indices de color de mayor a menor impar y luego par
char OrdenImparPar(u32 n, u32* Orden, u32* Color) {
    // Creamos dos arrays auxiliares para guardar los índices pares e impares
    struct Vertices* indicesPares = (struct Vertices*)malloc(n * sizeof(struct Vertices));
    struct Vertices* indicesImpares = (struct Vertices*)malloc(n * sizeof(struct Vertices));
    if (indicesPares == NULL || indicesImpares == NULL) {
        // Falló el allocation de memoria auxiliar
        free(indicesPares);
        free(indicesImpares);
        return 1;
    }

    u32 contPares = 0;
    u32 contImpares = 0;
    
    for (u32 i = 0; i < n; i++) {
        if (Color[i] % 2 == 0) {
            indicesPares[contPares].VColor = Color[i];
            indicesPares[contPares].VIndice = i;
            contPares++;
        }
        else {
            indicesImpares[contImpares].VColor = Color[i];
            indicesImpares[contImpares].VIndice = i;
            contImpares++;
        }
    }

    // Ordenamos los índices impares y pares por valor de color
    qsort(indicesImpares, contImpares, sizeof(struct Vertices), cmpImparPar);
    qsort(indicesPares, contPares, sizeof(struct Vertices), cmpImparPar);

    // Concatenamos los índices ordenados en el array Orden
    for (u32 i = 0; i < contImpares; i++) {
        Orden[i] = indicesImpares[i].VIndice;
    }
    for (u32 i = 0; i < contPares; i++) {
        Orden[i + contImpares] = indicesPares[i].VIndice;
    }

    free(indicesPares);
    free(indicesImpares);
    return 0;
}




/* ORDEN JEDI */

// Estructura auxiliar para Orden Jedi
typedef struct {
    u32 x;
    u32 fx;
    u32 indice;
} ParXFX;

static u32 ObtenerR(u32 n, u32* Color) {
    u32 r = 0; // Inicializar r en 0
    // Recorrer el arreglo Color y buscar el valor máximo
    for (u32 i = 0; i < n; i++) {
        if (Color[i] > r) {
            r = Color[i];
        }
    }
    // Incrementar en 1 para obtener el valor de r
    r += 1;
    return r;
}

static int cmpjedi(const void *a, const void *b) {
    const ParXFX *par1 = a, *par2 = b;
    if (par1->fx < par2->fx) {
        return 1;
    }else if (par1->fx > par2->fx) {
        return -1;
    } else {
        // En caso de que las F(x) sean iguales, ordenar por color, de mayor a menor. 
        if (par1->x < par2->x) {
            return 1;
        } else if (par1->x > par2->x) {
            return -1;
        } else {
            return 0;
        }
    }
}

// Ordena indices en la forma especial dada en las especificaciones
char OrdenJedi(Grafo G,u32* Orden,u32* Color) {
    u32 n = NumeroDeVertices(G);
    u32 r = ObtenerR(n, Color);
    ParXFX *array_aux = calloc(n, sizeof(ParXFX));
    u32 *f = calloc(r, sizeof(u32));
    if (array_aux == NULL || f == NULL) {
        //Error al reservar memoria
        free(array_aux);
        free(f);
        return 1;
    }
    // Para cada color x obtengo su F(x)
    for (unsigned int i = 0; i < n; i++) {
        f[Color[i]] += Grado(i, G);  
    }
    for (unsigned int i = 0; i < r; i++) {
        f[i] = f[i] * i;  
    }
    
    // A cada vértice i le agrego su color x y el valor fx
    for (u32 i = 0; i < n; i++) {
        array_aux[i].x = Color[i];
        array_aux[i].fx = f[Color[i]];
        array_aux[i].indice = i;
    }

    // Ordeno el arreglo auxiliar en base al criterio
    qsort(array_aux, n, sizeof(ParXFX), cmpjedi);

    // Paso los indices del array ordenado a Orden
    for (unsigned int i = 0; i < n; i++) {
        Orden[i] = array_aux[i].indice;
    }

    free(array_aux);
    free(f);

    return 0;
}
