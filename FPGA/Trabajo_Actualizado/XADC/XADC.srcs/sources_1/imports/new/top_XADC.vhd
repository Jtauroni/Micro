library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_XADC is
  Port ( 
        CLK : in std_logic;
        Reset : in std_logic;
        vp_in : in std_logic;
        vn_in : in std_logic;
        dout : out std_logic_vector(15 downto 0);
        drdy : out std_logic;
        channel : out std_logic_vector(4 downto 0)
  );
end top_XADC;

architecture Behavioral of top_XADC is
COMPONENT xadc_wiz_0
  PORT (
    di_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    daddr_in : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    den_in : IN STD_LOGIC;
    dwe_in : IN STD_LOGIC;
    drdy_out : OUT STD_LOGIC;
    do_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    dclk_in : IN STD_LOGIC;
    reset_in : IN STD_LOGIC;
    vp_in : IN STD_LOGIC;
    vn_in : IN STD_LOGIC;
    channel_out : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    eoc_out : OUT STD_LOGIC;
    alarm_out : OUT STD_LOGIC;
    eos_out : OUT STD_LOGIC;
    busy_out : OUT STD_LOGIC
  );
END COMPONENT;

--Señales auxiliares:
signal aux_dout : std_logic_vector(15 downto 0);
signal aux_channel : std_logic_vector(4 downto 0);
signal aux_eoc : std_logic;
signal aux_daddr : std_logic_vector(6 downto 0);
begin

ADC : xadc_wiz_0
  PORT MAP (
    di_in => (others => '0'),
    daddr_in => aux_daddr,
    den_in => aux_eoc,
    dwe_in => '0',
    drdy_out => drdy,
    do_out => aux_dout,
    dclk_in => clk,
    reset_in => reset,
    vp_in => vp_in,
    vn_in => vn_in,
    channel_out => aux_channel,
    eoc_out => aux_eoc,
    alarm_out => open,
    eos_out => open,
    busy_out => open
  );

aux_daddr <= "00" & aux_channel;
channel <= aux_channel;
dout <= aux_dout;
end Behavioral;
