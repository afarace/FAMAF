import random
import time
from math import comb


# Método I: Usando la transformada inversa
def BinomialI(n, p):
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


# Método II: Simulando n ensayos con probabilidad de éxito p y contando el número de éxitos.
def BinomialII(n, p):
    count = 0
    for _ in range(n):
        if random.random() < p:
            count += 1
    return count


def simulate(metodo, Nsim, *args, **kwargs):
    """
    Ejecuta Nsim simulaciones del metodo y devuelve (tiempo_total, lista_muestras).
    """
    muestras = [0] * Nsim
    inicio = time.perf_counter()
    for k in range(Nsim):
        muestras[k] = metodo(*args, **kwargs)
    fin = time.perf_counter()
    return fin - inicio, muestras


def binomial_teorica(n, p, k):
    """P(X = k) para X ~ Bin(n, p)."""
    return comb(n, k) * (p**k) * ((1 - p) ** (n - k))


def analizar(nombre, muestras, n, p):
    """
    Reporta:
      - valor con mayor ocurrencia (moda empírica) y su frecuencia.
      - proporción empírica de 0 y de n (=10).
      - comparación con las probabilidades teóricas.
    """
    Nsim = len(muestras)
    frec = [0] * (n + 1)
    for x in muestras:
        frec[x] += 1

    moda = max(range(n + 1), key=lambda k: frec[k])
    prop = [frec[k] / Nsim for k in range(n + 1)]
    teorica = [binomial_teorica(n, p, k) for k in range(n + 1)]

    print(f"\n--- Análisis de {nombre} (n={n}, p={p}, Nsim={Nsim}) ---")
    print(
        f"Moda empírica: X = {moda} con frecuencia {frec[moda]} "
        f"(proporción {prop[moda]:.4f}). Moda teórica: X = 3 "
        f"(P teórica = {teorica[3]:.4f})"
    )
    print(
        f"P(X=0) empírica  = {prop[0]:.5f}   |  P(X=0) teórica  = {teorica[0]:.5f}"
    )
    print(
        f"P(X=10) empírica = {prop[10]:.7f} |  P(X=10) teórica = {teorica[10]:.7f}"
    )

    print("Distribución completa empírica vs teórica:")
    print(f"{'k':>3} {'empírica':>12} {'teórica':>12} {'|diff|':>10}")
    for k in range(n + 1):
        print(
            f"{k:>3} {prop[k]:>12.5f} {teorica[k]:>12.5f} "
            f"{abs(prop[k] - teorica[k]):>10.5f}"
        )


def main():
    n, p = 10, 0.3
    Nsim = 10_000

    # Inciso 1: comparar eficiencia
    t1, m1 = simulate(BinomialI, Nsim, n, p)
    t2, m2 = simulate(BinomialII, Nsim, n, p)

    print("=== Inciso 1: Eficiencia (n=10, p=0.3, 10000 simulaciones) ===")
    print(f"Tiempo Método I  (transformada inversa): {t1:.4f} s")
    print(f"Tiempo Método II (n ensayos Bernoulli):  {t2:.4f} s")
    print(f"Razón t_II / t_I = {t2 / t1:.2f}")

    # Incisos 2 y 3: moda, P(0), P(10) y comparación con teóricas
    analizar("Método I",  m1, n, p)
    analizar("Método II", m2, n, p)


if __name__ == "__main__":
    main()
