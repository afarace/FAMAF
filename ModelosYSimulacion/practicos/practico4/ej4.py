import random
import time


def simulate(metodo, Nsim, *args, **kwargs):
    """
    Ejecuta Nsim simulaciones del metodo y devuelve el tiempo total en segundos.
    """
    if Nsim < 0:
        raise ValueError("Nsim debe ser no negativo")

    inicio = time.perf_counter()
    for _ in range(Nsim):
        metodo(*args, **kwargs)
    fin = time.perf_counter()

    return fin - inicio


# Ejercicio a)
def aceptacion_y_rechazo_a():
    """
    Método de rechazo con una uniforme discreta, buscando la cota c más baja posible.
    """
    # Valores y probabilidades de X
    X = [i for i in range(1, 11)]
    p = [0.11, 0.14, 0.09, 0.08, 0.12, 0.10, 0.09, 0.07, 0.11, 0.09]

    # Valores y probabilidades de X
    Y = [i for i in range(1, 11)]
    q = [1 / 10] * 10

    # Buscar el minimo c
    c = max(p[i] / q[i] for i in range(1, 10))

    while True:
        y = random.randint(1, 10)
        u = random.random()
        if u < p[y - 1] / c * q[y - 1]:
            return y


# Ejercicio b)
def aceptacion_y_rechazo():
    """
    Método de rechazo con una uniforme discreta, usando c = 3.
    """
    # Valores y probabilidades de X
    X = [i for i in range(1, 11)]
    p = [0.11, 0.14, 0.09, 0.08, 0.12, 0.10, 0.09, 0.07, 0.11, 0.09]

    # Valores y probabilidades de X
    Y = [i for i in range(1, 11)]
    q = [1 / 10] * 10

    c = 3

    while True:
        y = random.randint(1, 10)
        u = random.random()
        if u < p[y - 1] / c * q[y - 1]:
            return y


# Ejercicio c)
def transformada_inversa_i():
    """
    Transformada inversa
    """
    # Valores y probabilidades de X
    X = [i for i in range(1, 11)]
    p = [0.11, 0.14, 0.09, 0.08, 0.12, 0.10, 0.09, 0.07, 0.11, 0.09]

    # Calcular la función de distribución acumulada
    F = []
    acumulado = 0
    for prob in p:
        acumulado += prob
        F.append(acumulado)

    u = random.random()
    for i in range(len(F)):
        if u < F[i]:
            return X[i]


def transformada_inversa_ii():
    """
    Transformada inversa sin calcular la función de distribución acumulada, utilizando las probabilidades acumuladas directamente.
    X: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    p: [0.11, 0.14, 0.09, 0.08, 0.12, 0.10, 0.09, 0.07, 0.11, 0.09]
    """
    u = random.random()
    if u < 0.11:
        return 1
    elif u < 0.25:
        return 2
    elif u < 0.34:
        return 3
    elif u < 0.42:
        return 4
    elif u < 0.54:
        return 5
    elif u < 0.64:
        return 6
    elif u < 0.73:
        return 7
    elif u < 0.80:
        return 8
    elif u < 0.91:
        return 9
    else:
        return 10


def transformada_inversa_optimizada():
    """
    Transformada inversa optimizada, ordenando los valores de X de mayor a menor probabilidad para reducir el número de comparaciones.
    X: [2, 5, 1, 9, 6, 3, 7, 10, 4, 8]
    p: [0.14, 0.12, 0.11, 0.11, 0.10, 0.09, 0.09, 0.09, 0.08, 0.07 ]
    """
    u = random.random()
    if u < 0.14:
        return 2
    elif u < 0.26:
        return 5
    elif u < 0.37:
        return 1
    elif u < 0.48:
        return 9
    elif u < 0.58:
        return 6
    elif u < 0.67:
        return 3
    elif u < 0.76:
        return 7
    elif u < 0.85:
        return 10
    elif u < 0.93:
        return 4
    else:
        return 8


# Ejercicio c)
def urnaX():
    """
    Método de la urna: utilizar un arreglo A de tamaño 100 donde cada valor i está en exactamente pi ∗ 100
    posiciones.
    """
    # Valores y probabilidades de X
    X = [i for i in range(1, 11)]
    p = [0.11, 0.14, 0.09, 0.08, 0.12, 0.10, 0.09, 0.07, 0.11, 0.09]

    # Crear el arreglo A
    A = []
    for i in range(len(X)):
        A.extend([X[i]] * int(p[i] * 100))

    # Seleccionar un valor aleatorio de A
    return random.choice(A)


def main():
    """
    Ejecuta 1000 simulaciones de cada método y muestra el tiempo total en segundos.
    """
    Nsim = 1000

    tiempo_aceptacion_rechazo_a = simulate(aceptacion_y_rechazo_a, Nsim)
    print(
        f"Tiempo total para método de rechazo con c mínimo: {tiempo_aceptacion_rechazo_a:.4f} segundos"
    )

    tiempo_aceptacion_rechazo = simulate(aceptacion_y_rechazo, Nsim)
    print(
        f"Tiempo total para método de rechazo con c=3: {tiempo_aceptacion_rechazo:.4f} segundos"
    )

    tiempo_transformada_inversa_i = simulate(transformada_inversa_i, Nsim)
    print(
        f"Tiempo total para transformada inversa I: {tiempo_transformada_inversa_i:.4f} segundos"
    )

    tiempo_transformada_inversa_ii = simulate(transformada_inversa_ii, Nsim)
    print(
        f"Tiempo total para transformada inversa II: {tiempo_transformada_inversa_ii:.4f} segundos"
    )

    tiempo_transformada_inversa_optimizada = simulate(
        transformada_inversa_optimizada, Nsim
    )
    print(
        f"Tiempo total para transformada inversa optimizada: {tiempo_transformada_inversa_optimizada:.4f} segundos"
    )

    tiempo_urnaX = simulate(urnaX, Nsim)
    print(f"Tiempo total para método de la urna: {tiempo_urnaX:.4f} segundos")


if __name__ == "__main__":
    main()
