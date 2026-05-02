from random import random
import numpy as np


def simulate(func):
    Nsims = [100, 1000, 10000, 100000, 1000000]
    for Nsim in Nsims:
        result = func(Nsim)
        print(f"Simulación con Nsim = {Nsim}: {result}")


# Ejercicio 5a


def g_1(u):
    return (1 - u**2) ** (1.5)


def ej5a(Nsim):
    integral = 0
    for i in range(Nsim):
        u = random()
        integral += g_1(u)
    return integral / Nsim


# Ejercicio 5b


def g_2(x):
    return x / (x**2 - 1)


def ej5b(Nsim):
    integral = 0
    for i in range(Nsim):
        x = random()
        integral += g_2(x + 2)
    return integral / Nsim


# Ejercicio 5c


def g_3(x):
    return x * (1 + x**2) ** (-2)


def ej5c(Nsim):
    integral = 0
    for _ in range(Nsim):
        u = random()
        integral += (1 / u**2) * g_3(1 / u - 1)
    return integral / Nsim


# Ejercicio 5d


def g_4(x):
    return np.exp(-(x**2))


def ej5d(Nsim):
    integral1 = 0
    integral2 = 0
    for _ in range(Nsim):
        U = random()
        integral1 += (1 / U**2) * g_4(1 - 1 / U)
        integral2 += (1 / U**2) * g_4(1 / U - 1)
    return (integral1 + integral2) / Nsim


# Ejercicio 5e


def g_5(x, y):
    return np.exp((x + y) ** 2)


def ej5e(Nsim):
    integral = 0
    for _ in range(Nsim):
        U_1 = random()
        U_2 = random()
        integral += g_5(U_1, U_2)
    return integral / Nsim


# Ejercicio 5f


def g_6(x, y):
    return np.exp(-((x + y)))


def ej5f(Nsim):
    integral = 0
    for _ in range(Nsim):
        U_1 = random()
        U_2 = random()
        integral += 1 / U_1**2 * (1 / U_1 - 1) * g_6(1 / U_1 - 1, U_2 / U_1 - U_2)
    return integral / Nsim


if __name__ == "__main__":
    print(10 * "*" + " ej 5a) " + 10 * "*")
    simulate(ej5a)
    print(10 * "*" + " ej 5b) " + 10 * "*")
    simulate(ej5b)
    print(10 * "*" + " ej 5c) " + 10 * "*")
    simulate(ej5c)
    print(10 * "*" + " ej 5d) " + 10 * "*")
    simulate(ej5d)
    print(10 * "*" + " ej 5e) " + 10 * "*")
    simulate(ej5e)
    print(10 * "*" + " ej 5f) " + 10 * "*")
    simulate(ej5f)
