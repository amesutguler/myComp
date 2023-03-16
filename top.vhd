library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;


entity top is
    Port (  clk : in  STD_LOGIC;
            reset : in  STD_LOGIC;
			   port_in_00  : IN std_logic_vector(7 downto 0);
				port_in_01  : IN std_logic_vector(7 downto 0);
				port_in_02  : IN std_logic_vector(7 downto 0);
				port_in_03  : IN std_logic_vector(7 downto 0);
				port_in_04  : IN std_logic_vector(7 downto 0);
				port_in_05  : IN std_logic_vector(7 downto 0);
				port_in_06  : IN std_logic_vector(7 downto 0);
				port_in_07  : IN std_logic_vector(7 downto 0);
				port_in_08  : IN std_logic_vector(7 downto 0);
				port_in_09  : IN std_logic_vector(7 downto 0);
				port_in_10  : IN std_logic_vector(7 downto 0);
				port_in_11  : IN std_logic_vector(7 downto 0);
				port_in_12  : IN std_logic_vector(7 downto 0);
				port_in_13  : IN std_logic_vector(7 downto 0);
				port_in_14  : IN std_logic_vector(7 downto 0);
				port_in_15  : IN std_logic_vector(7 downto 0);
				-- outputs
				data_out    : OUT std_logic_vector(7 downto 0);
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
end top;

architecture Behavioral of top is

	COMPONENT memory
		PORT(
			address 		: IN std_logic_vector(7 downto 0);
			data_in 		: IN std_logic_vector(7 downto 0);
			wr_en 		: IN std_logic;
			reset 		: IN std_logic;
			clk 			: IN std_logic;
			port_in_00  : IN std_logic_vector(7 downto 0);
			port_in_01  : IN std_logic_vector(7 downto 0);
			port_in_02  : IN std_logic_vector(7 downto 0);
			port_in_03  : IN std_logic_vector(7 downto 0);
			port_in_04  : IN std_logic_vector(7 downto 0);
			port_in_05  : IN std_logic_vector(7 downto 0);
			port_in_06  : IN std_logic_vector(7 downto 0);
			port_in_07  : IN std_logic_vector(7 downto 0);
			port_in_08  : IN std_logic_vector(7 downto 0);
			port_in_09  : IN std_logic_vector(7 downto 0);
			port_in_10  : IN std_logic_vector(7 downto 0);
			port_in_11  : IN std_logic_vector(7 downto 0);
			port_in_12  : IN std_logic_vector(7 downto 0);
			port_in_13  : IN std_logic_vector(7 downto 0);
			port_in_14  : IN std_logic_vector(7 downto 0);
			port_in_15  : IN std_logic_vector(7 downto 0);
			-- outputs
			data_out    : OUT std_logic_vector(7 downto 0);
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
	
	COMPONENT cpu
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		from_memory : IN std_logic_vector(7 downto 0);          
		write_en : OUT std_logic;
		to_memory : OUT std_logic_vector(7 downto 0);
		address : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
	signal cpu_to_mem_add  : std_logic_vector(7 downto 0);
	signal cpu_to_mem_data : std_logic_vector(7 downto 0);
	signal mem_to_cpu_data : std_logic_vector(7 downto 0);
	signal wr_conn 		  : std_logic;
	
	
begin

	uniq_cpu: cpu PORT MAP(
			clk 			=> clk,
			reset       => reset,
			from_memory => mem_to_cpu_data,
			write_en    => wr_conn,
			to_memory   => cpu_to_mem_data,
			address     => cpu_to_mem_add
		);

	uniq_memory: memory PORT MAP(
		address     => cpu_to_mem_add,
		data_in     => cpu_to_mem_data,
		wr_en       => wr_conn,
		reset       => reset,
		clk         => clk,
		port_in_00  => port_in_00,
		port_in_01  => port_in_01,
		port_in_02  => port_in_02,
		port_in_03  => port_in_03,
		port_in_04  => port_in_04,
		port_in_05  => port_in_05,
		port_in_06  => port_in_06,
		port_in_07  => port_in_07,
		port_in_08  => port_in_08,
		port_in_09  => port_in_09,
		port_in_10  => port_in_10,
		port_in_11  => port_in_11,
		port_in_12  => port_in_12,
		port_in_13  => port_in_13,
		port_in_14  => port_in_14,
		port_in_15  => port_in_15,
		data_out    => mem_to_cpu_data,
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



end Behavioral;

