--En esta versión se ha optado por añadir un ADC para enviar señal de audio
--Las entradas de la entidad top se han cambiado añadiendole las del ADC

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TransmisorFM is
    Port ( 
        Clk : in std_logic;
        Reset : in std_logic;
        vp_in : in std_logic; --Entrada + del ADC
        vn_in : in std_logic; --Entrada - del ADC
        AntOut : out std_logic); --Salida de la antena
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
	component top_XADC is --Instanciamos el ADC
	   Port ( 
            Clk : in std_logic;
            Reset : in std_logic;
            vp_in : in std_logic;
            vn_in : in std_logic;
            dout : out std_logic_vector(15 downto 0);
            drdy : out std_logic;
            channel : out std_logic_vector(4 downto 0)
    );
	end component;
	-- Señales
	signal IncrementoADC : std_logic_vector(31 downto 0);
	signal dout : std_logic_vector(15 downto 0);
	
	-- Constantes
	constant ADCgain : integer := 31;
	constant FrecuenciaCentralINC : integer := 1342177280;
begin

    RadioOsc : Oscilador generic map ( --Definimos el Oscilador que enviará la señal FM
		NBits => 32
	)
	port map (
		Clk => Clk,
		Reset => Reset,
		Incremento => IncrementoADC,
		DataOut => AntOut
	);         
	
	ADC: top_XADC port map( --Definimos el ADC
	   Clk => Clk,
       Reset => Reset,
       vp_in => vp_in,
       vn_in => vn_in,
       dout => dout,
       drdy => open,
       channel => open
	);
	
	IncrementoADC <= std_logic_vector((signed(dout)*to_signed(ADCgain,16)) + FrecuenciaCentralINC);
	

end Behavioral;
