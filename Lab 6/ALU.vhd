
--
-- 
--------------------------------------------------------------------------------

--
--------------------------------------------------------------------------------


-------------------------------------------------------------------------------
--
-- LAB #4
--------------------------------------------------------------------------------
-- Mahaed Mohamud & Sean Wright
-- ECEGR 2220 - Microprocessor




Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity ALU is
	Port(	DataIn1: in std_logic_vector(31 downto 0);
		DataIn2: in std_logic_vector(31 downto 0);
		ALUCtrl: in std_logic_vector(4 downto 0);
		Zero: out std_logic;
		ALUResult: out std_logic_vector(31 downto 0) );
end entity ALU;

architecture ALU_Arch of ALU is


	-- ALU components	
	component adder_subtracter
		port(	datain_a: in std_logic_vector(31 downto 0);
			datain_b: in std_logic_vector(31 downto 0);
			add_sub: in std_logic;
			dataout: out std_logic_vector(31 downto 0);
			co: out std_logic);
	end component adder_subtracter;

	component shift_register
		port(	datain: in std_logic_vector(31 downto 0);
		   	dir: in std_logic;
			shamt:	in std_logic_vector(4 downto 0);
			dataout: out std_logic_vector(31 downto 0));
	end component shift_register;


	signal transfer1: std_logic_vector(31 downto 0);
	signal transfer2: std_logic_vector(31 downto 0);
	signal add_sub: std_logic;
	signal thedirection: std_logic;
	signal thetransfer: std_logic_vector(31 downto 0);
	signal carry: std_logic;

--result of the adder/subtractor
	--result of the operation
	
	 --direction of the shift register
	--operation of the adder/subtractor

begin
	-- Add ALU VHDL implementation here
	--ALUCTRL is the control signal that directs which operation to execute when selected.
	--T

	thedirection <= ALUCtrl(0);


	with ALUCtrl select 
			add_sub <= '0' when "00000",
				   '1' when "00001",
				   'Z' when others; 

	
	with ALUCtrl select   thetransfer 
				<= DataIn1 and DataIn2 when "00011" | "00100", -- For And Operation
				   DataIn1 or  DataIn2 when "00110" | "00101",  -- For OR Operation
				   transfer1(31 downto 0) when "00001" | "00000" ,  -- For Addition/Subtraction operation.
				   transfer2(31 downto 0) when  "01000" | "01001" | "01010" | "00111", -- For Shifts Operation. 
				   DataIn2(31 downto 0) when others;  --Bypass the datain2 value pass through.   
	
        --Create a component for adder/subtractor(ALU) and shift register in terms of  inputs/output mapping/connections for each of those as seen below. 
	Adder: adder_subtracter PORT MAP(DataIn1, DataIn2, add_sub, transfer1, carry);
	Shifts: shift_register  PORT MAP(DataIn1, thedirection, DataIn2(4 downto 0), transfer2); 

			

			ALUResult <= thetransfer; ---ALUResult should be the total result of the value is in the result after any of these operations were completed. 

	with thetransfer select 
			Zero <= '1' when X"00000000",
			            '0' when others; 
	
end architecture ALU_Arch;

