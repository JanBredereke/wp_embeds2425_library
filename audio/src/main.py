# Authors: Fynn Schur, Jesse Gollub, Mattes Bielefeld

from collections import deque

import numpy as np
from pynq import MMIO
from pynq.overlays.base import BaseOverlay

from .audio_io import read, write
from .record import Audio, AudioSource

IP_BASE_ADDRESS = 0x40000000
ADDRESS_RANGE = 0x2000
ADDRESS_OFFSET = 0x10
WINDOW_SIZE = 2


def main():
    audio = Audio(BaseOverlay("base.bit"), AudioSource.MIC)
    mmio = MMIO(IP_BASE_ADDRESS, ADDRESS_RANGE)
    queue = deque(maxlen=WINDOW_SIZE)

    while True:
        data = audio.record(0.01)

        queue.append(data)
        # if queue is not full, continue
        if len(queue) < WINDOW_SIZE:
            continue

        write(mmio, ADDRESS_OFFSET, np.concatenate(queue))

        print(read(mmio, ADDRESS_OFFSET, WINDOW_SIZE))


if __name__ == "__main__":
    main()
