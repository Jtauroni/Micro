----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.02.2021 18:26:44
-- Design Name: 
-- Module Name: audio_recorder - Behavioral
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

entity audio_recorder is
    Generic(
    M_N_Bits : integer := 16
    );
    Port (
    --Puertos Microfono
    M_CLK : out std_logic; --reloj a 2.38 MHz
    M_LR : out std_logic; --si está a 0, los datos se leen en flanco de subida del reloj anterior
    M_DATA : in std_logic; --entrada de datos del micro a la FPGA
    
    CLK_IN : in std_logic; --Proviene del clk_freq_ctrl, hay que conectarlo a M_CLK
    ENABLE : in std_logic; --Activa la grabación
    DONE : out std_logic; --Indica que los datos ya se han deserializado
    DATA_OUTPUT : out std_logic_vector(M_N_Bits-1 downto 0) --Salida de datos deserializados
     );
end audio_recorder;
--Los datos salen del micro en formato PDM, hay que deserializarlo en muestras de N bits
architecture Behavioral of audio_recorder is

--Registro de desplazamiento para deserializar los datos que entran desde el micro
signal pdm_reg : std_logic_vector(M_N_Bits-1 downto 0);
--Contador del número de bits
signal count_bits : integer range 0 to (M_N_Bits-1) := 0;

begin
M_LR <= '0'; --L/R a 0 para leer en flanco de subida
M_CLK <= CLK_IN;
--Proceso de sampleo mediante registro de desplazamiento, los datos entran por la derecha.
 SAMPLING: process(CLK_IN) 
   begin 
      if rising_edge(CLK_IN) then
         if ENABLE = '1'  then 
            pdm_reg <= pdm_reg(M_N_Bits-2 downto 0) & M_DATA;
         end if; 
      end if;
   end process SAMPLING;
   
   -- Contar número de bits de datos contados, resetea al llegar a N-1. Cada grupo de N-1 bits es una muestra.
   CNT_bits: process(CLK_IN) begin
      if rising_edge(CLK_IN) then
         if ENABLE = '1' then
            if count_bits = (M_N_Bits-1) then
               count_bits <= 0;
            else
               count_bits <= count_bits + 1;
            end if;
         end if;
      end if;
   end process CNT_bits;
   
   --Generar señal done, indicando muestra sampleada. Carga el valor del reg temporal en DATA_Output
   process(CLK_IN) 
   begin
      if rising_edge(CLK_IN) then
         if ENABLE = '1' then
            if count_bits = (M_N_Bits-1) then
               DONE <= '1';
               DATA_OUTPUT <= pdm_reg;
            end if;
         else
            DONE <= '0';
         end if;
      end if;
   end process;
end Behavioral;
