# Author: Mattes Bielefeld

import math
import struct
import wave
from collections import deque
from time import sleep

import numpy as np
from pynq.overlays.base import BaseOverlay

from src.record import Audio, AudioSource

SAMPLE_RATE = 48000
TEST_SECONDS = 5


# Diese Methode ist inspiriert und zum Teil kopiert von den Dateien zum BaseOverlay von PYNQ,
# zu finden im PYNQ GitHub unter pynq/lib/audio.py in der Methode save der Klasse AudioADAU1761
def write_file(buffer, file, sample_len, sample_rate):
    samples_4byte = buffer.tobytes()
    byte_format = ("%ds %dx " % (3, 1)) * sample_len * 2
    samples_3byte = b"".join(struct.unpack(byte_format, samples_4byte))
    with wave.open(file, "wb") as wav_file:
        # Set the number of channels
        wav_file.setnchannels(2)
        # Set the sample width to 3 bytes
        wav_file.setsampwidth(3)
        # Set the frame rate to sample_rate
        wav_file.setframerate(sample_rate)
        # Set the number of frames to sample_len
        wav_file.setnframes(sample_len)
        # Set the compression type and description
        wav_file.setcomptype("NONE", "not compressed")
        # Write data
        wav_file.writeframes(samples_3byte)


def main():
    audio = Audio(BaseOverlay("base.bit"), AudioSource.MIC)
    test_duration = (
        TEST_SECONDS * 1000
    )  # to scale recording block up to 5 second (5000ms)
    sample_len = math.ceil(TEST_SECONDS * SAMPLE_RATE)
    file1 = "/home/xilinx/jupyter_notebooks/base/audio/test_new.wav"
    file2 = "/home/xilinx/jupyter_notebooks/base/audio/audio_comparison_test_new.wav"
    buffer = np.zeros(0, dtype=np.int32)

    print("start recording 1")
    data1 = audio.record(TEST_SECONDS)
    write_file(data1, file2, sample_len, SAMPLE_RATE)

    print("start recording 2")
    for i in range(test_duration):
        duration = 0.01
        data2 = audio.record(duration)
        buffer = np.append(buffer, data2, axis=None)

    write_file(buffer, file1, sample_len, SAMPLE_RATE)


if __name__ == "__main__":
    main()
