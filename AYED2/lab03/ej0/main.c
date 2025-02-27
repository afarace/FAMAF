#include <stdlib.h>
#include <stdio.h>

#define MAX_SIZE 1000

unsigned int data_from_file(const char *path, unsigned int indexes[], char letters[], unsigned int max_size)
{
    FILE *file = fopen(path, "r");

    if (file == NULL)
    {
        printf("Error al abrir el archivo\n");
        exit(EXIT_FAILURE);
    }

    unsigned int length = 0;

    while (!feof(file))
    {
        int res = fscanf(file, "%u '%c'\n", &indexes[length], &letters[length]);
        if (res != 2)
        {
            printf("Error al leer el archivo\n");
            exit(EXIT_FAILURE);
        }
        length++;
        if (length >= max_size)
        {
            printf("Error: Se excedió la cantidad máxima de elementos\n");
            exit(EXIT_FAILURE);
        }
    }

    fclose(file);

    return length;
}

static void dump(char a[], unsigned int length)
{
    printf("\"");
    for (unsigned int j = 0u; j < length; j++)
    {
        printf("%c", a[j]);
    }
    printf("\"");
    printf("\n\n");
}

int main(int argc, char *argv[])
{
    unsigned int indexes[MAX_SIZE];
    char letters[MAX_SIZE];
    char sorted[MAX_SIZE];
    unsigned int length = 0;
    //  .----------^
    //  :
    // Debe guardarse aqui la cantidad de elementos leidos del archivo

    if (argc != 2)
    {
        printf("Error: Debe ingresar un archivo\n");
        exit(EXIT_FAILURE);
    }

    length = data_from_file(argv[1], indexes, letters, MAX_SIZE);

    for (unsigned int i = 0; i < length; i++)
    {
        sorted[indexes[i]] = letters[i];
    }

    dump(sorted, length);

    return EXIT_SUCCESS;
}
