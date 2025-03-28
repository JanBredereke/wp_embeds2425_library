# Author: David Schulz

import pyqtgraph as pg
from PySide6 import QtCore, QtWidgets
import numpy as np
import pyaudio


CHUNK = 1024
FORMAT = pyaudio.paFloat32
CHANNELS = 1
RATE = 44100
RECORD_SECONDS = CHUNK / RATE

p = pyaudio.PyAudio()

stream = p.open(
    format=FORMAT,
    channels=CHANNELS,
    rate=RATE,
    input=True,
    frames_per_buffer=CHUNK
)


class MainWindow(QtWidgets.QMainWindow):
    def __init__(self):
        super().__init__()

        self.mainbox = QtWidgets.QWidget()
        self.setCentralWidget(self.mainbox)

        self.layout = QtWidgets.QVBoxLayout(self.mainbox)
        self.canvas = pg.GraphicsLayoutWidget()

        self.plot_graph = pg.PlotWidget()
        self.plot_graph.setBackground("w")
        pen = pg.mkPen(color=(0, 0, 255))
        self.plot_graph.setYRange(-.25, .25, padding=0.1)
        self.time = np.arange(0, RECORD_SECONDS, 1/RATE)
        data = stream.read(CHUNK, exception_on_overflow=False)
        self.data = np.frombuffer(data, dtype=np.float32)
        # Get a line reference
        self.line = self.plot_graph.plot(
            self.time,
            self.data,
            name="Audio Data",
            pen=pen,
            symbol="o",
            symbolSize=4,
            symbolBrush="b",
        )

        self.plot_graph2 = pg.PlotWidget()
        self.plot_graph2.setBackground("w")
        self.plot_graph2.setXRange(0, 12000, padding=0.1)
        self.plot_graph2.setYRange(0, 10, padding=0.1)

        freq = np.fft.fftshift(np.fft.fftfreq(
            len(self.time), 1/RATE))[CHUNK//2:]
        data_fft = np.fft.fftshift(np.fft.fft(self.data))[CHUNK//2:]
        self.line2 = self.plot_graph2.plot(
            freq,
            np.abs(data_fft),
            name="Audio Data",
            pen=pen,
            symbol="o",
            symbolSize=4,
            symbolBrush="b",
        )

        self.layout.addWidget(self.plot_graph)
        self.layout.addWidget(self.plot_graph2)

        # Add a timer to simulate new data measurements
        self.timer = QtCore.QTimer()
        self.timer.setInterval(30)
        self.timer.timeout.connect(self.update_plot)
        self.timer.start()

    def update_plot(self):
        data = stream.read(CHUNK, exception_on_overflow=False)
        data_new = np.frombuffer(data, dtype=np.float32)
        data_fft = np.fft.fftshift(np.fft.fft(data_new))[CHUNK//2:]
        freq = np.fft.fftshift(np.fft.fftfreq(
            len(self.time), 1/RATE))[CHUNK//2:]
        self.data = data_new
        self.line.setData(self.time, self.data)
        self.line2.setData(freq, np.abs(data_fft))


app = QtWidgets.QApplication([])
main = MainWindow()
main.show()
app.exec()

stream.stop_stream()
stream.close()
p.terminate()
