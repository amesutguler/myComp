library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;


entity ALU is
    Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
           B : in  STD_LOGIC_VECTOR (7 downto 0);
           ALU_sel : in  STD_LOGIC_VECTOR (2 downto 0);
           NZVC_final : out  STD_LOGIC_VECTOR (3 downto 0);
           ALU_out : out  STD_LOGIC_VECTOR (7 downto 0));
end ALU;

architecture Behavioral of ALU is
	
	--signal sub_result : unsigned(8 downto 0); -- for carry?
	--signal sum_result : unsigned(8 downto 0); -- for carry
	signal alu_result : std_logic_vector(7 downto 0);
	signal NZVC : std_logic_vector(3 downto 0);
begin
	
	process(A,B,ALU_sel)
	
	variable sum_result : unsigned(8 downto 0);
	variable sub_result : unsigned(8 downto 0);
	
	begin
		sum_result := (others => '0');
		sub_result := (others => '0');
		NZVC <= (others => '0');
		if(ALU_sel <= "000") then -- addition
			sum_result := unsigned('0' & A) + unsigned('0' & B);
			
			-- result negative?
			NZVC(3) <= sum_result(7);
			
			-- result zero?
			if(sum_result( 7 downto 0) = x"00") then
				NZVC(2) <= '1';
			else
				NZVC(2) <= '0';
			end if;
		   
			-- overflow?
			if( (A(7)='0' and B(7)='0' and sum_result(7)='1') or
					(A(7)='1' and B(7)='1' and sum_result(7)='0')) then
				NZVC(1) <= '1';
			else
				NZVC(1) <= '0';
			end if;
			
			-- result carry?
			NZVC(0) <= sum_result(8);
			
			ALU_result <= std_logic_vector(sum_result(7 downto 0));
			
		elsif(ALU_sel <= "001") then -- subtraction
			
			sub_result := unsigned('0' & A) - unsigned('0' & B);
			
			-- result negative?
			NZVC(3) <= sub_result(7);
			
			-- result zero?
			if(sub_result( 7 downto 0) = x"00") then
				NZVC(2) <= '1';
			else
				NZVC(2) <= '0';
			end if;
			
			-- overflow?
			if( (A(7)='0' and B(7)='1' and sub_result(7)='1') or
					(A(7)='1' and B(7)='0' and sub_result(7)='0')) then
				NZVC(1) <= '1';
			else
				NZVC(1) <= '0';
			end if;
			
			-- result carry?
			NZVC(0) <= sub_result(8);
			
			ALU_result <= std_logic_vector(sub_result(7 downto 0));
			
		elsif(ALU_sel = "010") then -- AND
			ALU_result <= A and B;
		
		elsif(ALU_sel = "011") then -- OR
			ALU_result <= A or B;
		
		elsif(ALU_sel = "100") then -- XOR
			ALU_result <= A xor B;
			
		elsif(ALU_sel = "101") then -- INC
			sum_result := unsigned('0' & A) + 1;
			
			NZVC(3) <= sum_result(7);
			
			if(sum_result( 7 downto 0) = x"00") then
				NZVC(2) <= '1';
			else
				NZVC(2) <= '0';
			end if;
			
			if( ( A(7) = '0' and sum_result(7) = '1') ) then
				NZVC(2) <= '1';
			else
			   NZVC(2) <= '0';
			end if;
	
			NZVC(0) <= sum_result(8);
			
			ALU_result <= std_logic_vector(sum_result(7 downto 0));
		elsif(ALU_sel = "110") then -- DEC
			sub_result := unsigned('0' & A) - 1;
			
			NZVC(3) <= sub_result(7);
		
			if(sub_result( 7 downto 0) = x"00") then
				NZVC(2) <= '1';
			else
				NZVC(2) <= '0';
			end if;
			
			if( A(7) = '0' and sub_result(7) = '1') then
				NZVC(2) <= '1';
			else
			   NZVC(2) <= '0';
			end if;
			
			NZVC(0) <= sub_result(8);
			
			ALU_result <= std_logic_vector(sub_result(7 downto 0));
			
		else
			sum_result := (others => '0');
			sub_result := (others => '0');
			ALU_result <= (others => '0');
		end if;
	end process;
	
	NZVC_final <= NZVC;
	ALU_out <= ALU_result;
end Behavioral;

