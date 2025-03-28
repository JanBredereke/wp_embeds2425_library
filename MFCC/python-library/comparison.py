# Author: David Schulz
# Comparisson between the librosa implementation of mfcc and the custom one

import numpy as np
from librosa import load, ex, feature
from mfcc import mfcc
from matplotlib import pyplot as plt



y, sample_rate = load(ex('libri1'), sr=48000, duration=2)

lib_mfcc = feature.mfcc(
    y=y, 
    sr=sample_rate, 
    n_mfcc=16, 
    dct_type=2, 
    win_length=960, 
    hop_length=480, 
    n_fft=1024,
    window='hamm'
)

lib_spec = feature.melspectrogram(
    y=y, 
    sr=sample_rate, 
    win_length=960, 
    hop_length=480, 
    n_fft=1024,
    window='hamm', 
    norm=None, 
    center=True
)
lib_spec = 10.0 * np.log10(lib_spec)
lib_mfcc = feature.mfcc(S=lib_spec, n_mfcc=16)


mfccs = mfcc(y, sample_rate=sample_rate)



plt.figure(1)
plt.subplot(211)
plt.imshow(lib_mfcc, aspect='auto', origin='lower')
plt.title('Librosa MFCC')
plt.xlabel('Time (s)')
plt.xticks(np.arange(0, 225, 25), np.linspace(0, 2, 9))
plt.ylabel('MFCC Koeffizienten')
plt.tight_layout()
plt.subplot(212)
plt.imshow(mfccs, aspect='auto', origin='lower')
plt.title('Eigene MFCC Implementation')
plt.xlabel('Time (s)')
plt.xticks(np.arange(0, 225, 25), np.linspace(0, 2, 9))
plt.ylabel('MFCC Koeffizienten')
plt.tight_layout()
plt.show()