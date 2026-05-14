from math import log
from random import random


def geom_inversa(p):
    """
    Transformada inversa de Geom(p): F(i) = 1 - (1-p)^i.
    """
    U = random()
    return int(log(1 - U) / log(1 - p)) + 1


def generar_X():
    """
    Método de composición.

    P(X = j) = (1/2)^(j+1) + (1/2) * 2^(j-1) / 3^j
            = (1/2) * (1/2)^j + (1/2) * (1/3) * (2/3)^(j-1)

    es decir, X es mezcla equiprobable de Y1 ~ Geom(1/2) e Y2 ~ Geom(1/3).
    """
    if random() < 0.5:
        return geom_inversa(0.5)
    return geom_inversa(1 / 3)


def main():
    """
    Estima E(X) con 1000 repeticiones y la compara con la esperanza exacta
    E(X) = (1/2) * (1/(1/2)) + (1/2) * (1/(1/3)) = 1 + 3/2 = 5/2.
    """
    Nsim = 1000
    esperanza_exacta = 0.5 * 2 + 0.5 * 3
    promedio = sum(generar_X() for _ in range(Nsim)) / Nsim
    print(f"Nsim = {Nsim}")
    print(f"E(X) estimado = {promedio:.4f}")
    print(f"E(X) exacto   = {esperanza_exacta}")
    print(f"Error abs.    = {abs(promedio - esperanza_exacta):.4f}")


if __name__ == "__main__":
    main()

# from numpy.random import uniform

# p = lambda i: (0.5)**(i+1) + 0.5 * 2**(i-1) / 3**i

# def transInv():
#     F, i, U = p(1), 1, uniform()
#     while U >= F:
#         i += 1
#         F += p(i)
#     return i

# print("*"*10 + " 10 " + "*"*10)
# print(f"\nE(X) ~ {sum(transInv() for _ in range(1000))/1000}")
# print(f"E(X) = {sum([i * p(i) for i in range(200)])}")