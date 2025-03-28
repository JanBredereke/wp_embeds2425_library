-- Autor: Moses Dimmel

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MagnitudeCalculator is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           fft_tdata : in STD_LOGIC_VECTOR (31 downto 0);
           fft_tvalid : in STD_LOGIC;
           fft_tready : inout STD_LOGIC;
           magnitude_tdata : out STD_LOGIC_VECTOR (31 downto 0);
           magnitude_tvalid : out STD_LOGIC;
           magnitude_tready : in STD_LOGIC);
end MagnitudeCalculator;

architecture MagnitudeCalculatorVerhalten of MagnitudeCalculator is

    signal re, im     : signed(15 downto 0); -- Real- und Imaginaeranteil
    signal abs_re, abs_im : unsigned(15 downto 0); -- Absolute Werte
    signal magnitude  : unsigned(31 downto 0); -- Berechnete Magnitude
    signal valid_next : std_logic; -- Next valid Zustand
begin
    process(clk, reset)
    begin
        if reset = '1' then
            magnitude_tdata  <= (others => '0');
            magnitude_tvalid <= '0';
            fft_tready       <= '1';
        elsif rising_edge(clk) then
            -- Pruefen ob input valide und bereit ist
            if fft_tvalid = '1' and fft_tready = '1' then
                -- Reellen und Imaginaeren Teil extrahieren
                re <= signed(fft_tdata(31 downto 16));
                im <= signed(fft_tdata(15 downto 0));

                -- Betraege verarbeiten
                abs_re <= unsigned(abs(re));
                abs_im <= unsigned(abs(im));

                -- Magnitude Berechnen (Angenaehert durch: |Re| + |Im|)
                magnitude <= abs_re + abs_im;

                -- Ergebnisse ausgeben wenn Ready-Signal gegeben wurde
                if magnitude_tready = '1' then
                    magnitude_tdata  <= std_logic_vector(magnitude);
                    magnitude_tvalid <= '1';
                else
                    -- Valide-Signal halten bis Ready-Signal gegeben wurde
                    valid_next <= '1';
                end if;
            else
                -- Valide-Signal zuruecksetzen wenn kein Inputsignal existiert oder Output nicht valide ist
                magnitude_tvalid <= '0';
            end if;
        end if;
    end process;

end MagnitudeCalculatorVerhalten;
