library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TransmisorFM_tb is
end TransmisorFM_tb;

architecture Behavioral of TransmisorFM_tb is
component TransmisorFM
    port (
		Clk         : in std_logic;
		Reset       : in std_logic;
		Boton440   : in std_logic; --Boton 440
		Boton880   : in std_logic; --Boton 880
		AntOut      : out std_logic
	);
end component;
signal Clk: std_logic := '0';
signal Reset: std_logic := '1';
signal Boton440, Boton880: std_logic;
signal AntOut: std_logic;
constant CLK_period: time := 3.125ns;
begin
FMT: TransmisorFM port map(Clk => Clk, Reset => Reset, Boton440 => Boton440, Boton880 => Boton880, AntOut => AntOut);
    
    Clk <= not Clk after 0.5*CLK_period;
    Reset <= '0' after 30*CLK_period;
    Boton440 <= '1' after 80*CLK_period;
    Boton880 <= '1' after 80*CLK_period;

end Behavioral;
