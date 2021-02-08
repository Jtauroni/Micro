library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Multiplexor is
    generic (
		NBits : integer := 32
	);
    port (
		Sel     : in std_logic;
		In0 : in std_logic_vector((NBits - 1) downto 0);
		In1 : in std_logic_vector((NBits - 1) downto 0);
		DataOut : out std_logic_vector((NBits - 1) downto 0)
	);   
end Multiplexor;

architecture Behavioral of Multiplexor is
begin
    DataOut <= In0 when (Sel = '0') else
	           In1;
end Behavioral;
