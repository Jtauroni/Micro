library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TransmisorFM is
    Port ( 
        Clk : in std_logic;
        Reset : in std_logic;
        Boton440 : in std_logic;
        Boton880 : in std_logic;
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
	Mux1Sel <= Boton440 or Boton880;
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
	Mux2 : Multiplexor generic map (
		NBits => 32
	)
	port map (
		Sel => Boton880,
		In0 => std_logic_vector(to_unsigned(5906, 32)),   -- 440 Hz
		In1 => std_logic_vector(to_unsigned(11812, 32)),  -- 880 Hz
		DataOut => Mux2Out
	);

end Behavioral;
