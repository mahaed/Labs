
--------------------------------------------------------------------------------
--
-- LAB #4
--------------------------------------------------------------------------------
-- Mahaed Mohamud & Sean Wright
-- ECEGR 2220 - Microprocessor
-- Lab #4
--
-- Main Objectives: 1. Creating a 8 bit registers
-- 2.creating  a 32 bit registers built from the components of register8
-- 3. Creating and ensuring that a 32 bit shift register that can shift by 3 bits in left and right direction.
-- 4. Creating a 32 bit adder/subtractor.
--
-- 
--------------------------------------------------------------------------------

--
--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity bitstorage is
	port(bitin: in std_logic;
		 enout: in std_logic;
		 writein: in std_logic;
		 bitout: out std_logic);
end entity bitstorage;

architecture memlike of bitstorage is
	signal q: std_logic := '0';
begin
	process(writein) is
	begin
		if (rising_edge(writein)) then
			q <= bitin;
		end if;
	end process;
	
	-- Note that data is output only when enout = 0	
	bitout <= q when enout = '0' else 'Z';
end architecture memlike;

--------------------------------------------------------------------------------
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
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity register8 is
	port(datain: in std_logic_vector(7 downto 0);
	     enout:  in std_logic;
	     writein: in std_logic;
	     dataout: out std_logic_vector(7 downto 0));
end entity register8;

architecture memmy of register8 is
	component bitstorage
		port(bitin: in std_logic;
		 	 enout: in std_logic;
		 	 writein: in std_logic;
		 	 bitout: out std_logic);
	end component;
begin
	-- insert your code here.
	registerEight: FOR i IN 7 downto 0 GENERATE
	   ai: bitstorage PORT MAP(datain(i), enout, writein, dataout(i));
	END GENERATE;

end architecture memmy;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity register32 is
	port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic;
		 writein32, writein16, writein8: in std_logic;
		 dataout: out std_logic_vector(31 downto 0));
end entity register32;

architecture biggermem of register32 is
	-- hint: you'll want to put register8 as a component here 
	-- so you can use it below
	component register8
		port(datain: in std_logic_vector(7 downto 0);
	     	enout:  in std_logic;
	     	writein: in std_logic;
	     	dataout: out std_logic_vector(7 downto 0));
	end component;

	SIGNAL enout_16: std_logic:= '0';
	SIGNAL enout_8: std_logic:= '0';
	SIGNAL write_in16: std_logic:= '0';
	SIGNAL write_in8:  std_logic:= '0';
begin

	-- insert code here.

	enout_16 <= enout32 and enout16; -- enable out for 16 bits. 
	enout_8  <= enout32 and enout16 and enout8; -- enable out for 8 bits.

	write_in16 <= writein32 or writein16; -- write in for 16 bits
	write_in8  <= writein32 or writein8;  -- write in for 8 bits. 

	a0: register8 PORT MAP ( datain(31 downto 24), enout32, writein32, dataout(31 downto 24));
	a1: register8 PORT MAP ( datain(23 downto 16), enout32, writein32, dataout(23 downto 16));
	a2: register8 PORT MAP ( datain(15 downto 8),  enout_16, write_in16, dataout(15 downto 8));
	a3: register8 PORT MAP ( datain(7  downto 0),  enout_8,  write_in8, dataout(7 downto 0));

end architecture biggermem;

--------------------------------------------------------------------------------
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
		     datain_b when  others; 
	
	Adder: For i in 31 downto 0 GENERATE
		Addi: fulladder PORT MAP(datain_a(i), b(i), c(i), dataout(i), c(i+1));
	END GENERATE;
	
end architecture calc;


--------------------------------------------------------------------------------
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
	component shift_register 
		port(datain: in std_logic_vector(31 downto 0);
			dir: in std_logic;
			shamt:	in std_logic_vector(4 downto 0);
			dataout: out std_logic_vector(31 downto 0));
	end component;
begin
	
	with shamt & dir select
	--Direction goes right when dir ==1, left when dir == 0
	--shamt increments the usual way 00, 01,10,11 for how many spaces you want
	--to shift
	dataout <=	 "0" & datain(31 downto 1)   when "100001", -- Shift right by one bit
			    "00" & datain(31 downto 2)  when "100010", -- Shift right by two bits
			    "000" & datain(31 downto 3) when "100011", -- Shift right by three bits
			    datain(30 downto 0) & "0"   when "000001", -- Shift left by one bit
	                    datain(29 downto 0) & "00"  when "000010", -- Shift left by two bits
	                    datain(28 downto 0) & "000" when "000011", -- Shift left by three bits
	                    datain(31 downto 0) when others;
end architecture shifter;


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

