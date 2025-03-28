# Author: Moses Dimmel
import numpy as np

WINDOW_SIZE = 512

hamming_coeff = 0.54 - 0.46 * np.cos(2 * np.pi * np.arange(WINDOW_SIZE) / (WINDOW_SIZE - 1))

array = ", ".join(f"{coeff:.6f}" for coeff in hamming_coeff)

lut_content = f"""#ifndef HAMMING_WINDOW_H
#define HAMMING_WINDOW_H

const ap_fixed<32, 16> hamming_window[{WINDOW_SIZE}] = {{
    {array}  // Vorab berechnete Werte
}};

#endif // HAMMING_WINDOW_H
"""

with open("hamming_window.h", "w") as f:
    f.write(lut_content)