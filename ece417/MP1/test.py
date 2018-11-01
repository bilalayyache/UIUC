import numpy as np
import numpy.fft as fft_com
import scipy as sc
import scipy.io.wavfile as wave
import matplotlib.pyplot as plt

# Autocorrelation function defined in paper. Returns phi(m)
# Input Signal : f
# Shift : m
def autocorrelation(f, m):
    # If the shift is beyond the lenght of the signal then 0
    if abs(m) >= len(f):
        return 0
    f_m = np.roll(f, m)
    if m >= 0:
        f_m[0:m] = 0
    else:
        f_m[len(f) + m:] = 0
    phi = f * f_m
    return np.sum(phi)

# Get pitch estimate
# Input Signal:f
# Range of pitches to test: pitch_range
def pitch_estimate(f, pitch_range):
    maximum = -1
    for P in range(pitch_range[0], pitch_range[1] + 1):
        summation = 0
        # Create range of k values to iterate over
        if P == 0:
            lim = [0]
        else:
            lim = range(-1*int(len(f)/P), int(len(f)/P) + 1)
        for k in lim:
            summation += autocorrelation(f, k*P)
        summation *= P
        if summation > maximum:
            maximum = summation
            P_estimate = P

    return P_estimate

# Calculates the exictation spectrum for voiced signal
# h_len: Length of hamming window
# mw: Shift of mw_0
# N: Number of points in the FFT
def E_voiced(h_len, mw, N):
    window = np.hamming(h_len) * np.exp(1j * mw * np.arange(0, h_len))
    E = np.fft.fft(window, N)
    f = np.arange(0, N) / N * 2 * np.pi

    return [E, f]

# Calculates the exicitation spectrum for the unvoiced signal
# h_len: Length of hamming window
# N: Number of points in the FFT
def E_unvoiced(h_len, N):
    E = np.ones((N, ))
    f = np.arange(0, N) / N * 2 * np.pi

    return [E, f]

# Given am and bm calculates the different frequency bands in this range
# for a given pitch P_0
def frequency_bands(P_0):
    bands=[]
    w_0 = 2 * np.pi / P_0
    for m in range(1, int(2 * np.pi / w_0)):
        bands.append(((m - 0.5)*w_0, (m + 0.5)*w_0))
    return bands

# Given am, bm and the number of points in the FFT, the function finds all
# FFT indices that fall in the range (am, bm)
# band = [am , bm]
# Number of points in the FFT: N
def get_indices(band, N):
    am = band[0]
    bm = band[1]

    lower_index = int(np.ceil(am * N / 2 / np.pi))
    upper_index = int(np.floor(bm * N / 2 / np.pi))

    return [lower_index, upper_index]

# Calculates the envelope amplitudes for the given windowed signal Sw
# and excitation spectrum E in the band (am, bm)
# Windowed signal FFT: Sw
# Excitation Spectrum: E
# band = (am, bm)
def Am_calc(Sw, E, band):
    den = 0.0
    num = 0.0

    N = len(Sw)

    [lower_index, upper_index] = get_indices(band, N)

    for i in range(lower_index, upper_index + 1):
        den += np.abs(E[i])**2
        num += (Sw[i] * np.conj(E[i]))

    return num / den

# Calculates the error for given speech signal
# Windowed signal FFT: Sw
# Excitation Spectrum: E
# band = (am, bm)
def epsilon(Sw, E, band):
    Am = Am_calc(Sw, E, band)

    N = len(Sw)

    [lower_index, upper_index] = get_indices(band, N)

    error = 0.0

    for i in range(lower_index, upper_index + 1):
        error += np.abs(Sw[i] - Am * E[i])**2

    return (1 / 2 / np.pi) * error

# Make voiced/unvoiced decisions for the whole bands based on the majority rule
# frame_decision: data of decisions for individual harmonics in each frame
def adjust_deci(frame_decision):
    for i in range(len(frame_decision)):
        vv = 0; uu = 0;
        for j in range(len(frame_decision[i])):
            if(frame_decision[i][j] == 1):
                vv = vv + 1;
            else:
                uu = uu + 1;

        if(vv>=uu):
            frame_decision[i] = np.ones(vv+uu);
        else:
            frame_decision[i] = np.zeros(vv+uu);

    return frame_decision;

# Extract frames from original signals and estimate the spectral envelope parameters
# input_filename: the name of the file that contains the sound track
# T_skip: the time between consecutive frame starts
# T_frame: the length of one frame
# noise_var: the variance of Guassian noise that is to be added to original signals
# pitch_range: the smallest and largest possible pitch period values
# N: the length of FFT sequences
# V_UV: The flag to indicate how we're going to make voiced/unvoiced decisions about each harmonics

def Analysis(input_filename, T_skip, T_frame, noise_var, pitch_range, N, V_UV):

    [sample_rate, sample_data] = wave.read(input_filename);

    total = len(sample_data);
    window_dur = int(sample_rate * T_frame);
    window_gap = int(sample_rate * T_skip);

    if(total % window_gap == 0):
        window_num = int(total / window_gap);
    else:
        window_num = int(total / window_gap) + 1;

    sample_data = sample_data + np.random.normal(0, noise_var, (total, ))
    mean = sum(sample_data) / len(sample_data)
    scale = sum(sample_data * sample_data)
    sample_data = (sample_data - mean) / scale

    frame_FFT = [];
    rough_estimate = [];
    en_para = [];
    decision = [];
    en_para_best = [];
    decision_best = [];
    min_error = -1.0;
    P_curr = 0;
    fund_f = 0;
    P_up = 0;
    frame_decision = [];
    frame_estimate = [];
    frame_error = [];
    pitch = [];

    window = np.hamming(T_frame * sample_rate);

    for i in range(window_num):
    #Get the data in each frame
        end = min(i * window_gap + window_dur, total);
        frame = np.zeros(window_dur);
        frame[0 : end - i * window_gap] = sample_data[i * window_gap: end];

    #Compute and store FFT of each frame
        frame = np.multiply(frame, window);
        FFT = fft_com.fft(frame, N);
        frame_FFT.append(FFT);

    #Compute and store pitch period estimate of each frame
        frame = np.multiply(frame, window);
        es = pitch_estimate(frame, pitch_range);
        rough_estimate.append(es);

    #Compute estimated spectral envelope parameters and errors
    for i in range(window_num):

        min_error = -1.0;
        P_curr = rough_estimate[i];

        P_curr = P_curr - 2;
        for j in range(21):
            total_error = 0.0;
            en_para = [];
            decision = [];

            if(P_curr <= 0):
                P_curr = P_curr + 0.2;
                continue;

            fund_f = 2*np.pi / P_curr;
            P_up = (int(P_curr));
            total_error = 0.0;

    #Try out different P values centered around estimate pitch with a step of 0.2
            for t in range(1,P_up):
                [E_v, f] = E_voiced(window_dur, t * fund_f, N);
                Amv = Am_calc(frame_FFT[i], E_v, [(t - 0.5) * fund_f,(t + 0.5) * fund_f]);
                error_v = epsilon(frame_FFT[i], E_v, [(t-0.5)*fund_f,(t+0.5)*fund_f]);
                [E_u, f] = E_unvoiced(window_dur, N);
                Amu = Am_calc(frame_FFT[i], E_u, [(t-0.5)*fund_f,(t+0.5)*fund_f]);
                error_u = epsilon(frame_FFT[i], E_u, [(t-0.5)*fund_f,(t+0.5)*fund_f]);

                if(error_v<error_u):
                    en_para.append(Amv);
                    decision.append(1);
                    total_error = total_error + error_v;
                else:
                    en_para.append(Amu);
                    decision.append(0);
                    total_error = total_error + error_u;

            if(min_error < 0 or total_error < min_error):
                min_error = total_error;
                en_para_best = en_para;
                decision_best = decision;
                P_best = P_curr;

            P_curr = P_curr + 0.2;

#Store the data from best pitch values of each frame for later use
        pitch.append(P_best);
        frame_decision.append(decision_best);
        frame_estimate.append(en_para_best);
        frame_error.append(min_error);

    if(V_UV==0):
        frame_decision = adjust_deci(frame_decision);

    frame_info = [frame_FFT, pitch, frame_decision, frame_estimate, N, frame_error]
    window_info = [window_dur, window_gap, window_num]

    stats = [scale, mean]

    return [frame_info, window_info, total, stats]

# Synthesized voiced parts of signals
# frame_info: contains FFTs, voiced/unvoiced decisions and optimal pitch values for all frames
# window_info: contains the length of windows, gaps between windows and total number of windows
# total: the amount of sample points in the result
def Voice_Synthesis(frame_info, window_info, total):

    # Set up previous data
    frame_FFT = frame_info[0]
    pitch = frame_info[1]
    frame_decision = frame_info[2]
    frame_estimate = frame_info[3]
    N = frame_info[4]

    window_dur = window_info[0]
    window_gap = window_info[1]
    window_num = window_info[2]

    K = window_gap
    frame  = 0
    Am_f = frame_estimate[frame]
    theta_previous = []
    svv = np.zeros((total,)) + 1j * np.zeros((total, ))

    for n in range(0, total , K):
        number_bands_f = len(frequency_bands(pitch[frame]))

    # Get the pitch periods of the two neighboring frames
        if frame != window_num - 1:
            number_bands_f1 = len(frequency_bands(pitch[frame + 1]))
            Am_f1 = frame_estimate[frame+1]
        else:
            number_bands_f1 = 0

        for i in range(0, K):

            if(n + i >= total):
                break;

    # Generate the omega_0 parameter
            if frame != window_num - 1:
                omega = (frame + 1 - (n + i) / K) * (2 * np.pi / pitch[frame]) + ((n + i) / K - frame) * (2 * np.pi / pitch[frame + 1])
            else:
                omega = 2 * np.pi / pitch[frame]

            theta = []

            for m in range(max(number_bands_f, number_bands_f1)):

            # Generate the A_m parameters
                if frame != window_num - 1:
                    if m >= number_bands_f or m >= number_bands_f1:
                        A_f = 0
                        A_f1 = 0
                    else:
                        if frame_decision[frame][m] == 0:
                            A_f = 0
                        else:
                            A_f = Am_f[m]

                        if frame_decision[frame + 1][m] == 0:
                            A_f1 = 0
                        else:
                            A_f1 = Am_f1[m]

                    Amn = (frame + 1 - (n + i) / K) * A_f + ((n + i) / K - frame) * A_f1
                else:
                    Amn = Am_f[m]

            # Generate the theta parameters
                if m < len(theta_previous):
                    theta.append(theta_previous[m] + m * omega)
                else:
                    theta.append(m * omega)

                svv[n + i] +=  Amn * np.cos(theta[m])

            # Record the theta parameters from the previous sample point
            theta_previous = theta

        Am_f = Am_f1

        frame += 1

    return svv

# Compute the noise variance around a certain harmonic
# Sw: FFT of the frame
# band = (am, bm)
# N: length of FFT sequences
def noise_variance(Sw, band, N):
    [lower_index, upper_index] = get_indices(band, N)

    variance = 0.0
    for i in range(lower_index, upper_index + 1):
        variance += np.abs(Sw[i])**2

    return variance / (band[1] - band[0])

# Generate FFT coefficients for harmonics under unvoiced contexts
# decision: indicates whether the harmonics is voiced or unvoiced
# variance: variance around that harmonics
def unvoiced_FFT_decision(decision, variance):
    if decision == 0:
        return np.random.normal(0, 0.5 * variance) + 1j * np.random.normal(0, 0.5 * variance)
    else:
        return 0

# Create unvoiced signals for a whole frame
# band = (am, bm)
# frame_decision: contains voiced/unvoiced decisions for all harmonics in the frame
# frame_FFT: FFT of the frame data
# N: length of FFT sequences
# K: the window gap in samples
def create_unvoiced_signal(bands, frame_decision, frame_FFT, N, K):
    U_f = np.zeros((N,)) + 1j * np.zeros((N,))

    for m in range(0, len(bands)):
        if frame_decision[m] == 0:
            [lower_index, upper_index] = get_indices(bands[m], N)
            for i in range(lower_index, upper_index + 1):
                variance = noise_variance(frame_FFT, bands[m], N)
                U_f[i] = unvoiced_FFT_decision(frame_decision[m], variance)

    return np.fft.ifft(U_f, K)

# Synthesized unvoiced parts of signals
# frame_info: contains FFTs, voiced/unvoiced decisions and optimal pitch values for all frames
# window_info: contains the length of windows, gaps between windows and total number of windows
# total: the amount of sample points in the result
def Unvoiced_Synthesis(frame_info, window_info, total):

    # Set up previous data
    frame_FFT = frame_info[0]
    pitch = frame_info[1]
    frame_decision = frame_info[2]
    frame_estimate = frame_info[3]
    N = frame_info[4]

    window_dur = window_info[0]
    window_gap = window_info[1]
    window_num = window_info[2]

    K = window_gap

    suu = np.zeros((total,)) + 1j * np.zeros((total, ))

    # Create the FFT for frame 0

    frame = 0

    bands = frequency_bands(pitch[frame])

    u_f = create_unvoiced_signal(frequency_bands(pitch[frame]), frame_decision[frame], frame_FFT[frame], N, K)

    # Go over each window gap
    for n in range(0, total, K):

        if frame == window_num - 1:
            u_f1 = np.zeros((window_gap, )) + 1j * np.zeros((window_gap, ))
        else:
            u_f1 = create_unvoiced_signal(frequency_bands(pitch[frame + 1]), frame_decision[frame + 1], frame_FFT[frame + 1], N, K)

        # Go over each sample in the window gap
        for i in range(0, K):
            if(n + i >=total):
                break;

            suu[n + i] = (frame + 1 - (n + i) / K) * u_f[i] + ((n + i)/K - frame) * u_f1[i]

        u_f = u_f1

        frame += 1

    return suu

# input_filename = 's5.wav'
# T_skip = 0.010
# T_frame = 0.025
# N = 1024
# pitch_range = [20, 90] #(Pitch range for the given voice)
# #pitch_range = [40, 180] # (Pitch range for our own recorded voice)
# UV_decision = 0 #When this variable is 1, we'll make decisions for individual harmonics. When it's 0, we'll make
# #decisions for the whole band
# noise = 0.1
#
# [frame_info, window_info, total, stats] = Analysis(input_filename, T_skip, T_frame, noise, pitch_range, N, UV_decision)
# svv = Voice_Synthesis(frame_info, window_info, total)
# suu = Unvoiced_Synthesis(frame_info, window_info, total)
#
# scale = stats[0]
# mean = stats[1]
#
# [sample_rate, sample_data] = wave.read(input_filename);
#
# s_synthesis = np.real((svv + suu) * scale + mean)
# svv1 = np.real(svv * scale + mean)
# suu1 = np.real(suu * scale + mean)
#
# m = np.max(np.abs(s_synthesis))
# sigf32 = (s_synthesis/m).astype(np.float32)
# wave.write('sound.wav', sample_rate , sigf32)
