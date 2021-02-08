library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_XADC_tb is
end top_XADC_tb;

architecture Behavioral of top_XADC_tb is
component top_XADC is
    Port ( 
        CLK : in std_logic;
        Reset : in std_logic;
        vp_in : in std_logic;
        vn_in : in std_logic;
        dout : out std_logic_vector(15 downto 0);
        drdy : out std_logic;
        channel : out std_logic_vector(4 downto 0)
  );
end component;
--Señales auxiliares:
signal CLK : std_logic := '0';
signal Reset : std_logic := '0';
signal vp_in : std_logic;
signal vn_in : std_logic;

--Outputs
signal dout : std_logic_vector(15 downto 0);
signal drdy : std_logic;
signal channel : std_logic_vector(4 downto 0);

--Clock definitions
constant CLK_period : time := 10 ns;
begin
tbXADC: top_XADC port map(
    CLK => CLK, 
    Reset => Reset,
    vp_in => vp_in,
    vn_in => vn_in,
    dout => dout,
    drdy => drdy,
    channel => channel);
    
-- Clock process:
clk_process : process
begin
    clk <= '0';
    wait for CLK_period/2;
    clk <= '1';
    wait for CLK_period/2;
end process;

-- Stimulus process:
stim_proc : process
begin
    reset <= '1';
    wait for 5*CLK_period;
    
    reset <= '0';
    wait;
end process;

end Behavioral;
