import numpy as np
import matplotlib.pyplot as plt
import scipy
from scipy.io.wavfile import read, write
from scipy.fftpack import fft, ifft
import fun

Fs, signal = scipy.io.wavfile.read('s5.wav')
# change signal to floating point numbers
# signal = signal / 32768.0
total_time = len(signal)/Fs

# enter the parameter for this problem
T_skip = 0.01
T_frame = 0.025
# total number of frames (300)
num_frame = int(total_time / T_skip)
# numbers of samples per frame (200)
num_sample_per_frame = int(T_frame * Fs)
# numbers of samples between two frames (80)
num_skip = int(T_skip * Fs)

# now to calculate P for every frame
P_list = []
error_list = []
Am_list = []
# refine P value
refined_P_list = []
frame_index = np.arange(0, num_frame)
for frame in range(num_frame):
    frame_signal = signal[frame*num_skip : min(len(signal), frame*num_skip+num_sample_per_frame)]
    # frame_signal = fun.change_signal(frame_signal, num_sample_per_frame)
    P_0 = fun.find_P(frame_signal)
    P_list.append(P_0)
    refined_P_0, error = fun.refine_P(frame_signal, P_0)
    refined_P_list.append(refined_P_0)
    error_list.append(error)


P_array = np.array(P_list)
refined_P_array = np.array(refined_P_list)
error_array = np.array(error_list)
# # for debug, we only look at the first frame
# frame_signal = signal[0:200]
# P_0 = fun.find_P(frame_signal)
# refined_P_0, error = fun.refine_P(frame_signal, P_0)
# print(P_0, refined_P_0)
# print(refined_P_array)

# # Am_array = np.array(Am_list)
# # Am_index = np.arange(len(Am_array))
# # draw the P vs frame_number
# plt.plot(frame_index, refined_P_array, 'r-')
# plt.xlabel('frame number')
# plt.ylabel('refined P for each frame')
# plt.title('refined pitch period')
# plt.show()
#
# plt.plot(frame_index, error_array, 'b-')
# plt.xlabel('frame number')
# plt.ylabel('error for each frame')
# plt.title('error for each frame')
# plt.show()




# after finding refined P, we need to find the Am and is_voiced choice
Am_list = []
is_voiced_list = []
for frame in range(num_frame):
    Am_sublist = [0]
    is_voiced_sublist = [True]
    frame_signal = signal[frame*num_skip : min(len(signal), frame*num_skip+num_sample_per_frame)]
    # frame_signal = fun.change_signal(frame_signal, num_sample_per_frame)
    P_0 = refined_P_array[frame]
    for m in range(1, int(P_0)):
        Am, error, is_voiced = fun.find_Am(frame_signal, P_0, m)
        Am_sublist.append(Am)
        is_voiced_sublist.append(is_voiced)
    Am_list.append(Am_sublist)
    is_voiced_list.append(is_voiced_sublist)


# after finding Am and is_voiced decision, we can do the voiced synthesis part
s_voiced = np.zeros((24000,), dtype=np.complex64)
K = 80
num_m = int(max(refined_P_array))
theta_mn = np.zeros((num_m, 24000))

for n in range(24000):
    frame = int(n/K)
    if frame == num_frame-1:
        omega_0_n = 2*np.pi/refined_P_array[frame]
    else:
        omega_0_n = (frame+1-n/K)*2*np.pi/refined_P_array[frame] + (n/K-frame)*2*np.pi/refined_P_array[frame+1]
    for m in range(1, int(refined_P_array[frame])):
        if n == 0:
            theta_mn[m][n] = m*omega_0_n
        else:
            theta_mn[m][n] = theta_mn[m][n-1] + m*omega_0_n
        # find Am
        A_mn = 0
        if frame == 299:
            if m < len(Am_list[frame]):
                A_mn = Am_list[frame][m] # if is_voiced_list[frame][m] else 0
            else:
                A_mn = 0
        else:
            # discuss if A_mf is out of bound
            A_mf = 0.0
            A_mf1 = 0.0
            if m < len(Am_list[frame]):
                # if is_voiced_list[frame][m]:
                A_mf = Am_list[frame][m]
            if m < len(Am_list[frame+1]):
                # if is_voiced_list[frame+1][m]:
                A_mf1 = Am_list[frame+1][m]
            A_mn = (frame+1-n/K)*A_mf + (n/K-frame)*A_mf1
        s_voiced[n] += A_mn * np.cos(theta_mn[m][n])



# for frame in range(num_frame):
#     for n in range(frame*K, (frame+1)*K):
#         omega_0_n = 0
#         if frame == num_frame-1:
#             omega_0_n = 2*np.pi/refined_P_array[frame]
#         else:
#             omega_0_n = (frame+1-n/K)*2*np.pi/refined_P_array[frame] + (n/K-frame)*2*np.pi/refined_P_array[frame+1]
#         for m in range(1, int(refined_P_array[frame])):
#             if frame = 0 and n = 0:
#                 theta_prev = 0
#             A_mn = 0
#             if frame == 299:
#                 if m < len(Am_list[frame]):
#                     A_mn = Am_list[frame][m] # if is_voiced_list[frame][m] else 0
#                 else:
#                     A_mn = 0
#             else:
#                 # discuss if A_mf is out of bound
#                 A_mf = 0.0
#                 A_mf1 = 0.0
#                 if m < len(Am_list[frame]):
#                     # if is_voiced_list[frame][m]:
#                     A_mf = Am_list[frame][m]
#                 if m < len(Am_list[frame+1]):
#                     # if is_voiced_list[frame+1][m]:
#                     A_mf1 = Am_list[frame+1][m]
#                 A_mn = (frame+1-n/K)*A_mf + (n/K-frame)*A_mf1
#             theta_n = theta_prev + m * omega_0_n
#             theta_prev = theta_n
#             s_voiced[n] += A_mn * np.cos(theta_n)

s_voiced = np.real(s_voiced)
# s_voiced = (s_voiced * np.power(2,15)).astype(np.int16)
scipy.io.wavfile.write('s_voiced.wav', Fs, s_voiced)

# for unvoiced band:
s_unvoiced = np.zeros((24000,), dtype=np.complex64)
u_f_list = []
for frame in range(num_frame):
    frame_signal = signal[frame*num_skip : min(len(signal), frame*num_skip+num_sample_per_frame)]
    frame_signal = fun.change_signal(frame_signal, num_sample_per_frame)
    SIGNAL = fft(frame_signal, 1024)
    bin = 2*np.pi / 1024
    omega_0 = 2*np.pi / refined_P_array[frame]
    U_f = np.zeros((1024,), dtype=np.complex64)
    for m in range(1, int(refined_P_array[frame])):
        if not is_voiced_list[frame][m]:
            am = int(np.ceil((m - 1/2) * omega_0 / bin))
            bm = int(np.ceil((m + 1/2) * omega_0 / bin))
            S_temp = np.abs(SIGNAL)**2
            var = np.sum(S_temp[am:bm]) / (bm-am)
            real = np.random.normal(0, np.sqrt(0.5*var), (bm-am))
            imag = np.random.normal(0, np.sqrt(0.5*var), (bm-am))
            U_f[am:bm] = real + 1j*imag
            # for i in range(am, bm):
            #     U_f[i] = np.random.normal(0, np.sqrt(0.5*var)) + 1j*np.random.normal(0, np.sqrt(0.5*var))
    u_f = ifft(U_f, n=80)
    u_f_list.append(u_f)

# calculate s_unvoiced
for frame in range(num_frame):
    if frame == 299:
        s_unvoiced[n] = u_f_list[frame][n-frame*K]
    else:
        for n in range(frame*K, (frame+1)*K):
            s_unvoiced[n] = (frame+1-n/K)*u_f_list[frame][n-frame*K] + (n/K-frame)*u_f_list[frame+1][n-frame*K]

s_unvoiced = np.real(s_unvoiced)
# s_unvoiced = (s_unvoiced * np.power(2,15)).astype(np.int16)

s = s_voiced + s_unvoiced
scipy.io.wavfile.write('s_synthesis.wav', Fs, s)








#
