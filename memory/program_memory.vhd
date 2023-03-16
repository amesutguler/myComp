----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:40:01 02/07/2023 
-- Design Name: 
-- Module Name:    program_memory - Behavioral 
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

entity program_memory is
    Port ( address : in  STD_LOGIC_VECTOR (7 downto 0);
           clk : in  STD_LOGIC_VECTOR (0 downto 0);
           data_out : out  STD_LOGIC_VECTOR (7 downto 0));
end program_memory;

architecture Behavioral of program_memory is
	-- The instruction set
	constant LDA_IMM : std_logic_vector (7 downto 0) := x"86";
	constant LDA_DIR : std_logic_vector (7 downto 0) := x"87";
	constant LDB_IMM : std_logic_vector (7 downto 0) := x"88";
	constant LDB_DIR : std_logic_vector (7 downto 0) := x"89";
	constant STA_DIR : std_logic_vector (7 downto 0) := x"96";
	constant STB_DIR : std_logic_vector (7 downto 0) := x"97";
	constant ADD_AB : std_logic_vector (7 downto 0) := x"42";
	constant SUB_AB : std_logic_vector (7 downto 0) := x"43";
	constant AND_AB : std_logic_vector (7 downto 0) := x"44";
	constant OR_AB : std_logic_vector (7 downto 0) := x"45";
	constant INCA : std_logic_vector (7 downto 0) := x"46";
	constant INCB : std_logic_vector (7 downto 0) := x"47";
	constant DECA : std_logic_vector (7 downto 0) := x"48";
	constant DECB : std_logic_vector (7 downto 0) := x"49";
	constant BRA : std_logic_vector (7 downto 0) := x"20";
	constant BMI : std_logic_vector (7 downto 0) := x"21";
	constant BPL : std_logic_vector (7 downto 0) := x"22";
	constant BEQ : std_logic_vector (7 downto 0) := x"23";
	constant BNE : std_logic_vector (7 downto 0) := x"24";
	constant BVS : std_logic_vector (7 downto 0) := x"25";
	constant BVC : std_logic_vector (7 downto 0) := x"26";
	constant BCS : std_logic_vector (7 downto 0) := x"27";
	constant BCC : std_logic_vector (7 downto 0) := x"28";
	
	-- Defining the rom as an array 
	type rom_type is array (0 to 127) of std_logic_vector(7 downto 0);
	
	-- An example program here
	constant ROM : rom_type := ( 0 => LDA_IMM,
										  1 => x"AA",
										  2 => STA_DIR,
										  3 => x"E0",
										  4 => BRA,
										  5 => x"00",
										  others => x"00");
	-- Enable signal will be used to control if the adress is valid
	signal enable : std_logic;
	
begin
	-- Enable is '1' for valid address
	-- Valid addresses for ROM is are between 0 and 127
	process(enable)
	begin
		if( to_integer(unsigned(address)) <= 127 and
				to_integer(unsigned(address)) >= 0) then
			enable <= '1';
		else 
			enable <= '0';
		end if;
	end process;
	
	-- The data that is on the given address of ROM is written 
	-- onto data_out
	process(clk)
	begin
		if(clk'event and clk = '1') then
			if( enable = '1') then
				data_out <= ROM(to_integer(unsigned(address)));
			end if;
		end if;
	end process;


end Behavioral;

