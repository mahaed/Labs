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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Processor is
    Port ( reset : in  std_logic;
	   clock : in  std_logic);
end Processor;

architecture holistic of Processor is
	component Control
   	     Port( clk : in  STD_LOGIC;
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
	end component;

	component ALU
		Port(DataIn1: in std_logic_vector(31 downto 0);
		     DataIn2: in std_logic_vector(31 downto 0);
		     ALUCtrl: in std_logic_vector(4 downto 0);
		     Zero: out std_logic;
		     ALUResult: out std_logic_vector(31 downto 0) );
	end component;
	
	component Registers
	    Port(ReadReg1: in std_logic_vector(4 downto 0); 
                 ReadReg2: in std_logic_vector(4 downto 0); 
                 WriteReg: in std_logic_vector(4 downto 0);
		 WriteData: in std_logic_vector(31 downto 0);
		 WriteCmd: in std_logic;
		 ReadData1: out std_logic_vector(31 downto 0);
		 ReadData2: out std_logic_vector(31 downto 0));
	end component;

	component InstructionRAM
    	    Port(Reset:	  in std_logic;
		 Clock:	  in std_logic;
		 Address: in std_logic_vector(29 downto 0);
		 DataOut: out std_logic_vector(31 downto 0));
	end component;

	component RAM 
	    Port(Reset:	  in std_logic;
		 Clock:	  in std_logic;	 
		 OE:      in std_logic;
		 WE:      in std_logic;
		 Address: in std_logic_vector(29 downto 0);
		 DataIn:  in std_logic_vector(31 downto 0);
		 DataOut: out std_logic_vector(31 downto 0));
	end component;
	
	component BusMux2to1
		Port(selector: in std_logic;
		     In0, In1: in std_logic_vector(31 downto 0);
		     Result: out std_logic_vector(31 downto 0) );
	end component;
	
	component ProgramCounter
	    Port(Reset: in std_logic;
		 Clock: in std_logic;
		 PCin: in std_logic_vector(31 downto 0);
		 PCout: out std_logic_vector(31 downto 0));
	end component;

	component adder_subtracter
		port(	datain_a: in std_logic_vector(31 downto 0);
			datain_b: in std_logic_vector(31 downto 0);
			add_sub: in std_logic;
			dataout: out std_logic_vector(31 downto 0);
			co: out std_logic);
	end component adder_subtracter;

--	----The DataOutSig RAM Signal (for lab 5 -memory.vhd)
--	signal DataOut: std_logic_vector(31 downto 0);
--	signal PCBranch: std_logic_vector(31 downto 0);
--	signal ReadData: std_logic_vector(31 downto 0);
--
--	----- The Program Counter Signals for The Program
--	signal PCOutput: std_logic_vector(31 downto 0);
--	signal PC_four: std_logic_vector(31 downto 0);
--	signal PC_Next: std_logic_vector(31 downto 0);
--
--
--
--	----- The Control Signals 
--	signal funct7: std_logic_vector (6 downto 0);	
--	signal funct3: std_logic_vector(2 downto 0);
--	signal opcode: std_logic_vector(6 downto 0);
--	signal Branch: std_logic_vector(1 downto 0);
--	signal MemReg: std_logic;
--	signal MemRead: std_logic;
--	signal ALUCtrl: std_logic_vector (4 downto 0);
--	signal MemWrite: std_logic;
--	signal ALUSrc: std_logic;
--	signal RegWrite: std_logic;
--	signal ImmGen: std_logic_vector (1 downto 0);
--
--
--
--	----- The Standard ALU Signals
--	signal DataIn1: std_logic_vector(31 downto 0);
--	signal DataIn2: std_logic_vector(31 downto 0);
--	signal ALUCtrlSig: std_logic_vector(4 downto 0);
--	signal Zero: std_logic;
--	signal ALUResult: std_logic_vector(31 downto 0);
--	signal BranchResult: std_logic_vector(2 downto 0);
--
--
--
--	------ The Standard Registers Signals
--	signal ReadReg1: std_logic_vector(4 downto 0);
--	signal ReadReg2: std_logic_vector(4 downto 0);
--	signal WriteReg: std_logic_vector(4 downto 0);
--	signal WriteData: std_logic_vector(31 downto 0);
--	signal WriteCmd: std_logic;
--	signal ReadData1: std_logic_vector(31 downto 0);
--	signal ReadData2: std_logic_vector(31 downto 0);
--
--
--
--	----- The Standard RAM Signals
--	signal OE: std_logic;
--	signal WE: std_logic;
--	signal Address: std_logic_vector(29 downto 0);
--	signal DataIn: std_logic_vector(31 downto 0);
--	signal DataOutSin: std_logic_vector(31 downto 0);
--
--
--
--	---- The Muxes Output (BusMuxtwoto1) Signals
--	signal selector: std_logic;
--	signal In0: std_logic_vector(31 downto 0);
--	signal In1: std_logic_vector(31 downto 0);
--	signal Result: std_logic_vector(31 downto 0);
--
--
--
--	----  The Adders/Subtractor Signals
--	signal datain_a: std_logic_vector(31 downto 0);
--	signal datain_b: std_logic_vector(31 downto 0);
--	signal add_sub: std_logic;
--
--
--
--
--	---- The IMMEDIATE Generator Output
--	signal ImmGenResult: std_logic_vector(31 downto 0);
--	signal finished: std_logic_vector(29 downto 0);
--	-- signal ImmCtrlGen: std_logic_vector(1 downto 0);
	






	-- Add your code here.
	

	-- The WHole Enumerated LIST of Signals can be seen below. 

	-- The Program Counter
	signal PC_Out: std_logic_vector( 31 downto 0);


	-- The Adder Signals
	signal add_Out1: std_logic_vector(31 downto 0);
	signal add_Out2: std_logic_vector(31 downto 0);

	signal co1: std_logic;
	signal co2: std_logic; 

	-- The Instruction Memory Output
	signal Instruction_mem: std_logic_vector(31 downto 0);


	-- Control Outputs
	signal CtrlBranch: std_logic_vector(1 downto 0); -- Control for branch : eq/ not eq (For beq and bne).
	signal CtrlMemRead: std_logic; 
	signal CtrlMemtoReg: std_logic;
	signal CtrlALUCtrl: std_logic_vector(4 downto 0);
	signal CtrlMemWrite: std_logic;
	signal CtrlALUSrc: std_logic;	
	signal CtrlRegWrite: std_logic;
	signal CtrlImmGen: std_logic_vector(1 downto 0);


	-- Registers  and Data Memory Outputs
	signal ReadD1: std_logic_vector(31 downto 0 ); -- registers connecting to the ALU
	signal ReadD2: std_logic_vector(31 downto 0 ); --

	signal ReadDMem: std_logic_vector(31 downto 0);	

	
	-- Mux Outputs	
	signal TheMuxToALU: std_logic_vector(31 downto 0); -- The Mux to the ALU.  
	signal TheMuxToWriteD: std_logic_vector(31 downto 0); -- The Mux to the reg write Data. 
	signal TheMuxToThePC: std_logic_vector(31 downto 0);-- The Mux to the PC(Program Counter). 

	-- ALU Outputs
	signal ALUResultOut: std_logic_vector(31 downto 0);
	signal ALUZero: std_logic;
	signal BranchNotEq: std_logic;


	-- Immediate Generator Output
	signal immgeno: std_logic_vector(31 downto 0);

	-- A temporary  signal to hold/concenate values.
	signal finished: std_logic_vector(29 downto 0);



begin
	-- Add your code here
	finished <= "0000" & ALUResultOut(27 downto 2);

	with CtrlBranch & ALUZero select
			BranchNotEq <=  
					'0' when "001", -- BEQ
					'1' when "101", -- BEQ
					'1' when "010", -- BNE
					'0' when others; --anything else PC+4


					--'1' when "101",
                			--'1' when "010",
					--'0' when others;
	
	with CtrlImmGen & Instruction_mem(31) select
			immgeno <=   "11111111111111111111" & Instruction_mem(7) & Instruction_mem(30 downto 25) & Instruction_mem(11 downto 8) & '0' when "101", -- Btype			  
	                             "00000000000000000000" & Instruction_mem(7) & Instruction_mem(30 downto 25) & Instruction_mem(11 downto 8) & '0' when "100", -- B type
				     "1" & Instruction_mem(30 downto 12) & "000000000000" when "111", -- U type				  
	                             "0" & Instruction_mem(30 downto 12) & "000000000000" when "110", -- U type
				     "111111111111111111111" & Instruction_mem(30 downto 25) & Instruction_mem(11 downto 7) when "011",  -- S type				  
	                             "000000000000000000000" & Instruction_mem(30 downto 25) & Instruction_mem(11 downto 7) when "010",  -- S type
				     "111111111111111111111" & Instruction_mem(30 downto 20) when "001",  -- I type				  
				     "000000000000000000000" & Instruction_mem(30 downto 20) when "000",  -- I type				     
	                             "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" when others;




	ALUMux: BusMux2to1 port map( CtrlALUSrc, ReadD2 ,  immgeno, TheMuxToALU);
	AdderMux: BusMux2to1   port map(BranchNotEq, add_Out1, add_Out2,TheMuxToThePC);
	DataMemMux: BusMux2to1  port map(CtrlMemtoReg, ALUResultOut, ReadDMem, TheMuxToWriteD);


	PreADD4: adder_subtracter port map(PC_Out,  "00000000000000000000000000000100", '0', add_Out1, co1);
	ADDSumOp: adder_subtracter port map(PC_Out, immgeno, '0', add_Out2, co2);
	
	---- This is for the Data Path from the left to the right. 
	PCCounter: ProgramCounter port map(reset, clock, TheMuxToThePC, PC_Out);
	ProcessCtrl: Control port map(clock, Instruction_mem(6 downto 0), Instruction_mem(14 downto 12), Instruction_mem(31 downto 25), CtrlBranch, CtrlMemRead, CtrlMemtoReg, CtrlALUCtrl, CtrlMemWrite, CtrlALUSrc, CtrlRegWrite, CtrlImmGen);

	InstnMem: InstructionRAM port map(reset, clock, PC_Out(31 downto 2), Instruction_mem);
	
	RegisterBank: Registers port map(Instruction_mem(19 downto 15), Instruction_mem(24 downto 20), Instruction_mem(11 downto 7), TheMuxToWriteD, CtrlRegWrite, ReadD1, ReadD2);
	
	ArithLU: ALU port map(ReadD1, TheMuxToALU, CtrlALUCtrl, ALUZero, ALUResultOut);

	DataMem: RAM port map(reset, clock, CtrlMemRead, CtrlMemWrite, finished, ReadD2, ReadDMem);


end holistic;

