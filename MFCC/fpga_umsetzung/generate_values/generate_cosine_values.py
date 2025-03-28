# Author: Moses Dimmel
import numpy as np

def generate_cosine_vhdl(N, K):
    """
    Generiert eine Liste von vorberechneten Kosinus Werten fuer die DCT entsprechend der VHDL Syntax.

    Parameters:
    - N: int, Anzahl an Input-Samples.
    - K: int, Anzahl an DCT-Koeffizienten.

    Returns:
    - Einen String mit dem VHDL-Code.
    """
    
    constant_name="COSINE_VALUES"
    
    # Kosinus-Werte berechnen
    cosine_matrix = np.zeros((K, N))
    for k in range(K):
        for n in range(N):
            cosine_matrix[k, n] = np.cos((np.pi / N) * (n + 0.5) * k)

    # Werte in VHDL-Syntax formatieren
    vhdl_lines = []
    vhdl_lines.append(f"constant {constant_name} : array(0 to {K-1}, 0 to {N-1}) of real := (")

    for k in range(K):
        row_values = ", ".join(f"{value:.10f}" for value in cosine_matrix[k])
        vhdl_lines.append(f"    ({row_values})" + ("," if k < K-1 else ""))

    vhdl_lines.append(");")
    return "\n".join(vhdl_lines)


N = 400
K = 13
vhdl_code = generate_cosine_vhdl(N, K)

with open("cosine_values_vhdl.txt", "w") as file:
    file.write(vhdl_code)

print("Cosine Values have been written to cosine_values_vhdl.txt")
