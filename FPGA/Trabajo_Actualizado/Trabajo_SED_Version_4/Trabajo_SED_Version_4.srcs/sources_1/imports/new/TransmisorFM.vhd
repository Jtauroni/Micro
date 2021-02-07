library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TransmisorFM is
    Port ( 
        Clk : in std_logic;
        Reset : in std_logic;
        sw : in std_logic_vector(11 downto 0);
        AntOut : out std_logic);
end TransmisorFM;

architecture Behavioral of TransmisorFM is
    component Oscilador is
		generic (
			NBits : integer := 32
		);
		port (
			Incremento : in std_logic_vector(31 downto 0);
			Clk         : in std_logic;
			Reset       : in std_logic;
			DataOut     : out std_logic
		);
	end component;
	component Multiplexor is
		generic (
			NBits : integer := 32
		);
		port (
			Sel     : in std_logic;
			In0 : in std_logic_vector((NBits - 1) downto 0);
			In1 : in std_logic_vector((NBits - 1) downto 0);
			DataOut : out std_logic_vector((NBits - 1) downto 0)
		);
	end component;
	signal Mux1Out : std_logic_vector(31 downto 0);
	signal Mux1Sel : std_logic;
	signal ConvOut : std_logic_vector(31 downto 0);
	signal ConvIn  : std_logic;
	signal Mux2Out : std_logic_vector(31 downto 0);
begin
    RadioOsc : Oscilador generic map (
		NBits => 32
	)
	port map (
		Clk => Clk,
		Reset => Reset,
		Incremento => Mux1Out,
		DataOut => AntOut
	);
	Mux1Sel <= sw(0) or sw(1) or sw(2) or sw(3) or sw(4) or sw(5) or sw(6) or sw(7) or sw(8) or sw(9) or sw(10) or sw(11);
	Mux1 : Multiplexor generic map (
		NBits => 32
	)
	port map (
		Sel => Mux1Sel,
		In0 => std_logic_vector(to_unsigned(1342177280, 32)),   -- center freq = 100.0 MHz
		In1 => ConvOut,
		DataOut => Mux1Out
	);
	-- center freq - 75 KHz when 0
	-- center freq + 75 KHz when 1
	ConvOut <= std_logic_vector(to_unsigned(1341170647, 32)) when (ConvIn = '0') else
	           std_logic_vector(to_unsigned(1343183913, 32));
	AudioOsc : Oscilador generic map (
		NBits => 32
	)
	port map (
		Clk => Clk,
		Reset => Reset,
		Incremento => Mux2Out,
		DataOut => ConvIn
	);
--	Mux2 : Multiplexor generic map (
--		NBits => 32
--	)
--	port map (
--		Sel => Boton880,
--		In0 => std_logic_vector(to_unsigned(5906, 32)),   -- 440 Hz
--		In1 => std_logic_vector(to_unsigned(11812, 32)),  -- 880 Hz
--		DataOut => Mux2Out
--	);
--	Mux2Out <= std_logic_vector(to_unsigned(3512, 32)) when sw(0) = '1'  else --Do
--	           std_logic_vector(to_unsigned(3720, 32)) when sw(1) = '1' else --Do#
--	           std_logic_vector(to_unsigned(3941, 32)) when sw(2) = '1' else --Re
--	           std_logic_vector(to_unsigned(4176, 32)) when sw(3) = '1' else --Re#
--	           std_logic_vector(to_unsigned(4424, 32)) when sw(4) = '1' else --Mi
--	           std_logic_vector(to_unsigned(4687, 32)) when sw(5) = '1' else --Fa
--	           std_logic_vector(to_unsigned(4966, 32)) when sw(6) = '1' else --Fa#
--	           std_logic_vector(to_unsigned(5261, 32)) when sw(7) = '1' else --Sol
--	           std_logic_vector(to_unsigned(5574, 32)) when sw(8) = '1' else --Sol#
--	           std_logic_vector(to_unsigned(5906, 32)) when sw(9) = '1' else --La
--	           std_logic_vector(to_unsigned(6255, 32)) when sw(10) = '1' else --La#
--	           std_logic_vector(to_unsigned(6629, 32)) when sw(11) = '1' else --Si
--	           std_logic_vector(to_unsigned(0, 32));
	Mux2Out <= std_logic_vector(to_unsigned(3512, 32)) when sw = "000000000001" else --Do
	           std_logic_vector(to_unsigned(3720, 32)) when sw = "000000000010" else --Do#
	           std_logic_vector(to_unsigned(3941, 32)) when sw = "000000000100" else --Re
	           std_logic_vector(to_unsigned(4176, 32)) when sw = "000000001000" else --Re#
	           std_logic_vector(to_unsigned(4424, 32)) when sw = "000000010000" else --Mi
	           std_logic_vector(to_unsigned(4687, 32)) when sw = "000000100000" else --Fa
	           std_logic_vector(to_unsigned(4966, 32)) when sw = "000001000000" else --Fa#
	           std_logic_vector(to_unsigned(5261, 32)) when sw = "000010000000" else --Sol
	           std_logic_vector(to_unsigned(5574, 32)) when sw = "000100000000" else --Sol#
	           std_logic_vector(to_unsigned(5906, 32)) when sw = "001000000000" else --La
	           std_logic_vector(to_unsigned(6255, 32)) when sw = "010000000000" else --La#
	           std_logic_vector(to_unsigned(6629, 32)) when sw = "100000000000" else --Si
	           std_logic_vector(to_unsigned(0, 32));
	           
--	           Mux2Out <= "00000000000000000000110110111000" when sw = "000000000001" else --Do
--	           "00000000000000000000111010001000" when sw = "000000000010" else --Do#
--	           "00000000000000000000111101100101" when sw = "000000000100" else --Re
--	           "00000000000000000001000001010000" when sw = "000000001000" else --Re#
--	           "00000000000000000001000101001000" when sw = "000000010000" else --Mi
--	           "00000000000000000001001001001111" when sw = "000000100000" else --Fa
--	           "00000000000000000001001101110000" when sw = "000001000000" else --Fa#
--	           "00000000000000000001010010001101" when sw = "000010000000" else --Sol
--	           "00000000000000000001010111000110" when sw = "000100000000" else --Sol#
--	           "00000000000000000001011100010010" when sw = "001000000000" else --La
--	           "00000000000000000001100001101111" when sw = "010000000000" else --La#
--	           "00000000000000000001100111100101" when sw = "100000000000" else --Si
--	           "00000000000000000000000000000000";

end Behavioral;
