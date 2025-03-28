# Author: Mattes Bielefeld

from collections import deque

import numpy as np
from pynq import MMIO
from pynq.overlays.base import BaseOverlay

from src.audio_io import read, write
from src.record import Audio, AudioSource

IP_BASE_ADDRESS = 0x40000000
ADDRESS_RANGE = 0x2000
ADDRESS_OFFSET = 0x10
WINDOW_SIZE = 2
TEST_DATA = b"00000000010101011111000000001111"


def main():
    mmio = MMIO(IP_BASE_ADDRESS, ADDRESS_RANGE)
    queue = deque(maxlen=WINDOW_SIZE)

    # Inlcude Windwoing for the Test Data
    while True:
        array = np.zeros(0)
        array = np.append(array, TEST_DATA)
        queue.append(array)
        # if queue is not full, continue
        if len(queue) < WINDOW_SIZE:
            continue

        write(mmio, ADDRESS_OFFSET, np.concatenate(queue))

        print(read(mmio, ADDRESS_OFFSET, 2))


if __name__ == "__main__":
    main()
