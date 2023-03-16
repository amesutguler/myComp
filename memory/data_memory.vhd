----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    03:34:17 02/08/2023 
-- Design Name: 
-- Module Name:    data_memory - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity data_memory is
    Port ( data_in : in  STD_LOGIC_VECTOR (7 downto 0);
           address : in  STD_LOGIC_VECTOR (7 downto 0);
           data_out : out  STD_LOGIC_VECTOR (7 downto 0);
           clk : in  STD_LOGIC;
           wr : in  STD_LOGIC);
end data_memory;

architecture Behavioral of data_memory is

type ram_type is array (128 to 223) of std_logic_vector(7 downto 0);

signal RAM : ram_type := (others => '0');
signal enable : std_logic;

begin

	-- Enable is '1' for valid address
	-- Valid addresses for ROM is are between 128 and 223
	process(enable)
	begin
		if( to_integer(unsigned(address)) <= 223 and
				to_integer(unsigned(address)) >= 128) then
			enable <= '1';
		else 
			enable <= '0';
		end if;
	end process;

	process(clk)
	begin
		if(clk'event and clk = '1') then
			-- writing mode
			if(wr = '1' and enable = '1') then 
				RAM(to_integer(unsigned(address))) 
					<= data_in;
			-- reading mode
			elsif( wr = '0' and enable = '1') then
				data_out <=
					RAM(to_integer(unsigned(address)));
			end if;
		end if;
	end process;
end Behavioral;

