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

		-- Rest of the RAM implementation
			if (WE = '1') then
				-- This is for writing data to RAM when write enable is 1. 
				if (to_integer(unsigned(Address)) >= 0 and to_integer(unsigned(Address)) <=127) then

				      i_ram(to_integer(unsigned(Address))) <= DataIn;
				end if;
		
			end if;

	
			if OE = '0' then
			-- This is also for writing data to RAM when Output enable is zero.
				if (to_integer(unsigned(Address)) >= 0 and to_integer(unsigned(Address)) <=127)  then 
					DataOut <= i_ram(to_integer(unsigned(Address)));
				else
					DataOut <= (others => 'Z');
				end if;
			end if;
	end if;

 end process RamProc;

end staticRAM;	


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
signal s_zero, s_one, s_two, s_three, s_four, s_five, s_six, s_seven:std_logic_vector(31 downto 0);
signal writeout: std_logic_vector(7 downto 0);
	
begin
    	-- Add your code here for the Register Bank implementation
	---- Concatenate writecmd and writereg. when writecmd is 1 and it will be seen in the most significant bit right after each when statement. 
	with WriteCmd & WriteReg select

			writeout <=
				"00000001" when "110000",
				"00000010" when "110001",
				"00000100" when "110010",
				"00001000" when "110011",
				"00010000" when "110100",
				"00100000" when "110101",
				"01000000" when "110110",
				"10000000" when "110111",
				"00000000" when others;

-- Note:
--  Out is active low.
--  In is  active high.


-- NOTE:
--
-- s0 is a0
-- s1 is a1
-- s2 is a2
-- s3 is a3
-- s4 is a4
-- s5 is a5
-- s6 is a6
-- s7 is a7
-- Just associating each generate port map statement label correspond to each register highlighted in the lab 5 instruction document in order to avoid confusion and make the code to be readable. 
--
--

------------------------        DataIn     OE32 OE16 OE8  WE32        WE16  WE8  DataOut
	S0: register32 port map(WriteData, '0', '1', '1', writeout(0), '0', '0', s_zero); 
	S1: register32 port map(WriteData, '0', '1', '1', writeout(1), '0', '0', s_one); 
	S2: register32 port map(WriteData, '0', '1', '1', writeout(2), '0', '0', s_two); 
	S3: register32 port map(WriteData, '0', '1', '1', writeout(3), '0', '0', s_three); 
	S4: register32 port map(WriteData, '0', '1', '1', writeout(4), '0', '0', s_four); 
	S5: register32 port map(WriteData, '0', '1', '1', writeout(5), '0', '0', s_five);
	S6: register32 port map(WriteData, '0', '1', '1', writeout(6), '0', '0', s_six); 
	S7: register32 port map(WriteData, '0', '1', '1', writeout(7), '0', '0', s_seven); 

	

	with ReadReg1 select
		ReadData1<= 	X"00000000" when "00000",
				s_zero when "10000",
				s_one when "10001",
				s_two when "10010",
				s_three when "10011",
				s_four when "10100",
				s_five when "10101",
				s_six when "10110",
				s_seven when "10111",
				X"00000000" when others;

	with ReadReg2 select
		ReadData2<= 	X"00000000" when "00000",
				s_zero when "10000",
				s_one when "10001",
				s_two when "10010",
				s_three when "10011",
				s_four when "10100",
				s_five when "10101",
				s_six when "10110",
				s_seven when "10111",
				X"00000000" when others;

end remember;

----------------------------------------------------------------------------------------------------------------------------------------------------------------
