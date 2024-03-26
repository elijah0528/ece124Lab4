library ieee;
use ieee.std_logic_1164.all;

-- Team members: Elijah Kurien and Wilson Chen
 
-- Synchronizer entity, which takes pb inputs asychronously and synchornizes outputs with clk
entity synchronizer is port (
			clk			: in std_logic; -- Clock input
			reset		: in std_logic; -- Reset input
			din			: in std_logic; -- Data input
			dout		: out std_logic -- Data output
  );
 end synchronizer;
 
 
architecture circuit of synchronizer is
	Signal sreg				: std_logic_vector(1 downto 0); -- Process construct that advances based on changes in clk
	signal notres			: std_logic; -- Signal for not reset

BEGIN
	-- Begin process to run at the rising edge of the clock
	process (clk) is
	begin
		-- Define not reset
		notres <= not reset;
		-- Sets sreg to shift digits
		if(rising_edge(clk)) then
			sreg(0) <= notres and din;	
			sreg(1) <= notres and sreg(0);
			end if;
	end process;
	-- Assigns sreg to dout
	dout <= sreg(1);
end;