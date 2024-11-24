CC = gcc
CFLAGS = -Wall -Wextra -O3 -std=c99
#acordarse de agregar -DNDEBUG -fsanitize=address,undefined cuando se quieran usar las flags
all: main

main: main.o APIG23.o APIParte2.o
	$(CC) $(CFLAGS) -o main main.o APIG23.o APIParte2.o

main.o: main.c APIG23.h APIParte2.h
	$(CC) $(CFLAGS) -c main.c

APIG23.o: APIG23.c APIG23.h EstructuraGrafo23.h
	$(CC) $(CFLAGS) -c APIG23.c

APIParte2.o: APIParte2.c APIParte2.h APIG23.h EstructuraGrafo23.h
	$(CC) $(CFLAGS) -c APIParte2.c

clean:
	rm -f main main.o APIG23.o APIParte2.o