----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:47:08 02/11/2023 
-- Design Name: 
-- Module Name:    memory - Behavioral 
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

entity memory is
    Port ( -- inputs
			  address : in  STD_LOGIC_VECTOR (7 downto 0);
           data_in : in  STD_LOGIC_VECTOR (7 downto 0);
           wr_en : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           clock : in  STD_LOGIC;
			  
			  port_in_00 : in  STD_LOGIC_VECTOR (7 downto 0);
			  port_in_01 : in  STD_LOGIC_VECTOR (7 downto 0);
			  port_in_02 : in  STD_LOGIC_VECTOR (7 downto 0);
			  port_in_03 : in  STD_LOGIC_VECTOR (7 downto 0);
			  port_in_04 : in  STD_LOGIC_VECTOR (7 downto 0);
			  port_in_05 : in  STD_LOGIC_VECTOR (7 downto 0);
			  port_in_06 : in  STD_LOGIC_VECTOR (7 downto 0);
			  port_in_07 : in  STD_LOGIC_VECTOR (7 downto 0);
			  port_in_08 : in  STD_LOGIC_VECTOR (7 downto 0);
			  port_in_09 : in  STD_LOGIC_VECTOR (7 downto 0);
			  port_in_10 : in  STD_LOGIC_VECTOR (7 downto 0);
			  port_in_11 : in  STD_LOGIC_VECTOR (7 downto 0);
			  port_in_12 : in  STD_LOGIC_VECTOR (7 downto 0);
			  port_in_13 : in  STD_LOGIC_VECTOR (7 downto 0);
			  port_in_14 : in  STD_LOGIC_VECTOR (7 downto 0);
			  port_in_15 : in  STD_LOGIC_VECTOR (7 downto 0);
			  
			  -- outputs
			  data_out : out  STD_LOGIC_VECTOR (7 downto 0);
			  port_out_00 : out  STD_LOGIC_VECTOR (7 downto 0);
			  port_out_01 : out  STD_LOGIC_VECTOR (7 downto 0);
			  port_out_02 : out  STD_LOGIC_VECTOR (7 downto 0);
			  port_out_03 : out  STD_LOGIC_VECTOR (7 downto 0);
			  port_out_04 : out  STD_LOGIC_VECTOR (7 downto 0);
			  port_out_05 : out  STD_LOGIC_VECTOR (7 downto 0);
			  port_out_06 : out  STD_LOGIC_VECTOR (7 downto 0);
			  port_out_07 : out  STD_LOGIC_VECTOR (7 downto 0);
			  port_out_08 : out  STD_LOGIC_VECTOR (7 downto 0);
			  port_out_09 : out  STD_LOGIC_VECTOR (7 downto 0);
			  port_out_10 : out  STD_LOGIC_VECTOR (7 downto 0);
			  port_out_11 : out  STD_LOGIC_VECTOR (7 downto 0);
			  port_out_12 : out  STD_LOGIC_VECTOR (7 downto 0);
			  port_out_13 : out  STD_LOGIC_VECTOR (7 downto 0);
			  port_out_14 : out  STD_LOGIC_VECTOR (7 downto 0);
			  port_out_15 : out  STD_LOGIC_VECTOR (7 downto 0));
			  
			  
end memory;


architecture Behavioral of memory is
	
	-- RAM
	COMPONENT data_memory
		PORT(
			data_in : IN std_logic_vector(7 downto 0);
			address : IN std_logic_vector(7 downto 0);
			clk : IN std_logic;
			wr : IN std_logic;          
			data_out : OUT std_logic_vector(7 downto 0)
			);
	END COMPONENT;
	
	
	-- ROM
	COMPONENT program_memory
		PORT(
			address : IN std_logic_vector(7 downto 0);
			clk : IN std_logic_vector(0 to 0);          
			data_out : OUT std_logic_vector(7 downto 0)
			);
	END COMPONENT;
	
	
	-- Output port 
	COMPONENT output_ports
		PORT(
			address : IN std_logic_vector(7 downto 0);
			data_in : IN std_logic_vector(7 downto 0);
			wr_en : IN std_logic;
			clk : IN std_logic;
			reset : IN std_logic;          
			port_out_00 : OUT std_logic_vector(7 downto 0);
			port_out_01 : OUT std_logic_vector(7 downto 0);
			port_out_02 : OUT std_logic_vector(7 downto 0);
			port_out_03 : OUT std_logic_vector(7 downto 0);
			port_out_04 : OUT std_logic_vector(7 downto 0);
			port_out_05 : OUT std_logic_vector(7 downto 0);
			port_out_06 : OUT std_logic_vector(7 downto 0);
			port_out_07 : OUT std_logic_vector(7 downto 0);
			port_out_08 : OUT std_logic_vector(7 downto 0);
			port_out_09 : OUT std_logic_vector(7 downto 0);
			port_out_10 : OUT std_logic_vector(7 downto 0);
			port_out_11 : OUT std_logic_vector(7 downto 0);
			port_out_12 : OUT std_logic_vector(7 downto 0);
			port_out_13 : OUT std_logic_vector(7 downto 0);
			port_out_14 : OUT std_logic_vector(7 downto 0);
			port_out_15 : OUT std_logic_vector(7 downto 0)
			);
	END COMPONENT;

-- MUX CONNECTIONS
	signal ram_out, rom_out : std_logic_vector(7 downto 0);

begin
	--RAM
	data_memory: data_memory PORT MAP(
			data_in => data_in ,
			address => address,
			data_out => ram_out,
			clk => clk,
			wr => wr_en
		);
	
	
	output_ports: output_ports PORT MAP(
		address => address ,
		data_in => data_in,
		wr_en => wr_en,
		clk => clk,
		reset => reset,
		port_out_00 => port_out_00,
		port_out_01 => port_out_01,
		port_out_02 => port_out_02,
		port_out_03 => port_out_03,
		port_out_04 => port_out_04,
		port_out_05 => port_out_05,
		port_out_06 => port_out_06,
		port_out_07 => port_out_07,
		port_out_08 => port_out_08,
		port_out_09 => port_out_09,
		port_out_10 => port_out_10,
		port_out_11 => port_out_11,
		port_out_12 => port_out_12,
		port_out_13 => port_out_13,
		port_out_14 => port_out_14,
		port_out_15 => port_out_15
	);
	
	-- ROM
	program_memory: program_memory PORT MAP(
		address => address,
		clk => clk,
		data_out = rom_out 
	);
	
	-- data_out MUX
	process(address, rom_out, ram_out,
				port_in_00, port_in_01, port_in_02, port_in_03,
				port_in_04, port_in_05, port_in_06, port_in_07,
				port_in_08, port_in_09, port_in_10, port_in_11,
				port_in_12, port_in_13, port_in_14, port_in_15)
	begin
		if (address >= x"00" and address <= x"7F") then
			data_out <= rom_out;
			
		elsif( address >= x"80" and address <= x"DF") then
			data_out <= ram_out;
			
		elsif( address = x"F0") then
			data_out <= port_in_00;
			
		elsif( address = x"F1") then
			data_out <= port_in_01;
			
		elsif( address = x"F2") then
			data_out <= port_in_02;
			
		elsif( address = x"F3") then
			data_out <= port_in_03;
			
		elsif( address = x"F4") then
			data_out <= port_in_04;
			
		elsif( address = x"F5") then
			data_out <= port_in_05;
			
		elsif( address = x"F6") then
			data_out <= port_in_06;
			
		elsif( address = x"F7") then
			data_out <= port_in_07;
			
		elsif( address = x"F8") then
			data_out <= port_in_08;
			
		elsif( address = x"F9") then
			data_out <= port_in_09;
			
		elsif( address = x"FA") then
			data_out <= port_in_10;
			
		elsif( address = x"FB") then
			data_out <= port_in_11;
			
		elsif( address = x"FC") then
			data_out <= port_in_12;
			
		elsif( address = x"FD") then
			data_out <= port_in_13;
			
		elsif( address = x"FE") then
			data_out <= port_in_14;
			
		elsif( address = x"FF") then
			data_out <= port_in_15;
		
		else 
			data_out <= (others => '0');
		
		end if;
	end process;
	
end Behavioral;

