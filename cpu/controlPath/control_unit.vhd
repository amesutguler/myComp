library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;


entity control_unit is
	port(	clk, reset : in std_logic;
			IR         : in std_logic_vector(7 downto 0);
			CCR_result : in std_logic_vector(3 downto 0);
			--outputs
			IR_load 		: out std_logic;
			MAR_load 	: out std_logic;
			PC_load 		: out std_logic;
			PC_inc 		: out std_logic;
			A_load 		: out std_logic;
			B_load 		: out std_logic;
			ALU_sel 		: out std_logic_vector(2 downto 0);
			CCR_load 	: out std_logic;
			BUS1_sel 	: out std_logic_vector(1 downto 0);
			BUS2_sel 	: out std_logic_vector(1 downto 0);
			write_en 	: out std_logic
			);
end control_unit;

architecture Behavioral of control_unit is

	type state_type is
		(S_FETCH_0, S_FETCH_1, S_FETCH_2,
		 S_DECODE_3,
		 S_LDA_IMM_4, S_LDA_IMM_5, S_LDA_IMM_6,
		 S_LDA_DIR_4, S_LDA_DIR_5, S_LDA_DIR_6, S_LDA_DIR_7, S_LDA_DIR_8,
		 S_LDB_IMM_4, S_LDB_IMM_5, S_LDB_IMM_6,
		 S_LDB_DIR_4, S_LDB_DIR_5, S_LDB_DIR_6, S_LDB_DIR_7, S_LDB_DIR_8,
		 S_STA_DIR_4, S_STA_DIR_5, S_STA_DIR_6, S_STA_DIR_7, S_STA_DIR_8,
		 S_ADD_AB_4,
		 S_BRA_4, S_BRA_5, S_BRA_6,
		 S_BEQ_4, S_BEQ_5, S_BEQ_6, S_BEQ_7);
		 
	signal state_reg, state_next : state_type;
	
	-- The instruction set
	constant LDA_IMM : std_logic_vector (7 downto 0) := x"86";
	constant LDA_DIR : std_logic_vector (7 downto 0) := x"87";
	constant LDB_IMM : std_logic_vector (7 downto 0) := x"88";
	constant LDB_DIR : std_logic_vector (7 downto 0) := x"89";
	constant STA_DIR : std_logic_vector (7 downto 0) := x"96";
	constant STB_DIR : std_logic_vector (7 downto 0) := x"97";
	constant ADD_AB  : std_logic_vector (7 downto 0) := x"42";
	constant SUB_AB  : std_logic_vector (7 downto 0) := x"43";
	constant AND_AB  : std_logic_vector (7 downto 0) := x"44";
	constant OR_AB   : std_logic_vector (7 downto 0) := x"45";
	constant INCA 	  : std_logic_vector (7 downto 0) := x"46";
	constant INCB    : std_logic_vector (7 downto 0) := x"47";
	constant DECA    : std_logic_vector (7 downto 0) := x"48";
	constant DECB 	  : std_logic_vector (7 downto 0) := x"49";
	constant BRA 	  : std_logic_vector (7 downto 0) := x"20";
	constant BMI     : std_logic_vector (7 downto 0) := x"21";
	constant BPL 	  : std_logic_vector (7 downto 0) := x"22";
	constant BEQ 	  : std_logic_vector (7 downto 0) := x"23";
	constant BNE  	  : std_logic_vector (7 downto 0) := x"24";
	constant BVS 	  : std_logic_vector (7 downto 0) := x"25";
	constant BVC 	  : std_logic_vector (7 downto 0) := x"26";
	constant BCS 	  : std_logic_vector (7 downto 0) := x"27";
	constant BCC 	  : std_logic_vector (7 downto 0) := x"28";

begin

-- state memory
	process(clk, reset)
	begin
		if(reset = '1') then
			state_reg <= S_FETCH_0;
		elsif(clk'event and clk = '1') then
			state_reg <= state_next;
		end if;
	end process;
	
	--
	
-- next state logic
	process(state_reg, IR, CCR_result)
	begin
		if(state_reg = S_FETCH_0) then
			state_next <= S_FETCH_1;
			
		elsif(state_reg = S_FETCH_1) then
			state_next <= S_FETCH_2;
		
		elsif(state_reg = S_FETCH_2) then
			state_next <= S_DECODE_3;
		
		elsif(state_reg = S_DECODE_3) then
			--selecting the execution path
			
			if(IR = LDA_IMM) 	  then
				state_next <= S_LDA_IMM_4;
			
			elsif(IR = LDA_DIR) then
				state_next <= S_LDA_DIR_4;
				
			elsif(IR = LDB_IMM) then
				state_next <= S_LDB_IMM_4;
			
			elsif(IR = LDB_DIR) then
				state_next <= S_LDB_DIR_4;
				
			elsif(IR = STA_DIR) then
				state_next <= S_STA_DIR_4;
			
			elsif(IR = ADD_AB)  then
				state_next <= S_ADD_AB_4;
			
			elsif(IR = BRA)     then
				state_next <= S_BRA_4;

			elsif(IR = BEQ)	  then
				state_next <= S_BEQ_4;
				
			else
				state_next <= S_FETCH_0;
			end if;
		-----------------------------------	
		elsif(state_reg = S_LDA_IMM_4)then
			state_next <= S_LDA_IMM_5;
			
		elsif(state_reg = S_LDA_IMM_5) then		-- LDA_IMM states
			state_next <= S_LDA_IMM_6;
			
		elsif(state_reg = S_LDA_IMM_6) then
			state_next <= S_FETCH_0;
		-----------------------------------
		
		-----------------------------------
		elsif(state_reg = S_LDA_DIR_4)then
			state_next <= S_LDA_DIR_5;

		elsif(state_reg = S_LDA_DIR_5)then
			state_next <= S_LDA_DIR_6;
															-- LDA_DIR states	
		elsif(state_reg = S_LDA_DIR_6)then
			state_next <= S_LDA_DIR_7;
			
		elsif(state_reg = S_LDA_DIR_7)then
			state_next <= S_FETCH_0;	
		-----------------------------------
		
		-----------------------------------	
		elsif(state_reg = S_LDB_IMM_4)then
			state_next <= S_LDB_IMM_5;
			
		elsif(state_reg = S_LDB_IMM_5) then		-- LDB_IMM states
			state_next <= S_LDB_IMM_6;
			
		elsif(state_reg = S_LDB_IMM_6) then
			state_next <= S_FETCH_0;
		-----------------------------------
		
		-----------------------------------
		elsif(state_reg = S_LDB_DIR_4)then
			state_next <= S_LDB_DIR_5;

		elsif(state_reg = S_LDB_DIR_5)then
			state_next <= S_LDB_DIR_6;
															-- LDB_DIR states	
		elsif(state_reg = S_LDB_DIR_6)then
			state_next <= S_LDB_DIR_7;
			
		elsif(state_reg = S_LDB_DIR_7)then
			state_next <= S_FETCH_0;	
		-----------------------------------
		
		-----------------------------------
		elsif(state_reg = S_STA_DIR_4)then
			state_next <= S_STA_DIR_5;

		elsif(state_reg = S_STA_DIR_5)then
			state_next <= S_STA_DIR_6;
															-- STA_DIR states	
		elsif(state_reg = S_STA_DIR_6)then
			state_next <= S_STA_DIR_7;
			
		elsif(state_reg = S_STA_DIR_7)then
			state_next <= S_STA_DIR_8;
		
		elsif(state_reg = S_STA_DIR_8)then
			state_next <= S_FETCH_0;
		-----------------------------------
		
		-----------------------------------		
		elsif(state_reg = S_ADD_AB_4)then
			state_next <= S_FETCH_0;				-- ADD_AB states				
		-----------------------------------
		
		-----------------------------------	
		elsif(state_reg = S_BRA_4)then
			state_next <= S_BRA_5;
															
		elsif(state_reg = S_BRA_5)then			-- BRA states
			state_next <= S_BRA_6;
		
		elsif(state_reg = S_BRA_6)then
			state_next <= S_FETCH_0;
		-----------------------------------	
		
		-----------------------------------	
		elsif(state_reg = S_BEQ_4)then
			state_next <= S_BEQ_5;
															
		elsif(state_reg = S_BEQ_5)then			-- BEQ states
			state_next <= S_BEQ_6;
		
		elsif(state_reg = S_BEQ_6)then
			state_next <= S_BEQ_7;
		
		elsif(state_reg = S_BEQ_7)then
			state_next <= S_FETCH_0;
		-----------------------------------	
		
		end if;
	end process;
	
	process(state_reg)
	begin
		
		IR_load <= '0';
				MAR_load <= '0';
				PC_load <= '0';
				A_load <= '0';
				B_load <= '0';
				CCR_load <= '0';
				write_en <= '0';
				ALU_sel <= (others => '0');
				bus1_sel <= (others => '0');
				bus2_sel <= (others => '0');
				
		case state_reg is
			when S_FETCH_0  =>
				bus1_sel <= "00";					-- PC loaded into bus1
				bus2_sel <= "01";					-- BUS1 is connected to BUS2
				MAR_load <= '1';					--	MAR will be loaded with PC in the next cycle
				
			when S_FETCH_1  => 
				PC_inc <= '1';						-- PC now pointing to next rom slot
				
			when S_FETCH_2  =>
				bus2_sel <= "10";		-- the opcode returned from memory
				IR_load <= '1';					-- IR will be loaded with opcode in the next cycle
			
			when S_DECODE_3 =>
			-- nothing in this state
		   -- the opcode is decoded
			
			-----------------------------------------------------------------------------------
			when S_LDA_IMM_4 =>
				bus1_sel <= "00";
				bus2_sel <= "01";
				MAR_load <= '1';
			
			when S_LDA_IMM_5 =>																   -- LDA_IMM branch
				PC_inc <= '1';
				
			when S_LDA_IMM_6 =>
				bus2_sel <= "10";
				A_load <= '1';
			-----------------------------------------------------------------------------------			
			when S_LDA_DIR_4 =>
				bus1_sel <= "00";
				bus2_sel <= "01";
				MAR_load <= '1';
		   
			when S_LDA_DIR_5 =>
				PC_inc <= '1';
				
			when S_LDA_DIR_6 =>
				bus2_sel <= "10";																	--LDA_DIR branch
				MAR_load <= '1';
			
			when S_LDA_DIR_7 =>
			-- nothing to do here
			
			when S_LDA_DIR_8 =>
				bus2_sel <= "10";
				A_load <= '1';
			-----------------------------------------------------------------------------------
			when S_LDB_IMM_4 =>
				bus1_sel <= "00";
				bus2_sel <= "01";
				MAR_load <= '1';
			
			when S_LDB_IMM_5 =>																   -- LDB_IMM branch
				PC_inc <= '1';
				
			when S_LDB_IMM_6 =>
				bus2_sel <= "10";
				B_load <= '1';
			-----------------------------------------------------------------------------------			
			when S_LDB_DIR_4 =>
				bus1_sel <= "00";
				bus2_sel <= "01";
				MAR_load <= '1';
		   
			when S_LDB_DIR_5 =>
				PC_inc <= '1';
				
			when S_LDB_DIR_6 =>
				bus2_sel <= "10";																	--LDA_DIR branch
				MAR_load <= '1';
			
			when S_LDB_DIR_7 =>
			-- nothing to do here
			
			when S_LDB_DIR_8 =>
				bus2_sel <= "10";
				B_load <= '1';
			-----------------------------------------------------------------------------------
			when S_STA_DIR_4 =>
				bus1_sel <= "00";
				bus2_sel <= "01";
				MAR_load <= '1';	
			
			when S_STA_DIR_5 =>
				PC_inc <= '1';
																										 --STA_DIR branch
			when S_STA_DIR_6 =>
				bus2_sel <= "10";
				MAR_load <= '1';
			
			when S_STA_DIR_7 =>
				bus1_sel <= "01";
				write_en <= '1';
			-----------------------------------------------------------------------------------
			when S_ADD_AB_4 =>
				bus1_sel <= "01";	 -- A_out is on the bus1
				bus2_sel <= "00";	 -- ALU_result 
				ALU_sel  <= "000"; -- ALU prepared for addition							 			--ADD_AB	
				A_load   <= '1';	 -- result will be written in A reg	
				CCR_load <= '1';	 -- CCR reg prepared
				
			-----------------------------------------------------------------------------------
			when S_BRA_4 =>
				bus1_sel <= "00";  
				bus2_sel <= "01";
				MAR_load <= '1';
			
			when S_BRA_5 =>
				-- nothing here																				--BRA
				
			when S_BRA_6 =>
				bus2_sel <= "10";
				PC_load <= '1';
			
			-----------------------------------------------------------------------------------
			when S_BEQ_4 =>
				bus1_sel <= "00";  
				bus2_sel <= "01";
				MAR_load <= '1';
			when S_BEQ_5 =>
				-- nothing here																				--BEQ
				
			when S_BEQ_6 =>
				bus2_sel <= "10";
				PC_load <= '1';	
			
			when S_BEQ_7 =>
				PC_inc <= '1';
			
			when others =>
				IR_load <= '0';
				MAR_load <= '0';
				PC_load <= '0';
				A_load <= '0';
				B_load <= '0';
				CCR_load <= '0';
				write_en <= '0';
				ALU_sel <= (others => '0');
				bus1_sel <= (others => '0');
				bus2_sel <= (others => '0');

					
		end case;
	end process;
end Behavioral;

