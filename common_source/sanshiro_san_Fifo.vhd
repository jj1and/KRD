----------------------------------------------------------------------------------
-- Company: KamLAND / Tohoku University
-- Engineer: Enomoto Sanshiro
-- 
-- Create Date:    14:52:49 05/11/2007 
-- Design Name: 
-- Module Name:    Fifo - RTL 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FIFO is
    generic (
        WIDTH: integer := 8;
		  DEPTH: integer := 32
    );
    port ( 
	     CLK: in  STD_LOGIC;
        RESET: in  STD_LOGIC;
        DIN: in  STD_LOGIC_VECTOR (WIDTH-1 downto 0);
        DOUT: out  STD_LOGIC_VECTOR (WIDTH-1 downto 0);
        WE: in  STD_LOGIC;
        RE: in  STD_LOGIC;
        EMPTY: out  STD_LOGIC;
        FULL: out  STD_LOGIC
	 );
end FIFO;


architecture RTL of FIFO is
	subtype WORD_T is std_logic_vector(WIDTH-1 downto 0);
	type SRAM_T is array(0 to DEPTH-1) of WORD_T;

	signal SRAM: SRAM_T;
	signal WP: integer range 0 to DEPTH-1;
	signal RP: integer range 0 to DEPTH-1;

begin

	DOUT <= SRAM(RP);
	EMPTY <= '1' when RP = WP else '0';
	FULL <= '1' when WP+1 = RP else '0';
	
	process (CLK)
	begin
		if (CLK'event and CLK = '1') then
			if ((WE = '1') and (WP+1 /= RP)) then
				SRAM(WP) <= DIN;
			end if;
		end if;
	end process;

	process (CLK, RESET)
	begin
		if (RESET = '1') then
			WP <= 0;
		elsif (CLK'event and CLK = '1') then
			if ((WE = '1') and (WP+1 /= RP)) then
				if (WP = DEPTH-1) then
					WP <= 0;
				else
					WP <= WP + 1;
				end if;
			else
				WP <= WP;
			end if;
		end if;
	end process;

	process (CLK, RESET)
	begin
		if (RESET = '1') then
			RP <= 0;
		elsif (CLK'event and CLK='1') then
			if ((RE = '1') and (RP /= WP)) then
				if (RP = DEPTH-1) then
					RP <= 0;
				else
					RP <= RP + 1;
				end if;
			else
				RP <= RP;
			end if;
		end if;
	end process;
	
end RTL;
