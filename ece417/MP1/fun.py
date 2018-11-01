import numpy as np
from scipy.fftpack import fft, ifft

#####################################################################
# analysis part
#####################################################################

# this function change the signal length to num_sample_per_frame(200)
def change_signal(signal, num_sample_per_frame):
    if len(signal) == num_sample_per_frame:
        return signal
    else:
        retval = np.zeros((num_sample_per_frame,))
        for i in range(len(signal)):
            retval[i] = signal[i]
        return retval

def find_P(signal):
    L = len(signal)
    window = np.hamming(L)
    # calculate all PHI(P) and find the max value and the corresponding P
    PHI_P_list = [PHI(signal, window, P) for P in range(20, 91)]
    max_PHI_P = max(PHI_P_list)
    max_P = PHI_P_list.index(max_PHI_P) + 20
    return max_P

# in this function, we need to find the phi(m)
# where phi calculate the autocorrelation for the signal when applying a window
def autocorrelation(signal, window, m):
    L = len(signal)
    if m < -(L-1) or m > (L-1):
        return 0
    s_f_hat = signal * window * window
    s_f_hat_reverse = s_f_hat[-1::-1]
    autocorrelation = np.convolve(s_f_hat, s_f_hat_reverse)
    # sum = 0
    # for n in range(max(0, m), min(L, L+m)):
    #     sum += s_f_hat[n]*s_f_hat[n-m]
    # return sum
    return autocorrelation[m+L-1]

# in this function, we calculate the PHI(P) for given P
def PHI(signal, window, P):
    sum_P = 0
    L = len(signal)
    # find the range of k to calculate PHI
    k_th = int(L / P)
    for k in range(-k_th, k_th+1):
        sum_P += P * autocorrelation(signal, window, k*P)
    return sum_P

def Calc_Am(SIGNAL, EXCI, am, bm):
    numerator = 0.0
    denominator = 0.0
    for k in range(am, bm):
        numerator += SIGNAL[k] * np.conj(EXCI[k])
        denominator += np.abs(EXCI[k])**2
    return numerator / denominator

def Calc_error(SIGNAL, EXCI, Am, am, bm):
    sum = 0.0
    for k in range(am, bm):
        sum += np.abs(SIGNAL[k] - Am*EXCI[k])**2
    return sum / 2 / np.pi


# for the following part, we need to find the Am for each band in every frame
# input: signal: frame signal, P_0: pitch period, m: m_th band, N: fft points
# output: Am
def find_Am(signal, P_0, m, N=1024):
    L = len(signal)
    omega_0 = 2*np.pi / P_0
    window = np.hamming(L) * np.exp(1j*m*omega_0*np.arange(L))
    bin = 2*np.pi / N
    # to find Am, we need to compute the FFT of signal and window
    # we have two Am's need to consider. One for voiced and one for unvoiced
    SIGNAL = fft(signal*np.hamming(L), N)
    WINDOW = fft(window, N)
    NOISE = np.ones((N,))
    # numerator_voiced = SIGNAL * np.conj(WINDOW)
    # denominator_voiced = np.abs(WINDOW)**2
    # numerator_unvoiced = SIGNAL * NOISE
    # denominator_unvoiced = NOISE * NOISE
    # find am and bm, which are the lower and upper bound for summation
    am = int(np.ceil((m - 1/2) * omega_0 / bin))
    bm = int(np.ceil((m + 1/2) * omega_0 / bin))
    Am_voiced = Calc_Am(SIGNAL, WINDOW, am, bm)
    Am_unvoiced = Calc_Am(SIGNAL, NOISE, am, bm)
    # Am_unvoiced = sum(numerator_unvoiced[am:bm]) / sum(denominator_unvoiced[am:bm])

    # after finding the Am, we need to decide which has lower error
    error_voiced = Calc_error(SIGNAL, WINDOW, Am_voiced, am, bm)
    error_unvoiced = Calc_error(SIGNAL, NOISE, Am_unvoiced, am, bm)
    # return three valus: Am, min error, whether the frame is voiced
    is_voiced = error_voiced < error_unvoiced
    Am = Am_voiced if is_voiced else 0 #Am_unvoiced
    error = min(error_voiced, error_unvoiced)
    return Am, error, is_voiced

# def Error(SIGNAL, WINDOW, Am, am, bm):
#     error_m = SIGNAL - Am * WINDOW
#     error = np.abs(error_m)**2
#     return 0.5 / np.pi * sum(error[am:bm])

# now let's do the refine for P
# we need to return a refined P
def refine_P(signal, P_0):
    error_list = []
    p_array = np.arange(P_0-2.0, P_0+2.1, 0.2)
    min_error = np.float('inf')
    min_P = 0
    for p in p_array:
        # find Error for all the frame
        error = 0;
        for m in range(1, int(p)):
            Am, error_m, is_voiced = find_Am(signal, p, m)
            error += error_m
        # error_list.append(error)
        if error < min_error:
            min_P = p
            min_error = error
    # after finding all errors for different p
    # we need to find the p with the smallest error and return this p
    # error_min = min(error_list)
    # min_index = error_list.index(error_min)
    return min_P, min_error


#####################################################################
# synthesis part
#####################################################################

# def find_omega(P_array, K=80):
#     omega_0 = np.zeros((24000,))
#     for n in range(24000):
#         # frame number
#         f = int(np.floor(1.0*n/K))
#         if not f == 299:
#             omega_0[n] = (f+1-n/K)*2*np.pi/P_array[f]+(n/K-f)*2*np.pi/P_array[f+1]
#         else:
#             omega_0[n] = 2*np.pi/P_array[f]
#     return omega_0
#
#
# def find_theta(omega_0, m):
#     theta_m = np.zeros((24000,))
#     theta_m[0] = m * omega_0[0]
#     for n in range(1, 24000):
#         theta_m[n] = theta_m[n-1] + m * omega_0[n]
#     return theta_m
#
#
# def find_Am_voiced(Am_list, is_voiced_list, m, K=80):
#     Am_voiced = np.zeros((24000,))
#     for n in range(24000):
#         # frame number
#         f = int(np.floor(1.0*n/K))
#         # if f is the last frame
#         if f == 299:
#             if m < len(Am_list[f]):
#                 Am_voiced[n] = Am_list[f][m] if is_voiced_list[f][m] else 0
#             else:
#                 Am_voiced[n] = 0
#         else:
#             # discuss if A_mf is out of bound
#             A_mf = 0
#             A_mf1 = 0
#             if m < len(Am_list[f]):
#                 if is_voiced_list[f][m]:
#                     A_mf = Am_list[f][m]
#             if m < len(Am_list[f+1]):
#                 if is_voiced_list[f+1][m]:
#                     A_mf1 = Am_list[f+1][m]
#             Am_voiced[n] = (k+1-n/K)*A_mf + (n/K-f)*A_mf1
#     return Am_voiced
#
#
#
#
#
#
#
# def Error(SIGNAL, WINDOW, Am, am, bm):
#     error_m = SIGNAL - Am * WINDOW
#     error = np.abs(error_m)**2
#     return 0.5 / np.pi * sum(error[am:bm])
