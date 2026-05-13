import random
from scipy.stats import binom
from time import time


# Ejercicio I
def transformada_inversa():
    """
    Transformada inversa que minimiza el número esperado de búsquedas.
    """
    u = random.random()
    if u < 0.35:
        return 3
    elif u < 0.55:
        return 1
    elif u < 0.75:
        return 4
    elif u < 0.9:
        return 0
    else:
        return 2


# Ejercicio II
def Binomial(n, p):
    c = p / (1 - p)
    prob = (1 - p) ** n
    F = prob
    i = 0
    U = random.random()
    while U >= F:
        prob *= c * (n - i) / (i + 1)
        F += prob
        i += 1
    return i


def aceptacion_y_rechazo():
    """
    Método de rechazo con una binomial B(4, 0.45)
    """
    # Valores y probabilidades de X
    X = [i for i in range(5)]
    p = [0.15, 0.20, 0.10, 0.35, 0.20]

    # Probabilidades de Y
    q = [binom.pmf(k, 4, 0.45) for k in range(5)]

    c = max(p[i] / q[i] for i in range(5))

    while True:
        y = Binomial(4, 0.45)
        u = random.random()
        if u < p[y] / c * q[y]:
            return y


# Ejercicio III
def simulate(X, n_sim):
    start = time()
    for _ in range(n_sim):
        X()
    return time() - start


def main():
    Nsim = 1000
    tiempo_transformada = simulate(transformada_inversa, Nsim)
    tiempo_rechazo = simulate(aceptacion_y_rechazo, Nsim)
    print(f"Tiempo total para transformada inversa: {tiempo_transformada:.5f} segundos")
    print(f"Tiempo total para método de rechazo: {tiempo_rechazo:.5f} segundos")


if __name__ == "__main__":
    main()
