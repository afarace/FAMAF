import random
import numpy as np
from time import time

def simulate(X,n_sim,ddof=0,**kwargs):
    """
    Parameters:
    -----------
    X : callable
        A function (or callable object) that generates a single simulated value when called with **kwargs.
    n_sim : int
        Number of simulations to run.
    ddof : int, optional (default=0)
        Delta degrees of freedom for variance and standard deviation calculations.
        If ddof=0 (default), computes population variance/std.
        If ddof=1, computes sample variance/std (unbiased estimator).
    **kwargs : dict
        Additional keyword arguments passed to the function X.

    Returns:
    --------
    s : ndarray
        Array of all simulated values (shape: (n_sim,)).
    mean_sim : float
        Mean of the simulated values.
    median_sim : float
        Median of the simulated values.
    var_sim : float
        Variance of the simulated values (with specified ddof).
    std_sim : float
        Standard deviation of the simulated values (with specified ddof).
    """
    s = np.empty(n_sim)
    for i in range(n_sim):
      s[i]=X(**kwargs)
    mean_sim = np.mean(s)
    median_sim = np.median(s)
    var_sim = np.var(s,ddof=ddof)
    std_sim = np.std(s,ddof=ddof)
    return s,mean_sim,median_sim,var_sim,std_sim

# a)

def calcN():
    s = set()
    lanzamientos = 0
    while len(s) != 11:
        x1 = random.randint(1, 6)
        x2 = random.randint(1, 6)
        s.add(x1 + x2)
        lanzamientos += 1
    return lanzamientos

# b)

for k in [int(x) for x in [1e2,1e3,1e4,1e5]]:
  initial_t = time()
  s,mean,_,_,std = simulate(calcN,
                            n_sim=k)
  print(f'| n_sim = {k}|')
  print(f'|tiempo = {round(time()-initial_t,5)}|')
  p_15 = np.sum(s >= 15)/k
  p_9 = np.sum(s <= 9)/k
  print(f'     media = {mean}')
  print(f'desviación = {std}')
  print(f'  P(N>=15) = {p_15}')
  print(f'   P(N<=9) = {p_9}')
  print('-----------------------------')
