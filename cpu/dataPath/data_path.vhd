library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;


entity data_path is
	port( clk, reset : in std_logic;
			IR_load : in std_logic;
			MAR_load : in std_logic;
			PC_load : in std_logic;
			PC_inc : in std_logic;
			A_load : in std_logic;
			B_load : in std_logic;
			ALU_sel : in std_logic_vector(2 downto 0);
			CCR_load : in std_logic;
			BUS1_sel : in std_logic_vector(1 downto 0);
			BUS2_sel : in std_logic_vector(1 downto 0);
			from_memory : in std_logic_vector(7 downto 0);
			-- outputs
			IR: out std_logic_vector(7 downto 0);
			address : out std_logic_vector(7 downto 0);
		   CCR_result : out std_logic_vector(3 downto 0);
			to_memory : out std_logic_vector(7 downto 0)
			);


end data_path;

architecture Behavioral of data_path is
	
	COMPONENT ALU
		PORT(
			A : IN std_logic_vector(7 downto 0);
			B : IN std_logic_vector(7 downto 0);
			ALU_sel : IN std_logic_vector(2 downto 0);          
			NZVC_final : OUT std_logic_vector(3 downto 0);
			ALU_out : OUT std_logic_vector(7 downto 0)
			);
		END COMPONENT;
	
	
	signal bus1 : std_logic_vector(7 downto 0);
	signal bus2 : std_logic_vector(7 downto 0);
	signal MAR_out : std_logic_vector( 7 downto 0);
	signal PC_out : std_logic_vector(7 downto 0);
	signal A_out : std_logic_vector(7 downto 0);
	signal B_out : std_logic_vector(7 downto 0);
	signal B_out_toALU : std_logic_vector(7 downto 0);
	signal bus1_Mux_out : std_logic_vector(7 downto 0);
   signal bus2_Mux_out : std_logic_vector(7 downto 0);	
	signal ALU_nzvc : std_logic_vector(3 downto 0);
	signal ALU_out : std_logic_vector(7 downto 0);
	signal IR_in : std_logic;
	signal MAR_in : std_logic;
	signal PC_in : std_logic;
	signal PC_in_inc : std_logic;
	signal A_in : std_logic;
	signal B_in : std_logic;
	signal CCR_in : std_logic;
	signal CCR_out : std_logic_vector(3 downto 0);

	
begin
	ALU_uniq: ALU PORT MAP(
		A => B_out,
		B => B_out_toALU,
		ALU_sel => ALU_sel ,
		NZVC_final => ALU_nzvc,
		ALU_out => ALU_out 
	);
	
	-- BUS1 mux
	BUS1 <= PC_out when BUS1_sel = "00" else
			  A_out  when BUS1_sel = "01" else
			  B_out  when BUS1_sel = "10" else (others => '0');
			  
	-- BUS2 mux
	BUS2 <= ALU_out when BUS2_sel = "00" else
			  BUS1  when BUS2_sel = "01" else
			  from_memory  when BUS2_sel = "10" else (others => '0');	
			  
	-- IR register
	process(clk, reset)
	begin
		if(reset = '1') then 
			IR <= (others => '0');
		elsif(clk'event and clk = '1') then
			if( IR_in = '1') then
				IR <= bus2;
			end if;
		end if;
	end process;
	IR_in <= IR_load;
	
	-- MAR register
	process(clk, reset)
	begin
		if(reset = '1') then 
			MAR_out <= (others => '0');
		elsif(clk'event and clk = '1') then
			if( MAR_in = '1') then
				MAR_out <= bus2;
			end if;
		end if;
	end process;
	address <= MAR_out;
	MAR_in <= MAR_load;
	
	-- PC register
	process(clk, reset)
	begin
		if(reset = '1') then 
			PC_out <= (others => '0');
		elsif(clk'event and clk = '1') then
			if( PC_in = '1') then
				PC_out <= bus2;
			elsif(PC_in_inc = '1') then
				PC_out <= PC_out + x"01";
			end if;
		end if;
	end process;
	PC_in <= PC_load;
	PC_in_inc <= PC_inc;
	
	-- A register
	process(clk, reset)
	begin
		if(reset = '1') then 
			A_out <= (others => '0');
		elsif(clk'event and clk = '1') then
			if( A_in = '1') then
				A_out <= bus2;
			end if;
		end if;
	end process;
	A_in <= A_load;
	
	
	-- B register
	process(clk, reset)
	begin
		if(reset = '1') then 
			B_out <= (others => '0');
		elsif(clk'event and clk = '1') then
			if( B_in = '1') then
				B_out <= bus2;
			end if;
		end if;
	end process;
	B_in <= B_load;
	B_out_toALU <= B_out;
	--CCR register
	
	process(clk, reset)
	begin
		if( reset = '1') then
			CCR_out <= (others => '0');
		elsif(CCR_in = '1') then
			CCR_out <= ALU_nzvc;
		
		end if;
	end process;
	
	CCR_in <= CCR_load;
	CCR_result <= CCR_out;	
	
	-- datapath to memory
	to_memory <= bus1;

end Behavioral;

