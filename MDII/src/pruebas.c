//printeo arraylados
printf("\narray_lados = [");
for (u32 i = 0; i < grafo->m*2; i++) {
    printf("(%u, %u), ", array_lados[i].v1, array_lados[i].v2);
}
printf("]\n");

for (u32 i = 0; i < grafo->n; i++) {
    u32 indice = ObtenerIndiceDesdeNombre(vertices_n, grafo->n, grafo->vertices[i]->nombre);
    printf("Indice de vertice %u = %u\n", grafo->vertices[i]->nombre, indice);
}

printf("Grado vertice %u = %u\n", grafo->vertices[i]->nombre, grafo->vertices[i]->grado);

printf("\nvecinos = [");
for (u32 i = 0; i < grafo->n; i++) {
    for(u32 j = 0; j < grafo->vertices[i]->grado; j++){
        printf("(%u, %u), ", grafo->vertices[i]->nombre, grafo->vertices[i]->vecinos[j]);
    }
}

printf("]\n");
printf("Delta = %u\nN=%u\nM=%u\n", Delta(g), NumeroDeVertices(g), NumeroDeLados(g));
        //printf("Nombre vertice 0 = %u, Grado vertice 0 = %u, Vecino 1-esimo de 0 = %u\n", Nombre(0,g), Grado(0,g), Nombre(IndiceVecino(1,0,g),g));