#include <stdbool.h>
#include <stdlib.h>
#include <assert.h>

#include "counter.h"

struct _counter {
    unsigned int count;
};

counter counter_init(void) {
    counter c = malloc(sizeof(struct _counter));
    if (c != NULL) {
        c->count = 0;
    }
    return c;
}

void counter_inc(counter c) {
    if (c != NULL) {
        c->count++;
    }
}

bool counter_is_init(counter c) {
    return c->count == 0;
}

void counter_dec(counter c) {
    assert(!counter_is_init(c));
    if (c != NULL) {
        c->count--;
    }
}

counter counter_copy(counter c) {
    if (c == NULL) {
        return NULL;
    }
    counter new_counter = malloc(sizeof(struct _counter));
    if (new_counter != NULL) {
        new_counter->count = c->count;
    }
    return new_counter;
}

void counter_destroy(counter c) {
    free(c);
}
