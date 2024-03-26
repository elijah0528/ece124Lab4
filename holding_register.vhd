library ieee;
use ieee.std_logic_1164.all;

-- Team members: Elijah Kurien and Wilson Chen

-- Holding register entity, which holds pb input values until logic gate conditions are met
entity holding_register is port (
			clk				:	in std_logic;
			reset			:	in std_logic;
			register_clr	:	in std_logic;
			din				:	in std_logic;
			dout			:	out std_logic
	);
end holding_register;

architecture circuit of holding_register is
	Signal sreg		:	std_logic;
	signal allres	:	std_logic; -- Signal holding all the reset inputs
	signal datain	:	std_logic; -- Signal to go into the holding register


BEGIN
	-- Process block sensitive to clock and reset signal changes
	process(clk, reset) is
	begin
    	-- Logic to combine reset and register clear signals
		allres <= reset OR register_clr;
		-- Logic to determine the input to the holding register based on reset/clear conditions
		datain <= (NOT allres) AND (din OR sreg);
		
		-- On the rising edge of the clock, update the internal register (sreg) based on conditions
		if (rising_edge(clk)) then
				if (reset = '1') then
					sreg <= '0'; -- If reset is 1, clear the register
				else
					sreg <= datain; -- Otherwise, update the register with the processed input data
				end if;
		end if;
	end process;
	 -- Output the value stored in the internal register
	dout <= sreg;
end;