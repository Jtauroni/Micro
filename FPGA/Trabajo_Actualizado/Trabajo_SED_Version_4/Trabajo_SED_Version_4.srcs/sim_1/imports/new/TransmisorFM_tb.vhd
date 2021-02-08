library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TransmisorFM_tb is
end TransmisorFM_tb;

architecture Behavioral of TransmisorFM_tb is
component TransmisorFM
    port (
		Clk         : in std_logic;
		Reset       : in std_logic;
		sw : in std_logic_vector (11 downto 0);
		AntOut      : out std_logic
	);
end component;
signal Clk: std_logic := '0';
signal Reset: std_logic := '0';
signal sw: std_logic_vector(11 downto 0);
signal AntOut: std_logic;
constant CLK_period: time := 3.125ns;
begin
FMT: TransmisorFM port map(Clk => Clk, Reset => Reset, sw => sw, AntOut => AntOut);
    
    Clk <= not Clk after 0.5*CLK_period;
    Reset <= '1' after 30*CLK_period;
    sw(0) <= '0' after 80*CLK_period;
    sw(1) <= '0' after 80*CLK_period;
    sw(2) <= '0' after 80*CLK_period;
    sw(3) <= '0' after 80*CLK_period;
    sw(4) <= '0' after 80*CLK_period;
    sw(5) <= '0' after 80*CLK_period;
    sw(6) <= '0' after 80*CLK_period;
    sw(7) <= '0' after 80*CLK_period;
    sw(8) <= '0' after 80*CLK_period;
    sw(9) <= '1' after 80*CLK_period;
    sw(10) <= '0' after 80*CLK_period;
    sw(11) <= '0' after 80*CLK_period;
    

end Behavioral;
