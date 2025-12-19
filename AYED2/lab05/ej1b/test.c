#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "stack.h"

void test_stack_empty()
{
    stack s = stack_empty();
    assert(stack_is_empty(s));
    printf("✓ test_stack_empty passed\n");
}

void test_stack_push_pop()
{
    stack s = stack_empty();
    s = stack_push(s, 10);
    assert(!stack_is_empty(s));
    assert(stack_top(s) == 10);
    s = stack_pop(s);
    assert(stack_is_empty(s));
    printf("✓ test_stack_push_pop passed\n");
}

void test_stack_size()
{
    stack s = stack_empty();
    assert(stack_size(s) == 0);
    s = stack_push(s, 1);
    assert(stack_size(s) == 1);
    s = stack_push(s, 2);
    s = stack_push(s, 3);
    assert(stack_size(s) == 3);
    s = stack_destroy(s);
    printf("✓ test_stack_size passed\n");
}

void test_stack_to_array()
{
    stack s = stack_empty();
    s = stack_push(s, 30);
    s = stack_push(s, 20);
    s = stack_push(s, 10);
    stack_elem *arr = stack_to_array(s);
    assert(arr[0] == 30);
    assert(arr[1] == 20);
    assert(arr[2] == 10);
    free(arr);
    s = stack_destroy(s);
    printf("✓ test_stack_to_array passed\n");
}

void test_stack_lifo()
{
    stack s = stack_empty();
    s = stack_push(s, 5);
    s = stack_push(s, 15);
    assert(stack_top(s) == 15);
    s = stack_pop(s);
    assert(stack_top(s) == 5);
    s = stack_destroy(s);
    printf("✓ test_stack_lifo passed\n");
}

int main(void)
{
    test_stack_empty();
    test_stack_push_pop();
    test_stack_size();
    test_stack_to_array();
    test_stack_lifo();
    printf("\nAll tests passed!\n");
    return EXIT_SUCCESS;
}