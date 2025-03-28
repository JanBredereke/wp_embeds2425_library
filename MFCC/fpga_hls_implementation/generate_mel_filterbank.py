# Author: Moses Dimmel
import numpy as np

def mel_filterbank(sample_rate=48000, fft_size=512, mel_bands=20):
    """Generiert eine Mel-Filterbank als 2D-Array"""
    def hz_to_mel(hz):
        return 2595 * np.log10(1 + hz / 700)
    
    def mel_to_hz(mel):
        return 700 * (10**(mel / 2595) - 1)
    
    min_hz, max_hz = 300, sample_rate // 2  # Sprachbereich 300Hz - 24kHz
    mel_min, mel_max = hz_to_mel(min_hz), hz_to_mel(max_hz)
    mel_points = np.linspace(mel_min, mel_max, mel_bands + 2)
    hz_points = mel_to_hz(mel_points)
    bin_points = np.floor((fft_size + 1) * hz_points / sample_rate).astype(int)

    filterbank = np.zeros((mel_bands, fft_size))
    for i in range(1, mel_bands + 1):
        left, center, right = bin_points[i - 1], bin_points[i], bin_points[i + 1]
        for j in range(left, center):
            filterbank[i - 1, j] = (j - left) / (center - left)
        for j in range(center, right):
            filterbank[i - 1, j] = (right - j) / (right - center)

    return filterbank


# Generiere LUT für FPGA
filterbank = mel_filterbank()
with open("mel_filterbank_lut.h", "w") as f:
    f.write("#ifndef MEL_FILTERBANK_LUT_H\n#define MEL_FILTERBANK_LUT_H\n\n")
    f.write("const fixed_t mel_filterbank[MEL_BANDS][FFT_SIZE] = {\n")
    for band in filterbank:
        f.write("    {" + ", ".join(f"{x:.6f}" for x in band) + "},\n")
    f.write("};\n\n#endif // MEL_FILTERBANK_LUT_H\n")