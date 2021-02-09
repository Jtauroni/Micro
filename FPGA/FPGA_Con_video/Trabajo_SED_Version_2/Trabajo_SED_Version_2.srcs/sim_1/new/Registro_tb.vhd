library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Registro_tb is
generic (
        NBits : integer := 4
        );
end Registro_tb;

architecture Behavioral of Registro_tb is
component Registro
    port (
        Enable : in std_logic;
        Clk : in std_logic;
        D : in std_logic_vector((NBits - 1) downto 0);
        Q : out std_logic_vector((NBits - 1) downto 0)
        );
end component;
signal Enable : std_logic := '0';
signal Clk : std_logic := '0';
signal D : std_logic_vector((NBits - 1) downto 0) := (others => '0');
signal Q : std_logic_vector((NBits - 1) downto 0) := (others => '0');
constant CLK_period: time := 3.125 ns;
begin
Reg : Registro port map(Enable => Enable, Clk => Clk, D => D, Q => Q);
process (Clk)
begin
    Clk <= not Clk after 0.5*CLK_period;
    Enable <= '1' after 10*CLK_period;
    D <= "0110" after 5*CLK_period;
end process;
end Behavioral;
