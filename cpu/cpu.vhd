library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;


entity cpu is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           from_memory : in  STD_LOGIC_VECTOR (7 downto 0);
			  -- outputs
			  write_en : out  STD_LOGIC;
           to_memory : out  STD_LOGIC_VECTOR (7 downto 0);
           address : out  STD_LOGIC_VECTOR (7 downto 0));
end cpu;

architecture Behavioral of cpu is

	COMPONENT control_unit
		PORT(
			clk : IN std_logic;
			reset : IN std_logic;
			IR : IN std_logic_vector(7 downto 0);
			CCR_result : IN std_logic_vector(3 downto 0);          
			IR_load : OUT std_logic;
			MAR_load : OUT std_logic;
			PC_load : OUT std_logic;
			PC_inc : OUT std_logic;
			A_load : OUT std_logic;
			B_load : OUT std_logic;
			ALU_sel : OUT std_logic_vector(2 downto 0);
			CCR_load : OUT std_logic;
			BUS1_sel : OUT std_logic_vector(1 downto 0);
			BUS2_sel : OUT std_logic_vector(1 downto 0);
			write_en : OUT std_logic
			);
	END COMPONENT;
	
	COMPONENT data_path
		PORT(
			clk : IN std_logic;
			reset : IN std_logic;
			IR_load : IN std_logic;
			MAR_load : IN std_logic;
			PC_load : IN std_logic;
			PC_inc : IN std_logic;
			A_load : IN std_logic;
			B_load : IN std_logic;
			ALU_sel : IN std_logic_vector(2 downto 0);
			CCR_load : IN std_logic;
			BUS1_sel : IN std_logic_vector(1 downto 0);
			BUS2_sel : IN std_logic_vector(1 downto 0);
			from_memory : IN std_logic_vector(7 downto 0);          
			IR : OUT std_logic_vector(7 downto 0);
			address : OUT std_logic_vector(7 downto 0);
			CCR_result : OUT std_logic_vector(3 downto 0);
			to_memory : OUT std_logic_vector(7 downto 0)
			);
	END COMPONENT;
	
	-- connection signals
	signal IR_load : std_logic;
	signal MAR_load : std_logic;
	signal PC_load : std_logic;
	signal PC_inc : std_logic;
	signal A_load : std_logic;
	signal B_load : std_logic;
	signal CCR_load : std_logic;
	signal BUS1_sel : std_logic_vector(1 downto 0);
	signal BUS2_sel : std_logic_vector(1 downto 0);
	signal ALU_sel : std_logic_vector(2 downto 0);
	signal IR : std_logic_vector(7 downto 0);
	signal CCR_result : std_logic_vector(3 downto 0);
	
begin
	CONTROL_UNIT_uniq: control_unit PORT MAP(
		clk => clk,
		reset => reset,
		IR => IR,
		CCR_result => CCR_result ,
		IR_load => IR_load,
		MAR_load => MAR_load,
		PC_load => PC_load,
		PC_inc => PC_inc,
		A_load => A_load,
		B_load => B_load,
		ALU_sel => ALU_sel,
		CCR_load => CCR_load,
		BUS1_sel => BUS1_sel,
		BUS2_sel => BUS2_sel,
		write_en => write_en
	);

	DATA_PATH_uniq: data_path PORT MAP(
		clk => clk,
		reset => reset,
		IR_load => IR_load,
		MAR_load => MAR_load,
		PC_load => PC_load,
		PC_inc => PC_inc,
		A_load => A_load,
		B_load => B_load,
		ALU_sel => ALU_sel,
		CCR_load => CCR_load,
		BUS1_sel => bus1_sel,
		BUS2_sel => bus2_sel,
		from_memory => from_memory,
		IR => IR,
		address => address,
		CCR_result => CCR_result,
		to_memory => to_memory
	);
end Behavioral;

