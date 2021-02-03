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
    Generic(
            M_N_Bits : integer := 16
        );
    Port ( CLK100MHZ : in STD_LOGIC;
           SW0 : in STD_LOGIC;
           M_DATA : in STD_LOGIC;
           M_CLK : out STD_LOGIC;
           M_LRSEL : out STD_LOGIC;
           LED0 : out STD_LOGIC
           );
end top;

architecture Structural of top is
    signal CLK_MICROFONO : std_logic; --Señal para conectar la salida del freq ctrl y la entrada del audio recorder
    signal done_rec : std_logic; --Señal para conectar la salida done del audio recorder
    signal DATA_OUTPUT_rec : std_logic_vector(M_N_Bits-1 downto 0); --Señal para conectar la salida de datos del audio recorder
   --Generador reloj 2,4 MHz 
    component clk_freq_ctrl is
    Port ( CLK_IN : in STD_LOGIC;
           CLK_OUT : out STD_LOGIC
           );
end component;

   --Audio recorder
component audio_recorder is
    Generic(
    M_N_Bits : integer := 16
    );
    Port (
    --Puertos Microfono
    M_CLK : out std_logic; --reloj a 2.38 MHz
    M_LR : out std_logic; --si está a 0, los datos se leen en flanco de subida del reloj anterior
    M_DATA : in std_logic; --entrada de datos del micro a la FPGA
    
    M_CLK_IN : in std_logic; --Proviene del clk_freq_ctrl, hay que conectarlo a M_CLK
    ENABLE : in std_logic; --Activa la grabación
    DONE : out std_logic; --Indica que los datos ya se han deserializado
    DATA_OUTPUT : out std_logic_vector(M_N_Bits-1 downto 0); --Salida de datos deserializados
    LED : out std_logic
     );
end component;

begin
Inst_clk_freq_ctrl: clk_freq_ctrl PORT MAP (
    CLK_IN => CLK100MHZ, --Conectamos la entrada del freq_ctrl con el reloj de 100 MHz de la placa
    CLK_OUT => CLK_MICROFONO --Conectamos la salida del freq_ctrl con la señal clk_microfono
    );

Inst_audio_recorder: audio_recorder PORT MAP(
    M_CLK_IN => CLK_MICROFONO,
    M_CLK => M_CLK,
    M_LR => M_LRSEL,
    ENABLE => SW0, --El enable se controla con el switch 0
    DONE => done_rec,
    M_DATA => M_DATA,
    DATA_OUTPUT => DATA_OUTPUT_rec,
    LED => LED0
    );

end Structural;
