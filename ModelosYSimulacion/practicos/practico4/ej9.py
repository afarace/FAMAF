from math import log
from random import random
from time import time


def geom_inversa(p):
    """
    Transformada inversa de Geom(p): F(i) = 1 - (1-p)^i.
    """
    U = random()
    return int(log(1 - U) / log(1 - p)) + 1


def geom_recursiva(p):
    """
    Transformada inversa acumulando la CDF con la fórmula recursiva
    P(X = i+1) = (1-p) * P(X = i), partiendo de P(X = 1) = p.
    """
    U = random()
    i = 1
    prob = p
    F = prob
    while U >= F:
        i += 1
        prob *= (1 - p)
        F += prob
    return i


def geom_ensayos(p):
    """
    Ensayos Bernoulli(p) hasta obtener el primer éxito.
    """
    i = 1
    while random() >= p:
        i += 1
    return i


def simular(metodo, p, n_sim):
    start = time()
    total = 0
    for _ in range(n_sim):
        total += metodo(p)
    elapsed = time() - start
    return total / n_sim, elapsed


def main():
    """
    Compara los tres métodos de simulación de Geom(p) para p = 0.8 y p = 0.2,
    estimando el promedio con 10000 simulaciones y midiendo el tiempo.
    """
    Nsim = 10000
    for p in (0.8, 0.2):
        esperado = 1 / p
        prom_inv, tiempo_inv = simular(geom_inversa, p, Nsim)
        prom_rec, tiempo_rec = simular(geom_recursiva, p, Nsim)
        prom_ens, tiempo_ens = simular(geom_ensayos, p, Nsim)
        print(f"p = {p} | E[X] = 1/p = {esperado}")
        print(f"  T. Inversa (cerrada):   promedio = {prom_inv:.4f} | tiempo = {tiempo_inv:.5f} s")
        print(f"  Fórmula recursiva:      promedio = {prom_rec:.4f} | tiempo = {tiempo_rec:.5f} s")
        print(f"  Ensayos hasta éxito:    promedio = {prom_ens:.4f} | tiempo = {tiempo_ens:.5f} s")
        print("-" * 70)


if __name__ == "__main__":
    main()
