library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TransmisorFM is
    Port ( 
        Clk : in std_logic;
        Reset : in std_logic;
        SW : in std_logic_vector(11 downto 0);
        AntOut : out std_logic); --Salida de la antena
end TransmisorFM;

architecture Behavioral of TransmisorFM is
    --Componentes
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
	
	-- Señales
	signal Mux1Out : std_logic_vector(31 downto 0);
	signal Mux1Sel : std_logic;
	signal ConvOut : std_logic_vector(31 downto 0);
	signal ConvIn  : std_logic;
	signal Mux2Out : std_logic_vector(31 downto 0);
begin
    RadioOsc : Oscilador generic map ( --Este oscilador es el que mandará la señal a la antena
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
		In0 => std_logic_vector(to_unsigned(1342177280, 32)),   -- Incremento de la frecuencia central 
		In1 => ConvOut,
		DataOut => Mux1Out -- Se envía al oscilador que genera la señal FM
	);

    -- Multiplexor CONV
	ConvOut <= std_logic_vector(to_unsigned(1341170647, 32)) when (ConvIn = '0') else --Incremento M de la frec central - 75 KHz
	           std_logic_vector(to_unsigned(1343183913, 32)); --Incremento M de la frec central + 75 KHz
	-- Multiplexor CONV 
	           
	AudioOsc : Oscilador generic map (
		NBits => 32
	)
	port map (
		Clk => Clk,
		Reset => Reset,
		Incremento => Mux2Out,
		DataOut => ConvIn -- Se envía a la entrada del multiplexor CONV
	);

    -- Según el switch que se seleccione emitirá una determinada nota musical.
    -- NOTA: Sólo puede haber UN switch activado, si hay más de uno, no emite nada.
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

end Behavioral;
