--------------------------------------------------------------------------------
-- Mahaed Mohamud & Sean Wright
-- ECEGR 2220 - Microprocessor
-- Lab #5
--
-- Main Objective: 
-- Design a memory module that supports a 32 bits of input/output data and is 30bit addressable. We created an array called ram_type that can store 128 32bit words.
--
-- 
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--
-- LAB #5 - Memory and Register Bank
--
--------------------------------------------------------------------------------
LIBRARY ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity RAM is
    Port(Reset:	  in std_logic;
	 Clock:	  in std_logic;	 
	 OE:      in std_logic;
	 WE:      in std_logic;
	 Address: in std_logic_vector(29 downto 0);
	 DataIn:  in std_logic_vector(31 downto 0);
	 DataOut: out std_logic_vector(31 downto 0));
end entity RAM;

architecture staticRAM of RAM is

   type ram_type is array (0 to 127) of std_logic_vector(31 downto 0);
   signal i_ram : ram_type;


begin

  RamProc: process(Clock, Reset, OE, WE, Address) is

  begin


    if Reset = '1' then
      for i in 0 to 127 loop   
          i_ram(i) <= X"00000000";
      end loop;
    end if;

    if falling_edge(Clock) then
	-- Add code to write data to RAM
	-- Use to_integer(unsigned(Address)) to index the i_ram array

	if WE = '1'  and to_integer(unsigned(Address)) < 128  then
		i_ram (to_integer(unsigned(Address))) <= DataIn(31 downto 0);
 		
	end if;
	
    end if;
	-- Rest of the RAM implementation
    
    if OE = '0' and to_integer(unsigned(Address)) < 128 then
	DataOut <= i_ram(to_integer(unsigned(Address)));
    end if;

 end process RamProc;

end staticRAM;	



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--
-- 
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
LIBRARY ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity Registers is
    Port(ReadReg1: in std_logic_vector(4 downto 0); 
         ReadReg2: in std_logic_vector(4 downto 0); 
         WriteReg: in std_logic_vector(4 downto 0);
	 WriteData: in std_logic_vector(31 downto 0);
	 WriteCmd: in std_logic;
	 ReadData1: out std_logic_vector(31 downto 0);
	 ReadData2: out std_logic_vector(31 downto 0));
end entity Registers;

architecture remember of Registers is
	component register32
  	    port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic;
		 writein32, writein16, writein8: in std_logic;
		 dataout: out std_logic_vector(31 downto 0));
	end component;
	
    -- Add your code here for the Register Bank implementation
signal A0, A1, A2, A3, A4, A5, A6, A7:std_logic_vector(31 downto 0);
signal writeout: std_logic_vector(7 downto 0);
	
begin
    	-- Add your code here for the Register Bank implementation
	---- Concatenate writecmd and writereg. when writecmd is 1 and it will be seen in the most significant bit right after each when statement. 
	with WriteCmd & WriteReg select

			writeout <=
				"00000001" when "101010",
				"00000010" when "101011",
				"00000100" when "101100",
				"00001000" when "101101",
				"00010000" when "101110",
				"00100000" when "101111",
				"01000000" when "110000",
				"10000000" when "110001",
				"00000000" when others;

-- Note:
--  Out is active low.
--  In is  active high.

-- NOTE:
-- 
-- 
-- Just associating each generate port map statement label correspond to each register highlighted in the lab 5 instruction document in order to avoid confusion and make the code to be readable. 
--



------------------------        DataIn     OE32 OE16 OE8  WE32        WE16  WE8  DataOut
	Reg0: register32 port map(WriteData, '0', '1', '1', writeout(0), '0', '0', A0); 
	Reg1: register32 port map(WriteData, '0', '1', '1', writeout(1), '0', '0', A1); 
	Reg2: register32 port map(WriteData, '0', '1', '1', writeout(2), '0', '0', A2); 
	Reg3: register32 port map(WriteData, '0', '1', '1', writeout(3), '0', '0', A3); 
	Reg4: register32 port map(WriteData, '0', '1', '1', writeout(4), '0', '0', A4); 
	Reg5: register32 port map(WriteData, '0', '1', '1', writeout(5), '0', '0', A5);
	Reg6: register32 port map(WriteData, '0', '1', '1', writeout(6), '0', '0', A6); 
	Reg7: register32 port map(WriteData, '0', '1', '1', writeout(7), '0', '0', A7); 

	

	with ReadReg1 select
		ReadData1<= 	A0 when "01010",
				A1 when "01011",
				A2 when "01100",
				A3 when "01101",
				A4 when "01110",
				A5 when "01111",
				A6 when "10000",
				A7 when "10001",
				X"00000000" when others;

	with ReadReg2 select
		ReadData2<= 	A0 when "01010",
				A1 when "01011",
				A2 when "01100",
				A3 when "01101",
				A4 when "01110",
				A5 when "01111",
				A6 when "10000",
				A7 when "10001",
				X"00000000" when others;

end remember;

----------------------------------------------------------------------------------------------------------------------------------------------------------------
