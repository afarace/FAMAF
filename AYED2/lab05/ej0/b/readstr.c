#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LENGTH 20

int main(void)
{
    char *user_input = (char *)malloc(MAX_LENGTH * sizeof(char));

    printf("Ingrese su nombre y apellido: ");
    if (fgets(user_input, MAX_LENGTH, stdin) != NULL)
    {
        size_t len = strlen(user_input);
        if (len > 0 && user_input[len - 1] == '\n')
        {
            user_input[len - 1] = '\0';
        }
    }
    else
    {
        fprintf(stderr, "Error al leer la entrada.\n");
        free(user_input);
        return EXIT_FAILURE;
    }

    printf("Te damos la bienvenida %s a este maravilloso programa!\n", user_input);

    free(user_input);

    return EXIT_SUCCESS;
}
