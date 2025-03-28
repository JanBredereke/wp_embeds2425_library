# Authors: Fynn Schur, Jesse Gollub, Mattes Bielefeld

from numpy import ndarray
from pynq import MMIO


def write(mmio: MMIO, address: int, data: ndarray):
    bytes = data.tobytes()
    print("bytelength", len(bytes))
    mmio.write(address, bytes)


def read(mmio: MMIO, address: int, size: int):
    return mmio.read(address, size)
