library ieee;
use ieee.std_logic_1164.all;

-- Team members: Elijah Kurien and Wilson Chen

entity PB_inverters is port (
	rst_n				: in	std_logic; -- Reset input
	rst				: out std_logic; -- Inveretd rest output 
 	pb_n_filtered	: in  std_logic_vector (3 downto 0); -- 4-bit input
	pb					: out	std_logic_vector(3 downto 0) -- 4-bit output			 
	); 
end PB_inverters;

architecture ckt of PB_inverters is

begin
rst <= NOT(rst_n); -- Inverts reset
pb <= NOT(pb_n_filtered); -- Inverts filtered pb

end ckt;