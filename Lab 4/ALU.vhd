


Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity adder_subtracter is
	port(	datain_a: in std_logic_vector(31 downto 0);
		datain_b: in std_logic_vector(31 downto 0);
		add_sub: in std_logic;
		dataout: out std_logic_vector(31 downto 0);
		co: out std_logic);
end entity adder_subtracter;

architecture calc of adder_subtracter is
	component fulladder
		port (a : in std_logic;
		      b : in std_logic;
		      cin : in std_logic;
		      sum : out std_logic;
		      carry : out std_logic);
	end component;

signal c: std_logic_vector(32 downto 0);
signal b: std_logic_vector(31 downto 0);

begin
	-- insert code here.
	c(0) <= add_sub;	
	co <= c(32);

	with add_sub select
		b <=  not (datain_b) when '1',
		     datain_b when  '0',
		     "ZZZZZZZZ" when others; 

	Adder: For i in 31 downto 0 GENERATE
		Addi: fulladder PORT MAP(datain_a(i), b(i), c(i), dataout(i), c(i+1));
	END GENERATE;

end architecture calc;



Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity shift_register is
	port(	datain: in std_logic_vector(31 downto 0);
	   	dir: in std_logic;
		shamt:	in std_logic_vector(4 downto 0);
		dataout: out std_logic_vector(31 downto 0));
end entity shift_register;

architecture shifter of shift_register is

	
begin
	-- insert code here.
	-- Direction is 1, shifting it to the right by 1, 2, 3 bits(Only from 1  bit up to 3 bits which is the maximum bits allowed.)
	-- Direction is 0, shifting it to the left  by 1, 2 ,3 bits(Only from 1  bit up to 3 bits which is the maximum bits allowed.)

	with dir & shamt select
		dataout <=  "0" & datain(31 downto 1)   when "100001", -- Shift right by one bit
			    "00" & datain(31 downto 2)  when "100010", -- Shift right by two bits
			    "000" & datain(31 downto 3) when "100011", -- Shift right by three bits
			    datain(30 downto 0) & "0"   when "000001", -- Shift left by one bit
	                    datain(29 downto 0) & "00"  when "000010", -- Shift left by two bits
	                    datain(28 downto 0) & "000" when "000011", -- Shift left by three bits
	                    datain(31 downto 0) when others;

end architecture shifter;



Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity fulladder is
    port (a : in std_logic;
          b : in std_logic;
          cin : in std_logic;
          sum : out std_logic;
          carry : out std_logic
         );
end fulladder;


architecture addlike of fulladder is
begin
  sum   <= a xor b xor cin; 
  carry <= (a and b) or (a and cin) or (b and cin); 
end architecture addlike;






--------------------------------------------------------------------------------
--
-- LAB #4
--
--------------------------------------------------------------------------------

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


	signal the_result: std_logic_vector(31 downto 0);
	signal datavalue1: std_logic_vector(31 downto 0);
	signal datavalue2pass: std_logic_vector(31 downto 0);
	signal carryout: std_logic;
	signal the_add_sub:  std_logic;  
	signal the_adder:  std_logic_vector(31 downto 0);  --result of the adder/subtractor
	signal andi: std_logic_vector(31 downto 0);
	signal or_i: std_logic_vector(31 downto 0); 
	signal sll_i: std_logic_vector(31 downto 0);
	signal slr_i: std_logic_vector(31 downto 0);



--result of the adder/subtractor
	--result of the operation
	
	 --direction of the shift register
	--operation of the adder/subtractor

begin
	-- Add ALU VHDL implementation here
	
	with ALUCtrl(0) select 
			the_add_sub <=   '0' when '0',
					 '1' when '1',
					 'Z' when others;

	datavalue2pass <= DataIn2;

	andi <= DataIn1 and DataIn2;  -- The And Gate should be anding of those inputs which are as follows: DataIn1 and DataIn2.
	or_i <=  DataIn1 or  DataIn2;  -- The Or Gate should be oring of those inputs which are as follows: DataIn1 and DataIn2.
			

	addsub: adder_subtracter PORT MAP(DataIn1, datavalue2pass, the_add_sub, the_adder(31 downto 0), carryout);
	
	shift_i: shift_register  PORT MAP(DataIn1, '0', DataIn2(4 downto 0), sll_i);  --for shifting left
	shift_i2: shift_register  PORT MAP(DataIn1, '1', DataIn2(4 downto 0),slr_i); -- for shifting right
	

	with ALUCtrl select   
			the_result <= the_adder when "00000", --the first input should be from the adder/subtracter operation
				      andi   when "00011",   --the second input should be from the shift register operation
				      or_i   when "00101",   --the third input should be from the and gate operation
				      sll_i  when "00111",
				      slr_i  when "01001",
				      datavalue2pass when "10000",
				      "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"  when others; 
		
	ALUResult <= the_result; ---ALUResult should be the total result of the value is in the result after any of these operations were completed. 


	with the_result select
			Zero <= '1' when "00000000000000000000000000000000", -- if the result is actually zero after any of these operations were executed then zero should be 1 in order for it to display properly. 
				'0' when others; 
	
end architecture ALU_Arch;


