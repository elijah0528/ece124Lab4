library ieee;
use ieee.std_logic_1164.all;

-- Team members: Elijah Kurien and Wilson Chen

entity holding_register is port (

			clk					: in std_logic;
			reset				: in std_logic;
			register_clr		: in std_logic;
			din					: in std_logic;
			dout				: out std_logic
  );
 end holding_register;
 
 architecture circuit of holding_register is

	Signal sreg				: std_logic;
	signal allres			: std_logic; -- Signal holding all the reset inputs
	signal datain			: std_logic; -- Signal to go into the holding register


BEGIN
	
	process(clk, reset) is
	begin
		allres <= reset OR register_clr;
		datain <= (NOT allres) AND (din OR sreg);

		if(rising_edge(clk)) then
				if(reset = '1') then
					sreg <= '0';
				else
					sreg <= datain;
				end if;
		end if;
	end process;
	dout <= sreg;
	

end;