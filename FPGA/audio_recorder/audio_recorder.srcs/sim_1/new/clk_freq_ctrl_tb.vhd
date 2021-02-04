LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY clk_freq_ctrl_tb IS
  END clk_freq_ctrl_tb;

  ARCHITECTURE behavior OF clk_freq_ctrl_tb IS

    signal CLK_IN,CLK_OUT, RESET_CLK :  std_logic;
    constant clk_period : time := 10 ns;
    
    component clk_freq_ctrl is
    Generic (
    prescaler : integer := 42
    );
    Port ( CLK_IN : in STD_LOGIC;
           CLK_OUT : out STD_LOGIC;
           RESET_CLK : in STD_LOGIC
           );
end component;
    
    begin
  -- Component Instantiation
          uut:  clk_freq_ctrl PORT MAP(
                  CLK_IN => CLK_IN,
                  CLK_OUT => CLK_OUT,
                  RESET_CLK => RESET_CLK
                );
    reset_process : process
    begin
    RESET_CLK <= '1';
    wait for clk_period*12;
    RESET_CLK <= '0';
    wait;
    end process;
    clk_process :process  --generates a 100 MHz clock.
   begin
        CLK_IN <= '0';
        wait for clk_period/2;  --for 5 ns signal is '0'.
        CLK_IN <= '1';
        wait for clk_period/2;  --for next 5 ns signal is '1'.
   end process;


end Behavior;
