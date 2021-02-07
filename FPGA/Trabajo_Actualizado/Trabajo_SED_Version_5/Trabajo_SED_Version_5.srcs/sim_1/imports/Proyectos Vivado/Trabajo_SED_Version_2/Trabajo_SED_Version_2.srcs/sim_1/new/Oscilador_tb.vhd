library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Oscilador_tb is
    generic (
		NBits : integer := 4
	);
end Oscilador_tb;

architecture Behavioral of Oscilador_tb is
component Oscilador
    port (
		Incremento : in std_logic_vector((NBits-1) downto 0);
		Clk         : in std_logic;
		Reset       : in std_logic;
		DataOut     : out std_logic
	);
end component;
signal Incremento : std_logic_vector((NBits - 1) downto 0) := "1110";
signal Clk : std_logic := '0';
signal Reset : std_logic := '0';
signal DataOut : std_logic;
constant CLK_period: time := 3.125 ns;
begin
Osc : Oscilador port map(
    Incremento => incremento,
    Clk => Clk,
    Reset => Reset,
    DataOut => DataOut);
    
    Clk <= not Clk after 0.5*CLK_period;
    Reset <= '1' after 40*CLK_period;

end Behavioral;
