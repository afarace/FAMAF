#ifndef ESTRUCT_H
#define ESTRUCT_H

typedef unsigned int u32;

typedef struct s_vertice {
    u32 nombre;                //nombre del vértice
    u32 grado;                 //grado del vértice
    u32 *vecinos;              //lista de vecinos del vértice
} VerticeSt;

typedef struct GrafoSt {
    u32 n;                     //número de vértices
    u32 m;                     //número de lados
    VerticeSt **vertices;           //array de vértices 
    u32 delta;                 //mayor grado del grafo
} GrafoSt; 


#endif