--------------------------------------------------------------------------------
--
-- Test Bench for LAB #4
--
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY testALU_vhd IS
END testALU_vhd;

ARCHITECTURE behavior OF testALU_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT ALU
		Port(	DataIn1: in std_logic_vector(31 downto 0);
			DataIn2: in std_logic_vector(31 downto 0);
			ALUCtrl: in std_logic_vector(4 downto 0);
			Zero: out std_logic;
			ALUResult: out std_logic_vector(31 downto 0) );
	end COMPONENT ALU;

	--Inputs
	SIGNAL datain_a : std_logic_vector(31 downto 0) := (others=>'0');
	SIGNAL datain_b : std_logic_vector(31 downto 0) := (others=>'0');
	SIGNAL control	: std_logic_vector(4 downto 0)	:= (others=>'0');

	--Outputs
	SIGNAL result   :  std_logic_vector(31 downto 0);
	SIGNAL zeroOut  :  std_logic;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: ALU PORT MAP(
		DataIn1 => datain_a,
		DataIn2 => datain_b,
		ALUCtrl => control,
		Zero => zeroOut,
		ALUResult => result
	);
	

	tb : PROCESS
	BEGIN

		-- Wait 100 ns for global reset to finish
		wait for 100 ns;

		

		-- Add test cases here to drive the ALU implementation

-- Wait 100 ns for global reset to finish
		wait for 100 ns;

		-- Start testing the ALU
		-- Add test cases here to drive the ALU implementation

		---- Comprehensively test the ADDITION  OPeration.
		datain_a <= X"00000001";	-- DataIn in hex
		datain_b <= X"01234567";
		control  <= "00000";		-- Control in binary 
		wait for 20 ns; 			-- result = 0x1234568  and zeroOut equals 0

		-- Add test cases here to drive the ALU implementation


		---- Comprehensively test  the  ADDITION  OPeration.
		datain_a <= X"00000002";	-- The DataIn in Hexadecimal. DataIn in hex
		datain_b <= X"00000001";
		control  <= "00001";		-- The control in binary.
		wait for 20 ns; 	        -- The result = 0x00000001 and zeroOut equals 0



		 ---- Comprehensively test  the  SHIFT OPeration.
		datain_a <= X"11111110";	-- The DataIn in Hexadecimal.
		datain_b <= X"00000001";
		control  <= "00111";		-- The control in binary.
		wait for 20 ns; 		-- The result = 0x88888880 and zeroOut equals 0



		---- Comprehensively test  the AND OPeration.
		datain_a <= X"00100000";	-- The DataIn in Hexadecimal.
		datain_b <= X"00100011";
		control  <= "00011";		-- The control in binary.
		wait for 20 ns; 		-- The result  = 0x00100000  and zeroOut equals = 0


		---- Comprehensively test  the OR OPeration. 
		datain_a <= X"10101010";	-- The DataIn in Hexadecimal.
		datain_b <= X"01010101";
		control  <= "00101";		-- The control in binary.
		wait for 20 ns; 		-- The result = 0x11111111 and zeroOut equals 0


		---- Comprehensively test  the Data Bypass Operation.
		datain_a <= X"AAAAAAAA";	-- The DataIn in Hexadecimal.
		datain_b <= X"01234567";
		control <="11111";		-- The control in binary.
		wait for 20 ns;			-- The result equals 0x01234567 and zeroOut equals 0



		wait; -- will wait forever
	END PROCESS;

END;