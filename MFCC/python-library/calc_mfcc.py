from typing import Union

import matplotlib.pyplot as plt
import numpy as np
from librosa import load, ex, feature
from scipy.fft import dct

"""
This file is intended for testing calculating mfcc as such it is to be understood as a test zone.
For the actual final implementation see mfcc.py.
This file shows other ways to produce the filters which could be of interest when implementing in fpga.

AUTHOR: TOBIAS GUIMARAES ZIMMER
"""


def segment_signal(signal: np.array, sample_rate: int, window_duration=20e-3, time_step=10e-3) -> np.array:
    window_sample_amount = int(window_duration * sample_rate)
    window_sample_hop_amount = int(time_step * sample_rate)

    n_frames = int(len(signal) / window_sample_hop_amount)
    # pad for last window
    signal = np.pad(signal, window_sample_amount // 2, mode='reflect')

    frames = np.zeros((n_frames, window_sample_amount))
    # generate matrix of hamming function values
    window_matrix = generate_hamming_window_matrix(window_sample_amount)

    for n in range(n_frames):
        frames[n] = signal[n * window_sample_hop_amount:n * window_sample_hop_amount + window_sample_amount]
        frames[n] = window_matrix * frames[n]

    return frames


def generate_hamming_window_matrix(window_length: int) -> np.array:
    if window_length == 0:
        return np.zeros(0)
    returning_array = np.arange(0, window_length, 1)
    # von Matlabs implementation:
    return 0.54 - 0.46 * np.cos(2.0 * np.pi * returning_array / (window_length - 1))


def calc_nearest_pow_2(n: int) -> int:
    return int(2 ** np.ceil(np.log2(n)))
    # brute force variant:
    # k = 1
    # while n > 2 ** k:
    #     k = k + 1
    # return 2 ** k


def freq_to_mel(frequency: float) -> float:
    # formula is: m = 2595 * log10(1 f/700)
    return 2595.0 * np.log10(1.0 + frequency / 700.0)


def mel_to_freq(mel: Union[float, np.array]) -> float:
    #  formula is:  f = 700 (10^(m/2595)-1)
    return 700.0 * (10.0 ** (mel / 2595.0) - 1.0)


def get_filter_points(f_min: float, f_max: float,
                      mel_filter_num: int, nfft: int, sample_rate: float) -> (np.array, np.array):
    # freq bounds to mel bounds
    min_mel = freq_to_mel(f_min)
    max_mel = freq_to_mel(f_max)

    # space them out
    # +2 since these points are the start, middle and stop points of the triangles
    mels = np.linspace(min_mel, max_mel, num=mel_filter_num + 2)
    # return to freq domain
    freqs = mel_to_freq(mels)

    # return frequencies and points converted from freq to index
    return np.floor((nfft + 1) / sample_rate * freqs).astype(int), freqs


def get_bartlett_window_matrix(left_bound: int, right_bound: int, filter: np.array) -> np.array:
    # doesn't always return 1 in middle
    # formula taken from matlab implementation
    L = right_bound - left_bound
    N = L - 1
    n = np.linspace(0, N, L)
    bartlett = np.where(np.less_equal(n, (N / 2)), 2 * n / N, 2 - 2 * n / N)
    filter[left_bound:right_bound] = bartlett
    return filter


def get_triang_window_matrix(left_bound: int, right_bound: int, filter: np.array) -> np.array:
    # broken i dunno why
    # formula taken from matlab implementation
    L = right_bound - left_bound
    N = L + 1
    n = np.linspace(1, N, L)
    if L % 2 != 0:
        triang = np.where(np.less_equal(n, (N / 2)), 2 * n / N, 2 - 2 * n / N)
    else:
        N = L
        triang = np.where(np.less_equal(n, (N / 2)), (2 * n - 1) / N, 2 - (2 * n - 1) / N)
    filter[left_bound:right_bound] = triang
    return filter


def get_filters(filter_points, nfft):
    # actual filter are - 2 and nfft/2 since only half the fft values are of relevance
    filters = np.zeros((len(filter_points) - 2, int(nfft / 2 + 1)))

    filters2 = np.zeros((len(filter_points) - 2, int(nfft / 2 + 1)))
    for n in range(len(filter_points) - 2):
        filters2[n] = get_bartlett_window_matrix(filter_points[n], filter_points[n + 2], filters[n])

    filters3 = np.zeros((len(filter_points) - 2, int(nfft / 2 + 1)))
    for n in range(len(filter_points) - 2):
        filters3[n] = get_triang_window_matrix(filter_points[n], filter_points[n + 2], filters[n])

    for n in range(len(filter_points) - 2):
        filters[n, filter_points[n]: filter_points[n + 1]] = np.linspace(0, 1, filter_points[n + 1] - filter_points[n])
        filters[n, filter_points[n + 1]: filter_points[n + 2]] = np.linspace(1, 0, filter_points[n + 2] - filter_points[
            n + 1])

    return filters


y, sample_rate = load(ex('libri1'), sr=48000, duration=2)

windowed_matrix = segment_signal(y, sample_rate)

min_freq = 0
max_freq = sample_rate / 2
# has to be 2^n so dct via fft blocks becomes viable
mel_filter_num = 16

n_fft = calc_nearest_pow_2(len(windowed_matrix[0]))
fft_frames = np.copy(windowed_matrix)

# pad to 2^n if not (with zeros)
if n_fft != len(windowed_matrix[0]):
    odd: int = 1 if n_fft - len(windowed_matrix[0]) % 2 != 0 else 0

    fft_frames = np.pad(fft_frames,
                        ((0, 0),
                         ((n_fft - len(windowed_matrix[0])) // 2,
                          (n_fft - len(windowed_matrix[0])) // 2 + odd)),
                        mode='constant', constant_values=0)

fft_frames = np.fft.fft(fft_frames)

# get power spectrum
power_spectrum = np.abs(fft_frames) ** 2

# filter points (start and stop) and corresponding frequencies
filter_points, frequency = get_filter_points(min_freq, max_freq, mel_filter_num, n_fft, sample_rate)
filters = get_filters(filter_points, n_fft)

# enorm = 2.0 / (frequency[2:mel_filter_num+2] - frequency[:mel_filter_num])
# filters *= enorm[:, np.newaxis]

# for n in range(filters.shape[0]):
#     plt.plot(filters[n])
# plt.show()


# take right side of spektrum
right = power_spectrum[:, :len(power_spectrum[0]) // 2 + 1]
# right = power_spectrum[:, power_spectrum.shape[0]]

# faltung mit filtern
filtered_frames = np.dot(filters, right.T)

filtered_frames = 10.0 * np.log10(filtered_frames)

filtered_frames = filtered_frames.T
filtered_frames_copy = np.flip(filtered_frames, 1)

prepared_filtered_frames = np.append(filtered_frames, filtered_frames_copy, 1)

second_fft = np.fft.fft(prepared_filtered_frames).real
second_fft = second_fft[:, :int(len(second_fft[0]) / 2)].T
second_fft_dct = dct(filtered_frames).T

# they do some normalization here which cannot be disabled
lib_mfcc = feature.mfcc(y=y, sr=sample_rate, n_mfcc=16, dct_type=2, win_length=960, hop_length=480, n_fft=1024,
                        window='hamm')
# go second way to disable it
lib_spec = feature.melspectrogram(y=y, sr=sample_rate, win_length=960, hop_length=480, n_fft=1024,
                                  window='hamm', norm=None, center=True)
lib_spec = 10.0 * np.log10(lib_spec)
lib_mfcc = feature.mfcc(S=lib_spec, n_mfcc=16)

error = np.sum(np.abs(second_fft_dct - second_fft)) / (len(second_fft) * len(second_fft[0]))

plt.figure(1)
plt.subplot(311)
plt.imshow(lib_mfcc, aspect='auto', origin='lower')
plt.subplot(312)
plt.imshow(second_fft_dct, aspect='auto', origin='lower')
plt.subplot(313)
plt.imshow(second_fft, aspect='auto', origin='lower')
plt.show()
print(error)
