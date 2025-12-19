#include <stdlib.h>
#include <assert.h>
#include "stack.h"

struct _s_stack
{
    stack_elem *elems;     // Arreglo de elementos
    unsigned int size;     // Cantidad de elementos en la pila
    unsigned int capacity; // Capacidad actual del arreglo elems
};

stack stack_empty()
{
    stack s = malloc(sizeof(struct _s_stack));
    assert(s != NULL);
    s->elems = NULL;
    s->size = 0;
    s->capacity = 0;
    return s;
}

stack stack_push(stack s, stack_elem e)
{
    if (s->size == s->capacity)
    {
        unsigned int new_capacity = (s->capacity == 0) ? 1 : s->capacity * 2;
        stack_elem *new_elems = realloc(s->elems, new_capacity * sizeof(stack_elem));
        assert(new_elems != NULL);
        s->elems = new_elems;
        s->capacity = new_capacity;
    }
    s->elems[s->size] = e;
    s->size++;
    return s;
}

stack stack_pop(stack s)
{
    assert(!stack_is_empty(s));
    s->size--;
    return s;
}

unsigned int stack_size(stack s)
{
    return s->size;
}

stack_elem stack_top(stack s)
{
    assert(!stack_is_empty(s));
    return s->elems[s->size - 1];
}

bool stack_is_empty(stack s)
{
    return s->size == 0;
}

stack_elem *stack_to_array(stack s)
{
    stack_elem *array = malloc(s->size * sizeof(stack_elem));
    assert(array != NULL);
    for (unsigned int i = 0; i < s->size; i++)
    {
        array[i] = s->elems[i];
    }
    return array;
}

stack stack_destroy(stack s)
{
    free(s->elems);
    free(s);
    return NULL;
}