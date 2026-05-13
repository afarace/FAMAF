import random
from math import exp


def Poisson(lamda):
    U = random.random()
    i = 0
    p = exp(-lamda)
    F = p
    while U >= F:
        i += 1
        p *= lamda / i
        F += p
    return i


def Poisson_mejorado(lamda):
    p = exp(-lamda)
    F = p
    for j in range(1, int(lamda) + 1):
        p *= lamda / j
        F += p
    U = random.random()
    if U >= F:
        j = int(lamda) + 1
        while U >= F:
            p *= lamda / j
            F += p
            j += 1
        return j - 1
    else:
        j = int(lamda)
        while U < F:
            F -= p
            p *= j / lamda
            j -= 1
        return j + 1


def est_P(X, lamda, k, Nsim):
    # P (Y > k)
    suma = 0
    for _ in range(Nsim):
        res = X(lamda)
        if res > k:
            suma += 1
    return suma / Nsim


def est_P_2(X, lamda, k, Nsim):
    # P (Y <= k)
    suma = 0
    for _ in range(Nsim):
        res = X(lamda)
        if res <= k:
            suma += 1
    return suma / Nsim


def main():
    """
    Simular P(Y > k) y P(Y <= k) para Y ~ Poisson(lamda) utilizando ambos métodos de simulación (Poisson y Poisson_mejorado) y comparar los resultados.
     - lamda = 10
     - k = 2
     - Nsim = 1000
    """
    Nsim = 1000
    lamda = 10
    k = 2
    print(f"Estimación de P(Y > {k}) con {Nsim} simulaciones:")
    p1 = est_P(Poisson, lamda, k, Nsim)
    p2 = est_P(Poisson_mejorado, lamda, k, Nsim)
    print(f"  Método Poisson: P(Y > {k}) ≈ {p1:.4f}")
    print(f"  Método Poisson mejorado: P(Y > {k}) ≈ {p2:.4f}")
    print(f"\nEstimación de P(Y <= {k}) con {Nsim} simulaciones:")
    p3 = est_P_2(Poisson, lamda, k, Nsim)
    p4 = est_P_2(Poisson_mejorado, lamda, k, Nsim)
    print(f"  Método Poisson: P(Y <= {k}) ≈ {p3:.4f}")
    print(f"  Método Poisson mejorado: P(Y <= {k}) ≈ {p4:.4f}")


if __name__ == "__main__":
    main()
