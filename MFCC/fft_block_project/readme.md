# Block Design Implementation zur nutzung des FFT-Blocks
(Author: Tobias Guimaraes Zimmer)

Das Projekt beinhaltet ein Blockdiagramm zur Ansteuerung und Nutzung des AMD FFT-Blocks auf dem PYNQ-Z2.
Es wurde genutzt zum testen der Machbarkeit der Audioverarbeitungs pipeline.

Diese Projekt steht bereits als Bitstream zur verfügung und kann entsprechend einfach auf das Board geladen werden.
Hier steht die Version `FFT_test_1024`, wo der FFT-Block mit einer Datenbreite von 1024 konfiguriert wurde.
Sowie die Version `FFT_test_16384`, wo der FFT-Block entsprechend mit einer Datenbreite von 16384 konfiguriert wurde.

Der Datentyp der Werte ist `Floating Point (pseudo)` was im Jupyter Notebook dem Datentyp `csingle` (Komplexe Zahlen) entspricht.

Das Projekt kann auch als Blaupause genutzt und verstanden werden um beliebige Blöcke anstatt des FFT-Blockes zu verwenden.