----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.02.2021 19:20:58
-- Design Name: 
-- Module Name: clk_freq_ctrl - Behavioral
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

entity clk_freq_ctrl is
    Generic (
    prescaler : integer := 42 --con 42 obtenemos 100/42=2.38 MHz
    );
    Port ( CLK_IN : in STD_LOGIC;
           CLK_OUT : out STD_LOGIC;
           RESET_CLK : in STD_LOGIC
           );
end clk_freq_ctrl;

architecture Behavioral of clk_freq_ctrl is
signal counter,divide : integer := 0;

begin

divide <= prescaler;

process(CLK_IN, RESET_CLK)
--Utilizamos un contador. Primero definimos la primera mitad del periodo a nivel bajo
--Una vez el contador llega a la mitad - 1 del periodo, comienza el nivel alto
--Cuando el contador llega a (en este caso) 42-1 flancos de subida del reloj original, se resetea el contador y se comienza de nuevo
begin
    if RESET_CLK = '1' then --Si se activa el reset, el reloj y el contador se ponen a 0
        CLK_OUT <= '0';
        counter <= 0;
    elsif( rising_edge(CLK_IN) ) then
        if(counter < divide/2-1) then
            counter <= counter + 1;
            CLK_OUT <= '0';
        elsif(counter < divide-1) then
            counter <= counter + 1;
            CLK_OUT <= '1';
        else
            CLK_OUT <= '0';
            counter <= 0;
        end if;
    end if;
end process;


end Behavioral;
