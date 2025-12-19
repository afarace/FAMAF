#include <stdlib.h>
#include <assert.h>
#include "stack.h"

struct _s_stack
{
    unsigned int size;
    struct _s_node *fst;
};

struct _s_node
{
    stack_elem elem;
    struct _s_node *next;
};

stack stack_empty()
{
    stack s = malloc(sizeof(struct _s_stack));
    assert(s != NULL);
    s->size = 0;
    s->fst = NULL;
    return s;
}

stack stack_push(stack s, stack_elem e)
{
    struct _s_node *new_node = malloc(sizeof(struct _s_node));
    assert(new_node != NULL);
    new_node->elem = e;
    new_node->next = s->fst;
    s->fst = new_node;
    s->size++;
    return s;
}

stack stack_pop(stack s)
{
    assert(!stack_is_empty(s));
    struct _s_node *old_fst = s->fst;
    s->fst = old_fst->next;
    free(old_fst);
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
    return s->fst->elem;
}

bool stack_is_empty(stack s)
{
    return s->size == 0;
}

stack_elem *stack_to_array(stack s)
{
    unsigned int size = stack_size(s);
    stack_elem *array = malloc(size * sizeof(stack_elem));
    assert(array != NULL);
    struct _s_node *current = s->fst;
    for (unsigned int i = 0; i < size; i++)
    {
        array[size - 1 - i] = current->elem;
        current = current->next;
    }
    return array;
}

stack stack_destroy(stack s)
{
    struct _s_node *current = s->fst;
    while (current != NULL)
    {
        struct _s_node *next = current->next;
        free(current);
        current = next;
    }
    free(s);
    return NULL;
}