library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

entity Oscilador is
    generic (
		NBits : integer := 4
	);
	port (
		Incremento : in std_logic_vector((NBits-1) downto 0); -- Incremento M que aumenta cada ciclo de reloj
		Clk         : in std_logic; -- Reloj
		Reset       : in std_logic; -- Reset
		DataOut     : out std_logic -- Salida del oscilador
	);
end Oscilador;

architecture Behavioral of Oscilador is
component Registro
    generic (
        NBits : integer := 4 );
    port (
        Enable : in std_logic;
        Clk : in std_logic;
        D : in std_logic_vector ((Nbits - 1) downto 0);
        Q : out std_logic_vector ((Nbits - 1) downto 0));
end component;
signal MultiplexorOUT : std_logic_vector ((Nbits - 1) downto 0);
signal RegistroOUT : std_logic_vector ((Nbits - 1) downto 0);
begin
AcumuladorFase: Registro generic map(NBits => NBits)
                         port map(Enable => '1', Clk => Clk, D => MultiplexorOut, Q => RegistroOut);
                         
    MultiplexorOut <= (others => '0') when (Reset = '0') else -- Cuando Reset está activado se pone el registro a cero
	                  (RegistroOut + Incremento); -- Cuando Reset no está activado el registro se incrementa
	                  
    DataOut <= RegistroOut(NBits - 1); --Tomamos el bit más significativo de la salida
end Behavioral;
