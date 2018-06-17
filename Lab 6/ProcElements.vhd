--------------------------------------------------------------------------------
--
-- LAB #6 - Processor Elements
--------------------------------------------------------------------------------
--
-- LAB #6 - Processor 
--
--------------------------------------------------------------------------------
-- Mahaed Mohamud & Sean Wright
-- ECEGR 2220 - Microprocessor
-- Lab #6
--
-- Main Objectives: 1.  Create a VHDL program that properly implements the RISC-V single cycle processor design as seen in the lab 6 instructions.
-- 2. Also building upon the components that it was created in previous labs (Lab #3, Lab #4, and Lab #5).
-- 3. Create a VHDL program that supports the following instructions set that is seen in the lab 6 instructions.
-- 
--
-- 
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BusMux2to1 is
	Port(	selector: in std_logic;
			In0, In1: in std_logic_vector(31 downto 0);
			Result: out std_logic_vector(31 downto 0) );
end entity BusMux2to1;

architecture selection of BusMux2to1 is
begin
-- Add your code here
	with selector select
	    Result <= In0 when '0',
		In1 when others;

end architecture selection;

--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Control is
      Port(clk : in  STD_LOGIC;
           opcode : in  STD_LOGIC_VECTOR (6 downto 0);
           funct3  : in  STD_LOGIC_VECTOR (2 downto 0);
           funct7  : in  STD_LOGIC_VECTOR (6 downto 0);
           Branch : out  STD_LOGIC_VECTOR(1 downto 0);
           MemRead : out  STD_LOGIC;
           MemtoReg : out  STD_LOGIC;
           ALUCtrl : out  STD_LOGIC_VECTOR(4 downto 0);
           MemWrite : out  STD_LOGIC;
           ALUSrc : out  STD_LOGIC;
           RegWrite : out  STD_LOGIC;
           ImmGen : out STD_LOGIC_VECTOR(1 downto 0));
end Control;

architecture Boss of Control is
begin
-- Add your code here


	with opcode & funct3 select
	   MemRead <= '0' when "0000011010", --lw
		 '1' when others;

	with opcode & funct3 select
	   MemtoReg <= '1' when "0000011010", --lw
     		'0' when others;


	ALUCtrl <= "00000" when opcode = "0110011" AND funct3 = "000" AND funct7 = "0000000000" else --add
		   "00001" when opcode = "0110011" AND funct3 ="000" AND  funct7 = "0100000" else --sub
		   "00111" when opcode = "0110011" AND funct3 ="001" AND  funct7 = "0000000" else --sll
		   "01001" when opcode = "0110011" AND funct3 ="100" AND  funct7 = "0000000" else --srl
		   "00010" when opcode ="0010011" AND funct3 ="000" else --addi
		   "01111" when opcode= "0010011" AND  funct3 ="111" else --andi
		   "00000" when opcode = "0110111" else--lui
		   "00110" when opcode = "0010011" AND funct3 ="110" else --ori
		   "00000" when opcode = "0000011" AND funct3 ="010" else --lw
		   "00000" when opcode = "0100011" AND funct3 ="010" else --sw
		   "00001" when opcode = "1100011" AND funct3 ="000" else --beq
		   "00001" when opcode = "1100011" AND funct3 ="001" else  --bne
		   "00011" when opcode ="0110011" AND funct3= "111" AND funct7 = "0000000" else --and
		   "01000" when opcode = "0010011" AND funct3 ="001" AND  funct7 = "0000000" else --slli
		   "01010" when opcode = "0010011" AND funct3 ="101" AND  funct7 = "0100000" else --srli
		   "00101" when opcode = "0110011" AND funct3 ="110" AND  funct7 = "0100000" else --or
		   "11111";


 	ALUSrc <= '0' when opcode = "0110011" AND funct3 = "000" AND funct7 = "0000000"	 else --add
	          '0' when opcode = "0110011" AND funct3 = "000" AND funct7 = "0100000"	 else --sub
		  '0' when opcode = "1100011" AND funct3 = "000" else --beq
		  '0' when opcode = "1100011" AND funct3 = "001" else --bne
	          '0' when opcode = "0110011" AND funct3 = "110" AND funct7 = "0000000"  else --or
		  '0' when opcode = "0110011" AND funct3 = "111" AND funct7 = "0000000"	   else --and
	          '1' ;

	
	RegWrite <=
		   '0' when opcode="1100011" AND funct3="000" else  --beq
		   '0' when opcode="1100011" AND funct3="001" else  --bne
	           '0' when opcode="0100011" AND funct3="010" else   --sw	
		(not clk);

	
	ImmGen <= "00" when opcode= "0010011" AND  funct3 ="000" else  --addi
		  "00" when opcode= "0010011" AND  funct3 ="111" else  --andi
 		  "00" when opcode = "0010011" AND funct3 ="110" else  --ori
   		  "00" when opcode = "0000011" AND funct3 ="010" else  --lw
		  "01" when opcode="0100011" AND funct3="010" else     --sw
	          "10" when opcode="1100011" AND funct3="000" else     --beq
		  "10" when opcode="1100011" AND funct3="001" else     --bne
		  "11" when opcode = "0110111" else  --lui
		  "00" when opcode ="0010011" AND funct3 ="001" AND funct7 ="0000000" else
		   "00" when opcode ="0010011" AND funct3 ="101" AND funct7 ="0100000" else
	          "ZZ";

	with opcode & funct3 select

		MemWrite <= '1' when "0100011010", --sw
		    	    '0' when others;

	with opcode & funct3 select
	Branch <= "01" when "1100011001", --bne 
		"10" when "1100011000", --beq
		"00" when others;
 
end Boss;

--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ProgramCounter is
    Port(Reset: in std_logic;
	 Clock: in std_logic;
	 PCin: in std_logic_vector(31 downto 0);
	 PCout: out std_logic_vector(31 downto 0));
end entity ProgramCounter;

architecture executive of ProgramCounter is

signal new_Address: std_logic_vector(31 downto 0);
-- Add your code here
begin

	PCProcesso: process(Clock, Reset)
	begin

	if Reset = '1' then
			PCout <= X"003FFFFC"; -- Need to reset to proceed to start at Address of 0x003FFFFC
	elsif rising_edge(Clock) then --  Perhaps falling_edge or rising_edge will be solely implemented for this. 
			PCout <= PCin; -- It diligently maintains the address for  next instruction
		end if;
	end process; 
end executive;
--------------------------------------------------------------------------------
