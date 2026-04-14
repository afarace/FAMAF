import random


def ej2(Nsim):
    wins = 0
    for _ in range(Nsim):
        U = random.random()
        if U < 1 / 2:
            W_1 = random.random()
            W_2 = random.random()
            result = W_1 + W_2
            if result >= 1:
                wins += 1
        else:
            W_1 = random.random()
            W_2 = random.random()
            W_3 = random.random()
            result = W_1 + W_2 + W_3
            if result >= 1:
                wins += 1

    return wins / Nsim


print("*" * 10 + " ej 2b) " + "*" * 10)
simulaciones = [100, 1000, 10000, 100000, 1000000]
for i in simulaciones:
    print(f"Nsim = {i}, P(X >= 1) = {ej2(i)}")
