library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TransmisorFM_tb is
end TransmisorFM_tb;

architecture Behavioral of TransmisorFM_tb is
component TransmisorFM
    port (
		Clk : in std_logic;
        Reset : in std_logic;
        vp_in : in std_logic;
        vn_in : in std_logic;
        AntOut : out std_logic
	);
end component;
signal Clk: std_logic := '0';
signal Reset: std_logic := '0';
signal vp_in, vn_in : std_logic;
signal AntOut: std_logic;
constant CLK_period: time := 3.125ns;
begin
FMT: TransmisorFM port map(Clk => Clk, Reset => Reset, vp_in => vp_in, vn_in => vn_in, AntOut => AntOut);
    
    Clk <= not Clk after 0.5*CLK_period;
    Reset <= '1' after 30*CLK_period;
    vp_in <= '0' after 80*CLK_period;
    vn_in <= '0' after 80*CLK_period;

end Behavioral;
