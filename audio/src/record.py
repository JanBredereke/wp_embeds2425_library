# Authors: Fynn Schur, Jesse Gollub, Mattes Bielefeld
from enum import Enum

from pynq.overlays.base import BaseOverlay


class AudioSource(Enum):
    """
    Audio sources

    MIC: Microphone jack
    LINEIN: Line in jack
    """

    MIC = 0
    LINEIN = 1


class Audio:
    def __init__(self, base: BaseOverlay, audio_source: AudioSource):
        self.base = base
        self.audio = base.audio
        if audio_source == AudioSource.MIC:
            self.audio.select_microphone()
        elif audio_source == AudioSource.LINEIN:
            self.audio.select_linein()

    def record(self, duration: float):
        self.audio.record(duration)
        return self.buffer.copy()

    @property
    def buffer(self):
        return self.audio.buffer
