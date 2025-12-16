#include <stdlib.h>
#include "pair.h"

pair_t pair_new(int x, int y) {
    pair_t new_pair = malloc(sizeof(struct s_pair_t));
    if (new_pair != NULL) {
        new_pair->fst = x;
        new_pair->snd = y;
    }
    return new_pair;
}

int pair_first(pair_t p) {
    return p->fst;
}

int pair_second(pair_t p) {
    return p->snd;
}

pair_t pair_swapped(pair_t p) {
    return pair_new(p->snd, p->fst);
}

pair_t pair_destroy(pair_t p) {
    free(p);
    return NULL;
}

// La implementacion logra encapsulamiento?
// Si, ya que el usuario no tiene acceso a la estructura interna de pair_t
// y solo puede interactuar con ella a traves de las funciones proporcionadas.