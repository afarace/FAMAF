#include <stdlib.h>
#include <assert.h>
#include "stack.h"

struct _s_stack
{
    stack_elem elem;
    struct _s_stack *next;
};

stack stack_empty()
{
    stack s = NULL;
    return s;
}

stack stack_push(stack s, stack_elem e)
{
    stack new_stack = malloc(sizeof(struct _s_stack));
    assert(new_stack != NULL);
    new_stack->elem = e;
    new_stack->next = s;
    return new_stack;
}

stack stack_pop(stack s)
{
    assert(!stack_is_empty(s));
    stack next_stack = s->next;
    free(s);
    return next_stack;
}

unsigned int stack_size(stack s)
{
    unsigned int size = 0;
    while (s != NULL)
    {
        size++;
        s = s->next;
    }
    return size;
}

stack_elem stack_top(stack s)
{
    assert(!stack_is_empty(s));
    return s->elem;
}

bool stack_is_empty(stack s)
{
    return s == NULL;
}

stack_elem *stack_to_array(stack s)
{
    unsigned int size = stack_size(s);
    stack_elem *array = malloc(size * sizeof(stack_elem));
    assert(array != NULL);
    for (unsigned int i = size; i > 0; i--)
    {
        array[i - 1] = s->elem;
        s = s->next;
    }
    return array;
}

stack stack_destroy(stack s)
{
    while (!stack_is_empty(s))
    {
        s = stack_pop(s);
    }
    return s;
}