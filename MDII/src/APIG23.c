#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include "APIG23.h"
#include "EstructuraGrafo23.h"

#define BUFFER_SIZE 80

//Estructura auxiliar para cargar los lados del grafo.
typedef struct Lados{
    u32 v1;
    u32 v2;
} Lados;


/*FUNCIONES AUXILIARES*/

//Obtiene el índice de un vértice en un array ordenado (búsqueda binaria)
int ObtenerIndiceDesdeNombre(u32 *arr, u32 n, u32 x) {
    int lo = 0, hi = n-1, mid;
    while (lo <= hi) {
        mid = lo + (hi-lo)/2;
        if (arr[mid] == x) {
            return mid;
        } else if (arr[mid] < x) {
            lo = mid + 1;
        } else {
            hi = mid - 1;
        }
    }
    return -1;  // si no se encuentra el número
}

//Función de comparación para qsort
static int cmpv1(const void *a, const void *b) {
    const Lados *p = a, *q = b;
    if (p->v1 < q->v1) {
        return -1;
    }
    if (p->v1 > q->v1) {
        return 1;
    }
    if (p->v2 < q->v2) {
        return -1;
    }
    if (p->v2 > q->v2) {
        return 1;
    }
    //Si se llega hasta acá, quiere decir que los lados son iguales
    return 0;
}

//Función para la lectura de lados desde stdin
Lados *lectura_lados(u32 max_lados) {
    Lados *array_lados = (Lados *) calloc(max_lados*2,sizeof(Lados));
    if (!array_lados) {
        fprintf(stderr, "No se pudo asignar memoria para el array de lados.\n");
        return NULL;
    }

    char linea[BUFFER_SIZE];
    u32 i = 0; u32 lineas = 0; 
    while (fgets(linea, BUFFER_SIZE, stdin) && lineas < max_lados) {
        ++lineas;
        if (linea[0] != 'e') {
            fprintf(stderr, "Formato incorrecto en la línea e v w1\n");
            return NULL;
        }
        u32 j=0, k=0;
        int res = sscanf(linea, "e %u%*[ \t]%u%*[ \t]\n", &j, &k);
        if (res != 2) {
            fprintf(stderr, "Formato incorrecto en la línea e v w\n");
            return NULL;
        }
    
        array_lados[i].v1 = j; 
        array_lados[i].v2 = k;
        array_lados[i+1].v1 = k; 
        array_lados[i+1].v2 = j;

        i += 2;    
    }

    if (lineas < max_lados) {
        fprintf(stderr, "El archivo contiene menos de m líneas\n");
        return NULL;
    }

    return array_lados;
}

//Función para cargar la información de cada vértice
void data_vertices(Grafo grafo, u32 vertices_num, u32 *vertices_n, Lados *array_lados) {
    grafo->vertices = calloc(vertices_num, sizeof(VerticeSt*));
    u32 max_delta = 0;
    u32 j = 0;      //iterador para array_lados--índice de array_lados
    for (u32 i = 0; i < grafo->n; i++) {
        grafo->vertices[i] = malloc(sizeof(VerticeSt));
        grafo->vertices[i]->nombre = array_lados[j].v1;
        
        //Agregamos el primer vecino (fuera del while ya que necesito esta estructura para poder reallocar memoria si tengo más vecinos)
        u32 nro_vec = 1;                       //Variable para indexar el arreglo vecinos y contar el grado del vértice actual (cantidad de vecinos)
        u32 realloc_size = 10;                 //Variable para reallocar, empieza siendo 30 y se duplica a medida que se lo necesite.
        grafo->vertices[i]->vecinos = calloc(realloc_size, sizeof(u32));
        u32 indice_vec = ObtenerIndiceDesdeNombre(vertices_n, grafo->n, array_lados[j].v2);
        grafo->vertices[i]->vecinos[nro_vec-1] = indice_vec;
        j++;

        //Agregamos el resto de los vecinos si los hay
        while (j<grafo->m*2 && array_lados[j].v1 == grafo->vertices[i]->nombre) {
            nro_vec++;
            if (nro_vec > realloc_size) {
                realloc_size *= 2;
                grafo->vertices[i]->vecinos = realloc(grafo->vertices[i]->vecinos, realloc_size*sizeof(u32));
            }
            indice_vec = ObtenerIndiceDesdeNombre(vertices_n, grafo->n, array_lados[j].v2);
            grafo->vertices[i]->vecinos[nro_vec-1] = indice_vec;
            j++; 
        }
        
        grafo->vertices[i]->grado = nro_vec;        //Asigno grado. 'nro_vec' lleva la cuenta de la cantidad existente de vecinos.

        //reallocamos para abajo, para eliminar posibles leaks, con el tamaño real del arreglo, i.e cantidad real de vecinos.
        grafo->vertices[i]->vecinos = realloc(grafo->vertices[i]->vecinos, nro_vec*sizeof(u32));
        
        //Calculamos el delta máximo
        if (grafo->vertices[i]->grado > max_delta) {
            max_delta = grafo->vertices[i]->grado;
        }
    }
    grafo->delta = max_delta;
}


/*FUNCIONES DEL TAD-API GRAFO*/

//Construcción/destrucción del grafo
Grafo ConstruirGrafo(FILE *stdin) {
    //Alocamos memoria e inicializamos el grafo 
    Grafo grafo = (Grafo) malloc(sizeof(GrafoSt));
    if (!grafo) {
        fprintf(stderr, "No se pudo asignar memoria para el grafo.\n");
        return NULL;
    }
    grafo->n = 0;
    grafo->m = 0;
    grafo->vertices = NULL;
    grafo->delta = 0;
    
    //Leemos las cero o más líneas que empiezan con 'c' y la línea 'p edge n m'
    char* buffer = malloc(BUFFER_SIZE * sizeof(char));
    if (buffer == NULL) {
        exit (1);
    }    
    while(1) {
        //Leemos una línea char por char. La guarda es while true pero sabemos que termina sí o sí.
        int index = 0; int new_size = 80;
        int j; 
        while ((j = getchar()) != EOF && j != '\n') {
            buffer[index] = j; 
            index++;
            if (index == BUFFER_SIZE - 2) {
                new_size = BUFFER_SIZE*2; 
                buffer = realloc(buffer, new_size * sizeof(char));
                if (buffer == NULL) {
                    exit (1);
                }
            }
        }
        buffer[index++] = '\n';
        buffer[index] = '\0';

        if (buffer[0] == 'c') {
            continue;
        }
            
        else if (sscanf(buffer, "p edge %u%*[ \t]%u%*[ \t]", &grafo->n, &grafo->m) != 2) {
            fprintf(stderr, "Formato incorrecto en la línea p edge n m\n");
            free(buffer);
            return NULL;
        }
        else{
            free(buffer);
            break;
        }
    }

    //Leemos los lados 'e v w' y los cargamos en un arreglo de tipo Lados *
    u32 max_lados = grafo->m;
    Lados *array_lados = lectura_lados(max_lados);
    if (array_lados==NULL) {
        free(grafo);
        return NULL; 
    }

    //Ordenamos array_lados según el primer elemento de la tupla de lados
    qsort(array_lados, max_lados*2, sizeof(struct Lados), cmpv1);

    //Arreglo con los n vértices del grafo (simplifica la búsqueda binaria del índice)
    u32 *vertices_n = calloc(grafo->n,sizeof(u32));
    u32 index_lado = 0;
    for (u32 vertice = 0; vertice < grafo->n; vertice++) {
        vertices_n[vertice] = array_lados[index_lado].v1;
        index_lado++;
        /*acá es muy importante para la última posición de array_lados, que la guarda index_lado < m*2 esté primero, 
        ya que si estaría segunda, daría segfault. Sabemos que C chequea guardas en orden, y en un &&, si la 
        primera no se cumple, ya la segunda guarda no se ejecuta (y tampoco queremos que se ejecute, pues
        estaríamos accediendo a array_lados[m*2], que se cae del arreglo). Pasa lo mismo para j más abajo a 
        la hora de cargar los datos en grafo->vertices[i]*/
        while (index_lado<grafo->m*2 && array_lados[index_lado].v1 == vertices_n[vertice]) {
            index_lado++;
        }
    }
    
    //Cargamos los datos de grafo->vertices en la estructura grafo
    u32 vertices_num = grafo->n;
    data_vertices(grafo, vertices_num, vertices_n, array_lados);

    //Liberamos memoria
    free(array_lados);
    free(vertices_n);
    
    return grafo;
}

void DestruirGrafo(Grafo G) {
    assert(G!=NULL);
    for (u32 i = 0; i < G->n; i++) {
        free(G->vertices[i]->vecinos);
        free(G->vertices[i]);
    }
    free(G->vertices);
    free(G);
    G=NULL; 
}

//Funciones para extraer datos del grafo
u32 NumeroDeVertices(Grafo G) {
    assert(G!=NULL);
    return G->n;
}

u32 NumeroDeLados(Grafo G) {
    assert(G!=NULL);
    return G->m;
}

u32 Delta(Grafo G) {
    assert(G!=NULL);
    return G->delta;
}


//Funciones de extracción de información de vértices 
u32 Nombre(u32 i,Grafo G) {
    assert(G!=NULL);
    return G->vertices[i]->nombre;
}

u32 Grado(u32 i,Grafo G) {
    if (i>=G->n) return 0xffffffffU;
    else return G->vertices[i]->grado;
}

u32 IndiceVecino(u32 j,u32 i,Grafo G) {
    if (i>=G->n || (i<G->n && j>=G->vertices[i]->grado)) return 0xffffffffU;
    else return G->vertices[i]->vecinos[j];
}
