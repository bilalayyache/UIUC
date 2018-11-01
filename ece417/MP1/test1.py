import numpy as np

def norm(a):
    a2 = np.sum(a*a)**0.5
    a3 = np.sum(a*a*a)**(1/3)
    a5 = np.sum(a*a*a*a*a)**0.2
    a0 = max(a)
    return a2, a3, a5, a0

a = 7.6*7.6+5.6*5.6+0.81
print(np.sqrt(a))
