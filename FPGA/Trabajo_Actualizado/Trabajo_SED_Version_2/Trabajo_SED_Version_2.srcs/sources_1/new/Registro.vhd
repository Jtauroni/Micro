library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Registro is
    generic (
        NBits : integer := 32 --Tamaño que va a tener el registro
        );
    Port (
        Enable : in std_logic; --Entrada que habilita el registro
        Clk : in std_logic; --Señal de reloj
        D : in std_logic_vector((NBits - 1) downto 0); --Entrada D de los biestables del registro
        Q : out std_logic_vector((NBits - 1) downto 0) --Salida Q de los biestables del registro
        );
end Registro;

-- La idea es hacer un registro que sea capaz de almacenar N bits

architecture Behavioral of Registro is
signal DBus : std_logic_vector((NBits - 1) downto 0);
signal QBus : std_logic_vector((NBits - 1) downto 0);
signal PreDBus : std_logic_vector((NBits - 1) downto 0); 
begin
    process (Clk)
    begin
        if rising_edge(Clk) then --Cuando hay un flanco de subida del reloj la salida pasa a valer la entrada.
			QBus <= DBus;
		end if;
	end process;

	DBus <= PreDBus when (Enable = '1') else QBus; --El estado interno del biestable solo se actualiza si Enable está a 1
	PreDBus <= D;
	Q <= QBus;
end Behavioral;
