library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

entity Oscilador is
    generic (
		NBits : integer := 32
	);
	port (
		Incremento : in std_logic_vector((NBits-1) downto 0);
		Clk         : in std_logic;
		Reset       : in std_logic;
		DataOut     : out std_logic
	);
end Oscilador;

architecture Behavioral of Oscilador is
component Registro
    generic (
        NBits : integer := 32 );
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
    MultiplexorOut <= (others => '0') when (Reset = '0') else
	          (RegistroOut + Incremento);
    DataOut <= RegistroOut(NBits - 1);
end Behavioral;
