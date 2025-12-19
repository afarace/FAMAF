#include "strfuncs.h"
#include <stdlib.h>

size_t string_length(const char *str)
{
    size_t length = 0;
    while (str[length] != '\0')
    {
        length++;
    }
    return length;
}

char *string_filter(const char *str, char c)
{
    size_t len = string_length(str);
    char *filtered = malloc(len + 1);
    if (filtered == NULL)
    {
        return NULL;
    }

    size_t j = 0;
    for (size_t i = 0; i < len; i++)
    {
        if (str[i] != c)
        {
            filtered[j++] = str[i];
        }
    }
    filtered[j] = '\0';

    return filtered;
}