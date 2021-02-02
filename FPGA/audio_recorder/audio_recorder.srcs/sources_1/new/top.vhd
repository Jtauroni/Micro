----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.02.2021 19:51:23
-- Design Name: 
-- Module Name: top - Structural
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    Port ( CLK100MHZ : in STD_LOGIC);
end top;

architecture Structural of top is
    signal CLK_MICROFONO : std_logic;
    
    component clk_freq_ctrl is
    Port ( CLK_IN : in STD_LOGIC;
           CLK_OUT : out STD_LOGIC
           );
end component;

begin
Inst_clk_freq_ctrl: clk_freq_ctrl PORT MAP (
CLK_IN => CLK100MHZ,
CLK_OUT => CLK_MICROFONO
);

end Structural;
