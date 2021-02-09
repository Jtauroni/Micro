library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Multiplexor_tb is
generic (
        NBits : integer := 4
        );
end Multiplexor_tb;

architecture Behavioral of Multiplexor_tb is
component Multiplexor
    port (
		Sel : in std_logic;
		In0 : in std_logic_vector((NBits - 1) downto 0);
		In1 : in std_logic_vector((NBits - 1) downto 0);
		DataOut : out std_logic_vector((NBits - 1) downto 0)
	);  
end component;
signal Sel : std_logic := '0';
signal In0 : std_logic_vector((NBits - 1) downto 0) := "0110";
signal In1 : std_logic_vector((NBits - 1) downto 0) := "1001";
signal DataOut : std_logic_vector((NBits - 1) downto 0);
constant CLK_period: time := 3.125 ns;
begin
Mx : Multiplexor port map (Sel => Sel, In0 => In0, In1 => In1, DataOut => DataOut);

Sel <= '1' after 100*CLK_period;


end Behavioral;
