#include <stdio.h>
#include <stdlib.h>
#include "array_helpers.h"

unsigned int array_from_file(int array[],
                             unsigned int max_size,
                             const char *filepath)
{

    FILE *file = fopen(filepath, "r");
    if (file == NULL)
    {
        fprintf(stderr, "Error: file %s not found\n", filepath);
        exit(EXIT_FAILURE);
    }

    unsigned int length = 0;
    fscanf(file, "%u", &length);

    if (length > max_size)
    {
        fprintf(stderr, "Error: array length %u exceeds max size %u\n",
                length, max_size);
        exit(EXIT_FAILURE);
    }

    for (unsigned int i = 0; i < length; i++)
    {
        fscanf(file, "%d", &array[i]);
    }

    fclose(file);

    return length;
}

void array_dump(int a[], unsigned int length)
{
    for (unsigned int i = 0; i < length; i++)
    {
        printf("%d ", a[i]);
    }
    printf("\n");
}

mybool array_is_sorted(int a[], unsigned int length)
{
    mybool result = true;
    for (unsigned int i = 0; i < length - 1; i++)
    {
        if (a[i] > a[i + 1])
        {
            result = false;
            break;
        }
    }
    return result;
}