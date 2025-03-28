# Author: Moses Dimmel
import numpy as np

WINDOW_SIZE = 400

# Berechne Hamming-Koeffizienten
hamming_coeff = 0.54 - 0.46 * np.cos(2 * np.pi * np.arange(WINDOW_SIZE) / (WINDOW_SIZE - 1))

# Generiere VHDL-Konstante
vhdl_array = ", 32, 0), sfixed(".join(f"{coeff:.6f}" for coeff in hamming_coeff)
print(f"constant HAMMING_COEFF : real_vector(0 to {WINDOW_SIZE-1}) := (to_sfixed({vhdl_array}, 32, 0));")
