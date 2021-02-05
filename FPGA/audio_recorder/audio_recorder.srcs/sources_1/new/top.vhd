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
           LED0 : out STD_LOGIC;
           RESET : in STD_LOGIC; --Conectado al BTNR;
           device_temp_i : in std_logic_vector(11 downto 0);
           
           --Perifericos
        btn_u                : in    std_logic; 
        -- DDR2 interface
        ddr2_addr            : out   std_logic_vector(12 downto 0);
        ddr2_ba              : out   std_logic_vector(2 downto 0);
        ddr2_ras_n           : out   std_logic;
        ddr2_cas_n           : out   std_logic;
        ddr2_we_n            : out   std_logic;
        ddr2_ck_p            : out   std_logic_vector(0 downto 0);
        ddr2_ck_n            : out   std_logic_vector(0 downto 0);
        ddr2_cke             : out   std_logic_vector(0 downto 0);
        ddr2_cs_n            : out   std_logic_vector(0 downto 0);
        ddr2_dm              : out   std_logic_vector(1 downto 0);
        ddr2_odt             : out   std_logic_vector(0 downto 0);
        ddr2_dq              : inout std_logic_vector(15 downto 0);
        ddr2_dqs_p           : inout std_logic_vector(1 downto 0);
        ddr2_dqs_n           : inout std_logic_vector(1 downto 0)
           );
end top;

architecture Structural of top is
   --Generador reloj 2,4 MHz 
    component clk_freq_ctrl is
    Port ( CLK_IN : in STD_LOGIC;
           CLK_OUT : out STD_LOGIC;
           RESET_CLK : in STD_LOGIC
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
    M_DATA : in std_logic; --entrada de datos del microfono a la FPGA
    
    M_CLK_IN : in std_logic; --Proviene del clk_freq_ctrl, hay que conectarlo a M_CLK
    ENABLE : in std_logic; --Activa la grabación
    DONE : out std_logic; --Indica que los datos ya se han deserializado
    DATA_OUTPUT : out std_logic_vector(M_N_Bits-1 downto 0); --Salida de datos deserializados
    RESET_REC : in std_logic;
    LED : out std_logic
     );
end component;

--ClockWizard comp
component clk_wiz_0
port
 (-- Clock in ports
  -- Clock out ports
  clk_out1          : out    std_logic;
  -- Status and control signals
  reset             : in     std_logic;
  CLK100MHZ           : in     std_logic
 );
end component;

--RAM Controller component
component RamCntrl is
generic (
   -- read/write cycle (ns)
   C_RW_CYCLE_NS  : integer := 100
);
port (
   -- Control interface
   clk_i          : in  std_logic; -- 100 MHz system clock
   rst_i          : in  std_logic; -- active high system reset
   rnw_i          : in  std_logic; -- read/write
   be_i           : in  std_logic_vector(3 downto 0); -- byte enable
   addr_i         : in  std_logic_vector(31 downto 0); -- address input
   data_i         : in  std_logic_vector(31 downto 0); -- data input
   cs_i           : in  std_logic; -- active high chip select
   data_o         : out std_logic_vector(31 downto 0); -- data output
   rd_ack_o       : out std_logic; -- read acknowledge flag
   wr_ack_o       : out std_logic; -- write acknowledge flag
   
   -- RAM Memory signals
   Mem_A    : out std_logic_vector(26 downto 0); -- Address
   Mem_DQ_O : out std_logic_vector(15 downto 0); -- Data Out
   Mem_DQ_I : in  std_logic_vector(15 downto 0); -- Data In
   Mem_DQ_T : out std_logic_vector(15 downto 0); -- Data Tristate Enable, used for a bidirectional data bus only
   Mem_CEN  : out std_logic; -- Chip Enable
   Mem_OEN  : out std_logic; -- Output Enable
   Mem_WEN  : out std_logic; -- Write Enable
   Mem_UB   : out std_logic; -- Upper Byte
   Mem_LB   : out std_logic -- Lower Byte 
   );
end component;

-- RAM to DDR interface and DDR Controller
component Ram2Ddr is
port (
   -- Common
   clk_200MHz_i   : in    std_logic; -- 200 MHz system clock
   rst_i          : in    std_logic; -- active high system reset
   device_temp_i  : in    std_logic_vector(11 downto 0);
   ui_clk_o       : out   std_logic;
    
   -- RAM interface
   ram_a          : in    std_logic_vector(26 downto 0);
   ram_dq_i       : in    std_logic_vector(15 downto 0);
   ram_dq_o       : out   std_logic_vector(15 downto 0);
   ram_cen        : in    std_logic;
   ram_oen        : in    std_logic;
   ram_wen        : in    std_logic;
   ram_ub         : in    std_logic;
   ram_lb         : in    std_logic;
   
   -- DDR2 interface
   ddr2_addr      : out   std_logic_vector(12 downto 0);
   ddr2_ba        : out   std_logic_vector(2 downto 0);
   ddr2_ras_n     : out   std_logic;
   ddr2_cas_n     : out   std_logic;
   ddr2_we_n      : out   std_logic;
   ddr2_ck_p      : out   std_logic_vector(0 downto 0);
   ddr2_ck_n      : out   std_logic_vector(0 downto 0);
   ddr2_cke       : out   std_logic_vector(0 downto 0);
   ddr2_cs_n      : out   std_logic_vector(0 downto 0);
   ddr2_dm        : out   std_logic_vector(1 downto 0);
   ddr2_odt       : out   std_logic_vector(0 downto 0);
   ddr2_dq        : inout std_logic_vector(15 downto 0);
   ddr2_dqs_p     : inout std_logic_vector(1 downto 0);
   ddr2_dqs_n     : inout std_logic_vector(1 downto 0));
end component;


--Constant declarations
constant RW_CYCLE_NS          : integer := 1200;
constant SECONDS_TO_RECORD    : integer := 5;
constant PDM_FREQ_HZ          : integer := 2000000;
constant SYS_CLK_FREQ_MHZ     : integer := 100;
constant NR_OF_BITS           : integer := 16;
constant NR_SAMPLES_TO_REC    : integer := (((SECONDS_TO_RECORD*PDM_FREQ_HZ)/NR_OF_BITS) - 1);

-- Local Type Declarations
type state_type is (stIdle, stRecord, stInter, stPlayback);

-- Signal Declarations
signal state, next_state : state_type;

-- common
signal btnu_int         : std_logic;
signal rnw_int          : std_logic;
signal addr_int         : std_logic_vector(31 downto 0);
signal done_int         : std_logic;
signal pwm_audio_o_int  : std_logic;
signal ui_clk           : std_logic;
signal CLK_MICROFONO : std_logic; --Señal para conectar la salida del freq ctrl y la entrada del audio recorder
signal CLK200MHZ : std_logic; --Para conectar salida del clock wiz con el ddr to sram
signal clk_i : std_logic;

-- record
signal en_des           : std_logic;
signal done_des         : std_logic;
signal done_async_des   : std_logic;
signal data_des         : std_logic_vector((M_N_Bits-1) downto 0) := (others => '0');
signal data_dess        : std_logic_vector(31 downto 0) := (others => '0');
signal addr_rec         : std_logic_vector(31 downto 0) := (others => '0');
signal cntRecSamples    : integer := 0;
signal done_des_dly     : std_logic;

-- playback
signal en_ser           : std_logic;
signal done_ser         : std_logic;
signal rd_ack_int       : std_logic;
signal data_ser         : std_logic_vector(31 downto 0);
signal data_serr        : std_logic_vector(15 downto 0);
signal done_async_ser   : std_logic;
signal addr_play        : std_logic_vector(31 downto 0) := (others => '0');
signal cntPlaySamples   : integer := 0;
signal done_ser_dly     : std_logic;

-- memory interconnection signals
signal mem_a            : std_logic_vector(26 downto 0);
signal mem_a_int        : std_logic_vector(26 downto 0);
signal mem_dq_i         : std_logic_vector(15 downto 0);
signal mem_dq_o         : std_logic_vector(15 downto 0);
signal mem_cen          : std_logic;
signal mem_oen          : std_logic;
signal mem_wen          : std_logic;
signal mem_ub           : std_logic;
signal mem_lb           : std_logic;


begin

clk_i <= CLK100MHZ;
clk_i <= ui_clk;

Inst_clk_freq_ctrl: clk_freq_ctrl PORT MAP (
    CLK_IN => CLK100MHZ, --Conectamos la entrada del freq_ctrl con el reloj de 100 MHz de la placa
    CLK_OUT => CLK_MICROFONO, --Conectamos la salida del freq_ctrl con la señal clk_microfono
    RESET_CLK => RESET
    );

Inst_audio_recorder: audio_recorder PORT MAP(
    M_CLK_IN => CLK_MICROFONO,
    M_CLK => M_CLK,
    M_LR => M_LRSEL,
    ENABLE => SW0, --El enable se controla con el switch 0
    DONE => done_async_des,
    M_DATA => M_DATA,
    DATA_OUTPUT => data_des,
    LED => LED0,
    RESET_REC => RESET
    );

Inst_CLK_WIZ : clk_wiz_0
   port map ( 
  -- Clock out ports  
   clk_out1 => CLK200MHZ,
  -- Status and control signals                
   reset => RESET,
   -- Clock in ports
   CLK100MHZ => CLK100MHZ
 );
 
 InstRAM: RamCntrl
   generic map (
      C_RW_CYCLE_NS        => RW_CYCLE_NS)
   port map (
      clk_i                => CLK100MHZ,
      rst_i                => reset,
      rnw_i                => rnw_int,
      be_i                 => "0011", -- 16-bit access
      addr_i               => addr_int,
      data_i               => data_dess,
      cs_i                 => done_int,
      data_o               => data_ser,
      rd_ack_o             => rd_ack_int,
      wr_ack_o             => open,
      -- RAM Memory signals
      Mem_A                => mem_a,
      Mem_DQ_O             => mem_dq_i,
      Mem_DQ_I             => mem_dq_o,
      Mem_DQ_T             => open,
      Mem_CEN              => mem_cen,
      Mem_OEN              => mem_oen,
      Mem_WEN              => mem_wen,
      Mem_UB               => mem_ub,
      Mem_LB               => mem_lb
      );
      
   Inst_Ram2Ddr: Ram2Ddr
   port map (
      clk_200MHz_i         => clk200MHZ,
      rst_i                => reset,
      device_temp_i        => device_temp_i,
      ui_clk_o             => ui_clk,
      -- RAM interface
      ram_a                => mem_a,
      ram_dq_i             => mem_dq_i,
      ram_dq_o             => mem_dq_o,
      ram_cen              => mem_cen,
      ram_oen              => mem_oen,
      ram_wen              => mem_wen,
      ram_ub               => mem_ub,
      ram_lb               => mem_lb,
      -- DDR2 interface
      ddr2_addr            => ddr2_addr,
      ddr2_ba              => ddr2_ba,
      ddr2_ras_n           => ddr2_ras_n,
      ddr2_cas_n           => ddr2_cas_n,
      ddr2_we_n            => ddr2_we_n,
      ddr2_ck_p            => ddr2_ck_p,
      ddr2_ck_n            => ddr2_ck_n,
      ddr2_cke             => ddr2_cke,
      ddr2_cs_n            => ddr2_cs_n,
      ddr2_dm              => ddr2_dm,
      ddr2_odt             => ddr2_odt,
      ddr2_dq              => ddr2_dq,
      ddr2_dqs_p           => ddr2_dqs_p,
      ddr2_dqs_n           => ddr2_dqs_n
      );
      
   done_int <= done_des when state = stRecord else
               done_ser when state = stPlayback else '0';
               
end Structural;
