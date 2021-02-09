library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TransmisorFM is
    Port ( 
        Clk : in std_logic;
        Reset : in std_logic;
        Boton440 : in std_logic; -- BTNL
        Boton880 : in std_logic; -- BTNR
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
	Mux1Sel <= Boton440 or Boton880;
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
      
      
	AudioOsc : Oscilador generic map ( --Oscilador que cambia entre fc + 75 KHz y fc - 75 KHz
		NBits => 32
	)
	port map (
		Clk => Clk,
		Reset => Reset,
		Incremento => Mux2Out,
		DataOut => ConvIn -- Se envía a la entrada del multiplexor CONV
	);
	Mux2 : Multiplexor generic map ( -- Multiplexor que según el botón que se pulse cambia entre La 4ª y La 5ª
		NBits => 32
	)
	port map (
		Sel => Boton880,
		In0 => std_logic_vector(to_unsigned(5906, 32)),   -- Sonido de la nota LA 4ª 440 Hz
		In1 => std_logic_vector(to_unsigned(11812, 32)),   -- Sonido de la nota La 5ª 880 Hz
		DataOut => Mux2Out -- Se envía al oscilador de Audio
	);

end Behavioral;
