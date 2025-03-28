-- Autor: Moses Dimmel

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.MATH_REAL.ALL;
use work.fixed_generic_pkg_mod.all;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity HammingWindow is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           s_axis_tdata : in STD_LOGIC_VECTOR (31 downto 0);
           s_axis_tvalid : in STD_LOGIC;
           s_axis_tready : inout STD_LOGIC;
           m_axis_tdata : out STD_LOGIC_VECTOR (31 downto 0);
           m_axis_tvalid : out STD_LOGIC;
           m_axis_tready : in STD_LOGIC);
end HammingWindow;

architecture HammingWindowVerhalten of HammingWindow is

    constant WINDOW_SIZE : integer := 400;
    --attribute ram_style : string;
    --attribute ram_style of HAMMING_COEFF : signal is "block";
    --TODO: Hamming Koeffizienten in BRAM speichern
    type coeff_array is array (natural range <>) of sfixed;
    signal HAMMING_COEFF : coeff_array(0 to WINDOW_SIZE - 1) := (to_sfixed(0.080000, 32, 0), sfixed(0.080057, 32, 0), sfixed(0.080228, 32, 0), sfixed(0.080513, 32, 0), sfixed(0.080912, 32, 0), sfixed(0.081425, 32, 0), sfixed(0.082052, 32, 0), sfixed(0.082792, 32, 0), sfixed(0.083645, 32, 0), sfixed(0.084612, 32, 0), sfixed(0.085692, 32, 0), sfixed(0.086884, 32, 0), sfixed(0.088189, 32, 0), sfixed(0.089605, 32, 0), sfixed(0.091134, 32, 0), sfixed(0.092773, 32, 0), sfixed(0.094524, 32, 0), sfixed(0.096385, 32, 0), sfixed(0.098356, 32, 0), sfixed(0.100437, 32, 0), sfixed(0.102626, 32, 0), sfixed(0.104924, 32, 0), sfixed(0.107330, 32, 0), sfixed(0.109843, 32, 0), sfixed(0.112463, 32, 0), sfixed(0.115189, 32, 0), sfixed(0.118020, 32, 0), sfixed(0.120956, 32, 0), sfixed(0.123996, 32, 0), sfixed(0.127139, 32, 0), sfixed(0.130384, 32, 0), sfixed(0.133731, 32, 0), sfixed(0.137178, 32, 0), sfixed(0.140726, 32, 0), sfixed(0.144372, 32, 0), sfixed(0.148117, 32, 0), sfixed(0.151959, 32, 0), sfixed(0.155897, 32, 0), sfixed(0.159930, 32, 0), sfixed(0.164058, 32, 0), sfixed(0.168278, 32, 0), sfixed(0.172591, 32, 0), sfixed(0.176995, 32, 0), sfixed(0.181489, 32, 0), sfixed(0.186072, 32, 0), sfixed(0.190743, 32, 0), sfixed(0.195500, 32, 0), sfixed(0.200343, 32, 0), sfixed(0.205270, 32, 0), sfixed(0.210280, 32, 0), sfixed(0.215372, 32, 0), sfixed(0.220544, 32, 0), sfixed(0.225795, 32, 0), sfixed(0.231125, 32, 0), sfixed(0.236531, 32, 0), sfixed(0.242012, 32, 0), sfixed(0.247567, 32, 0), sfixed(0.253195, 32, 0), sfixed(0.258893, 32, 0), sfixed(0.264662, 32, 0), sfixed(0.270499, 32, 0), sfixed(0.276402, 32, 0), sfixed(0.282371, 32, 0), sfixed(0.288404, 32, 0), sfixed(0.294499, 32, 0), sfixed(0.300655, 32, 0), sfixed(0.306871, 32, 0), sfixed(0.313144, 32, 0), sfixed(0.319473, 32, 0), sfixed(0.325857, 32, 0), sfixed(0.332295, 32, 0), sfixed(0.338783, 32, 0), sfixed(0.345322, 32, 0), sfixed(0.351909, 32, 0), sfixed(0.358543, 32, 0), sfixed(0.365221, 32, 0), sfixed(0.371943, 32, 0), sfixed(0.378707, 32, 0), sfixed(0.385510, 32, 0), sfixed(0.392352, 32, 0), sfixed(0.399231, 32, 0), sfixed(0.406144, 32, 0), sfixed(0.413091, 32, 0), sfixed(0.420069, 32, 0), sfixed(0.427077, 32, 0), sfixed(0.434113, 32, 0), sfixed(0.441175, 32, 0), sfixed(0.448261, 32, 0), sfixed(0.455371, 32, 0), sfixed(0.462501, 32, 0), sfixed(0.469650, 32, 0), sfixed(0.476817, 32, 0), sfixed(0.484000, 32, 0), sfixed(0.491197, 32, 0), sfixed(0.498405, 32, 0), sfixed(0.505624, 32, 0), sfixed(0.512852, 32, 0), sfixed(0.520086, 32, 0), sfixed(0.527325, 32, 0), sfixed(0.534567, 32, 0), sfixed(0.541811, 32, 0), sfixed(0.549054, 32, 0), sfixed(0.556295, 32, 0), sfixed(0.563532, 32, 0), sfixed(0.570763, 32, 0), sfixed(0.577986, 32, 0), sfixed(0.585201, 32, 0), sfixed(0.592403, 32, 0), sfixed(0.599593, 32, 0), sfixed(0.606768, 32, 0), sfixed(0.613927, 32, 0), sfixed(0.621067, 32, 0), sfixed(0.628187, 32, 0), sfixed(0.635285, 32, 0), sfixed(0.642360, 32, 0), sfixed(0.649409, 32, 0), sfixed(0.656431, 32, 0), sfixed(0.663424, 32, 0), sfixed(0.670387, 32, 0), sfixed(0.677317, 32, 0), sfixed(0.684213, 32, 0), sfixed(0.691073, 32, 0), sfixed(0.697896, 32, 0), sfixed(0.704680, 32, 0), sfixed(0.711423, 32, 0), sfixed(0.718124, 32, 0), sfixed(0.724780, 32, 0), sfixed(0.731390, 32, 0), sfixed(0.737953, 32, 0), sfixed(0.744467, 32, 0), sfixed(0.750931, 32, 0), sfixed(0.757341, 32, 0), sfixed(0.763698, 32, 0), sfixed(0.770000, 32, 0), sfixed(0.776245, 32, 0), sfixed(0.782430, 32, 0), sfixed(0.788556, 32, 0), sfixed(0.794620, 32, 0), sfixed(0.800621, 32, 0), sfixed(0.806558, 32, 0), sfixed(0.812428, 32, 0), sfixed(0.818231, 32, 0), sfixed(0.823965, 32, 0), sfixed(0.829628, 32, 0), sfixed(0.835220, 32, 0), sfixed(0.840738, 32, 0), sfixed(0.846182, 32, 0), sfixed(0.851550, 32, 0), sfixed(0.856840, 32, 0), sfixed(0.862052, 32, 0), sfixed(0.867184, 32, 0), sfixed(0.872235, 32, 0), sfixed(0.877204, 32, 0), sfixed(0.882089, 32, 0), sfixed(0.886889, 32, 0), sfixed(0.891603, 32, 0), sfixed(0.896230, 32, 0), sfixed(0.900769, 32, 0), sfixed(0.905218, 32, 0), sfixed(0.909577, 32, 0), sfixed(0.913844, 32, 0), sfixed(0.918018, 32, 0), sfixed(0.922098, 32, 0), sfixed(0.926084, 32, 0), sfixed(0.929974, 32, 0), sfixed(0.933767, 32, 0), sfixed(0.937463, 32, 0), sfixed(0.941060, 32, 0), sfixed(0.944558, 32, 0), sfixed(0.947955, 32, 0), sfixed(0.951251, 32, 0), sfixed(0.954446, 32, 0), sfixed(0.957537, 32, 0), sfixed(0.960525, 32, 0), sfixed(0.963409, 32, 0), sfixed(0.966187, 32, 0), sfixed(0.968860, 32, 0), sfixed(0.971427, 32, 0), sfixed(0.973886, 32, 0), sfixed(0.976238, 32, 0), sfixed(0.978482, 32, 0), sfixed(0.980617, 32, 0), sfixed(0.982643, 32, 0), sfixed(0.984559, 32, 0), sfixed(0.986365, 32, 0), sfixed(0.988060, 32, 0), sfixed(0.989644, 32, 0), sfixed(0.991117, 32, 0), sfixed(0.992478, 32, 0), sfixed(0.993726, 32, 0), sfixed(0.994862, 32, 0), sfixed(0.995885, 32, 0), sfixed(0.996796, 32, 0), sfixed(0.997592, 32, 0), sfixed(0.998276, 32, 0), sfixed(0.998846, 32, 0), sfixed(0.999301, 32, 0), sfixed(0.999644, 32, 0), sfixed(0.999872, 32, 0), sfixed(0.999986, 32, 0), sfixed(0.999986, 32, 0), sfixed(0.999872, 32, 0), sfixed(0.999644, 32, 0), sfixed(0.999301, 32, 0), sfixed(0.998846, 32, 0), sfixed(0.998276, 32, 0), sfixed(0.997592, 32, 0), sfixed(0.996796, 32, 0), sfixed(0.995885, 32, 0), sfixed(0.994862, 32, 0), sfixed(0.993726, 32, 0), sfixed(0.992478, 32, 0), sfixed(0.991117, 32, 0), sfixed(0.989644, 32, 0), sfixed(0.988060, 32, 0), sfixed(0.986365, 32, 0), sfixed(0.984559, 32, 0), sfixed(0.982643, 32, 0), sfixed(0.980617, 32, 0), sfixed(0.978482, 32, 0), sfixed(0.976238, 32, 0), sfixed(0.973886, 32, 0), sfixed(0.971427, 32, 0), sfixed(0.968860, 32, 0), sfixed(0.966187, 32, 0), sfixed(0.963409, 32, 0), sfixed(0.960525, 32, 0), sfixed(0.957537, 32, 0), sfixed(0.954446, 32, 0), sfixed(0.951251, 32, 0), sfixed(0.947955, 32, 0), sfixed(0.944558, 32, 0), sfixed(0.941060, 32, 0), sfixed(0.937463, 32, 0), sfixed(0.933767, 32, 0), sfixed(0.929974, 32, 0), sfixed(0.926084, 32, 0), sfixed(0.922098, 32, 0), sfixed(0.918018, 32, 0), sfixed(0.913844, 32, 0), sfixed(0.909577, 32, 0), sfixed(0.905218, 32, 0), sfixed(0.900769, 32, 0), sfixed(0.896230, 32, 0), sfixed(0.891603, 32, 0), sfixed(0.886889, 32, 0), sfixed(0.882089, 32, 0), sfixed(0.877204, 32, 0), sfixed(0.872235, 32, 0), sfixed(0.867184, 32, 0), sfixed(0.862052, 32, 0), sfixed(0.856840, 32, 0), sfixed(0.851550, 32, 0), sfixed(0.846182, 32, 0), sfixed(0.840738, 32, 0), sfixed(0.835220, 32, 0), sfixed(0.829628, 32, 0), sfixed(0.823965, 32, 0), sfixed(0.818231, 32, 0), sfixed(0.812428, 32, 0), sfixed(0.806558, 32, 0), sfixed(0.800621, 32, 0), sfixed(0.794620, 32, 0), sfixed(0.788556, 32, 0), sfixed(0.782430, 32, 0), sfixed(0.776245, 32, 0), sfixed(0.770000, 32, 0), sfixed(0.763698, 32, 0), sfixed(0.757341, 32, 0), sfixed(0.750931, 32, 0), sfixed(0.744467, 32, 0), sfixed(0.737953, 32, 0), sfixed(0.731390, 32, 0), sfixed(0.724780, 32, 0), sfixed(0.718124, 32, 0), sfixed(0.711423, 32, 0), sfixed(0.704680, 32, 0), sfixed(0.697896, 32, 0), sfixed(0.691073, 32, 0), sfixed(0.684213, 32, 0), sfixed(0.677317, 32, 0), sfixed(0.670387, 32, 0), sfixed(0.663424, 32, 0), sfixed(0.656431, 32, 0), sfixed(0.649409, 32, 0), sfixed(0.642360, 32, 0), sfixed(0.635285, 32, 0), sfixed(0.628187, 32, 0), sfixed(0.621067, 32, 0), sfixed(0.613927, 32, 0), sfixed(0.606768, 32, 0), sfixed(0.599593, 32, 0), sfixed(0.592403, 32, 0), sfixed(0.585201, 32, 0), sfixed(0.577986, 32, 0), sfixed(0.570763, 32, 0), sfixed(0.563532, 32, 0), sfixed(0.556295, 32, 0), sfixed(0.549054, 32, 0), sfixed(0.541811, 32, 0), sfixed(0.534567, 32, 0), sfixed(0.527325, 32, 0), sfixed(0.520086, 32, 0), sfixed(0.512852, 32, 0), sfixed(0.505624, 32, 0), sfixed(0.498405, 32, 0), sfixed(0.491197, 32, 0), sfixed(0.484000, 32, 0), sfixed(0.476817, 32, 0), sfixed(0.469650, 32, 0), sfixed(0.462501, 32, 0), sfixed(0.455371, 32, 0), sfixed(0.448261, 32, 0), sfixed(0.441175, 32, 0), sfixed(0.434113, 32, 0), sfixed(0.427077, 32, 0), sfixed(0.420069, 32, 0), sfixed(0.413091, 32, 0), sfixed(0.406144, 32, 0), sfixed(0.399231, 32, 0), sfixed(0.392352, 32, 0), sfixed(0.385510, 32, 0), sfixed(0.378707, 32, 0), sfixed(0.371943, 32, 0), sfixed(0.365221, 32, 0), sfixed(0.358543, 32, 0), sfixed(0.351909, 32, 0), sfixed(0.345322, 32, 0), sfixed(0.338783, 32, 0), sfixed(0.332295, 32, 0), sfixed(0.325857, 32, 0), sfixed(0.319473, 32, 0), sfixed(0.313144, 32, 0), sfixed(0.306871, 32, 0), sfixed(0.300655, 32, 0), sfixed(0.294499, 32, 0), sfixed(0.288404, 32, 0), sfixed(0.282371, 32, 0), sfixed(0.276402, 32, 0), sfixed(0.270499, 32, 0), sfixed(0.264662, 32, 0), sfixed(0.258893, 32, 0), sfixed(0.253195, 32, 0), sfixed(0.247567, 32, 0), sfixed(0.242012, 32, 0), sfixed(0.236531, 32, 0), sfixed(0.231125, 32, 0), sfixed(0.225795, 32, 0), sfixed(0.220544, 32, 0), sfixed(0.215372, 32, 0), sfixed(0.210280, 32, 0), sfixed(0.205270, 32, 0), sfixed(0.200343, 32, 0), sfixed(0.195500, 32, 0), sfixed(0.190743, 32, 0), sfixed(0.186072, 32, 0), sfixed(0.181489, 32, 0), sfixed(0.176995, 32, 0), sfixed(0.172591, 32, 0), sfixed(0.168278, 32, 0), sfixed(0.164058, 32, 0), sfixed(0.159930, 32, 0), sfixed(0.155897, 32, 0), sfixed(0.151959, 32, 0), sfixed(0.148117, 32, 0), sfixed(0.144372, 32, 0), sfixed(0.140726, 32, 0), sfixed(0.137178, 32, 0), sfixed(0.133731, 32, 0), sfixed(0.130384, 32, 0), sfixed(0.127139, 32, 0), sfixed(0.123996, 32, 0), sfixed(0.120956, 32, 0), sfixed(0.118020, 32, 0), sfixed(0.115189, 32, 0), sfixed(0.112463, 32, 0), sfixed(0.109843, 32, 0), sfixed(0.107330, 32, 0), sfixed(0.104924, 32, 0), sfixed(0.102626, 32, 0), sfixed(0.100437, 32, 0), sfixed(0.098356, 32, 0), sfixed(0.096385, 32, 0), sfixed(0.094524, 32, 0), sfixed(0.092773, 32, 0), sfixed(0.091134, 32, 0), sfixed(0.089605, 32, 0), sfixed(0.088189, 32, 0), sfixed(0.086884, 32, 0), sfixed(0.085692, 32, 0), sfixed(0.084612, 32, 0), sfixed(0.083645, 32, 0), sfixed(0.082792, 32, 0), sfixed(0.082052, 32, 0), sfixed(0.081425, 32, 0), sfixed(0.080912, 32, 0), sfixed(0.080513, 32, 0), sfixed(0.080228, 32, 0), sfixed(0.080057, 32, 0), sfixed(0.080000, 32, 0));
    -- mit python script ermittelt, gespeichert im BRAM zur Optimierung
    signal index      : integer range 0 to WINDOW_SIZE - 1 := 0;

begin
    process(clk, reset)
    begin
        if reset = '1' then
            index <= 0;
            m_axis_tdata <= (others => '0');
            s_axis_tready <= '0';
        elsif rising_edge(clk) then
            if s_axis_tvalid = '1' and s_axis_tready = '1' then
                -- Hamming Gewichtung durchfuehren
                m_axis_tdata <= std_logic_vector(to_signed(
                    (to_sfixed(signed(s_axis_tdata), 32, 0)) * HAMMING_COEFF(index), 32));
                m_axis_tvalid <= '1';
                s_axis_tready <= '0';
                
                index <= index + 1;
                if index = WINDOW_SIZE - 1 then
                    index <= 0;
                end if;
            elsif m_axis_tready = '1' then
                -- Output akzeptiert, Signal zuruecksetzen
                m_axis_tvalid <= '0';
                s_axis_tready <= '1';
            end if;
        end if;
    end process;

end HammingWindowVerhalten;
