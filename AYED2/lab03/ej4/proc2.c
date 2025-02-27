#include <stdlib.h>
#include <stdio.h>

void absolute(int x, int *y)
{
    if (x < 0)
    {
        *y = -x;
    }
    else
    {
        *y = x;
    }
}

int main(void)
{
    int x = -5;
    int y = 0;
    absolute(x, &y);
    printf("El valor absoluto de %d es %d\n", x, y);
    return EXIT_SUCCESS;
}
