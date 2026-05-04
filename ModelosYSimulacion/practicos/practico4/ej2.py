from random import random
import numpy as np
import time

N = 10000


def suma_exacta():
    inicio = time.perf_counter()
    Suma = 0
    for i in range(1, N + 1, 1):
        Suma += np.exp(i / N)
    tiempo = time.perf_counter() - inicio
    print(f"Resultado: {Suma}, tiempo: {tiempo} s")


def suma_aprox(Nsim):
    inicio = time.perf_counter()
    Suma = 0
    for _ in range(Nsim):
        U = int(random() * N) + 1
        Suma += np.exp(U / N)
    tiempo = time.perf_counter() - inicio
    print(f"Resultado: {(Suma / Nsim) * N}, tiempo: {tiempo} s")


print(10 * "*" + " Ejercicio 2b) " + 10 * "*")
print("Valor exacto:")
suma_exacta()
print("\nValor aproximado:")
suma_aprox(100)
