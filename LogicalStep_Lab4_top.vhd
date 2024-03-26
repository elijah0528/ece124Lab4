LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- Team members: Elijah Kurien and Wilson Chen

ENTITY LogicalStep_Lab4_top IS PORT (
   	clkin_50	: in	std_logic; -- The 50 MHz FPGA Clockinput
	rst_n		: in	std_logic; -- The RESET input (ACTIVE LOW)
	pb_n		: in	std_logic_vector(3 downto 0); -- The push-button inputs (ACTIVE LOW)
 	sw   		: in  	std_logic_vector(7 downto 0); -- The switch inputs
   	leds		: out 	std_logic_vector(7 downto 0); -- for displaying the the lab4 project details
	-------------------------------------------------------------
	-- you can add temporary output ports here if you need to debug your design 
	-- or to add internal signals for your simulations
	-------------------------------------------------------------
	
   	seg7_data 	: out 	std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1	: out	std_logic;							-- seg7 digi selectors
	seg7_char2	: out	std_logic							-- seg7 digi selectors
	
	-- Outputs for waveform
	-- sim_sm_clken, sim_blink_sig 											:  out std_logic;
	-- sim_NSgreen, sim_NSyellow, sim_NSred, sim_EWgreen, sim_EWyellow, sim_EWred	:	out std_logic
	);
END LogicalStep_Lab4_top;

ARCHITECTURE SimpleCircuit OF LogicalStep_Lab4_top IS
	-- segment7_mux component
   component segment7_mux port (
            clk        	: in  	std_logic := '0';
			 DIN2 			: in  	std_logic_vector(6 downto 0);	-- bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DIN1 			: in  	std_logic_vector(6 downto 0); -- bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DOUT			: out	std_logic_vector(6 downto 0); -- Output is 7-bit vector
			 DIG2			: out	std_logic; -- 1-bit output for DIG2
			 DIG1			: out	std_logic -- 1-bit output for DIG1
   );
   end component;
	-- Clock generator component
   component clock_generator port (
			sim_mode			: in boolean; -- Boolean for simulation
			reset				: in std_logic; -- Reset bit
            clkin      		    : in  std_logic; -- Clock input
			sm_clken			: out	std_logic; -- Clock enable
			blink		  		: out std_logic -- Blink output
  );
   end component;
	-- pb filter component
    component pb_filters port (
			clkin				: in std_logic; -- Clock input
			rst_n				: in std_logic; -- Reset input in active low
			rst_n_filtered	    : out std_logic; -- Filtered reset output in active low
			pb_n				: in  std_logic_vector (3 downto 0); -- pb input for 4-bit in active low
			pb_n_filtered	    : out	std_logic_vector(3 downto 0) -- Filtered pb input for 4-bit in active low					 
 );
   end component;
   -- pb inverter component
	component pb_inverters port (
			rst_n				: in  std_logic; -- Input reset bit
			rst				    : out	std_logic; -- Output reset bit which is inverted						 
			pb_n_filtered	    : in  std_logic_vector (3 downto 0); -- 4-bit vector
			pb					: out	std_logic_vector(3 downto 0) -- 4-bit vector for inverted buttons				 
  );
   end component;
-- Synchronizer component
component synchronizer port(
		clk					: in std_logic; -- Clock
		reset					: in std_logic; -- Reset
		din					: in std_logic; -- Data input
		dout					: out std_logic -- Data output
);
end component; 
-- Holding register component
component holding_register port (
		clk					: in std_logic; -- Clock
		reset					: in std_logic; -- Reset
		register_clr		: in std_logic; -- Register clear input
		din					: in std_logic; -- Data input
		dout					: out std_logic -- Data ouput
);
end component;
-- State machine component
component StateMachine port(
	clk_in, reset, sm_clken, NSOut, EWOut, blink_sig												: IN std_logic; -- Input bits for clock, reset, enable, NS/ES requests, and blink sig
	NSClear, EWClear,NSCrossing, EWCrossing, NSgreen, NSyellow, NSred, EWgreen, EWyellow, EWred		: OUT std_logic; -- Output bits for NS/ES red, amber, green
	FourBitNumber																					: OUT std_logic_vector(3 downto 0) -- Logic vector represents states in binary
);
end component;			
----------------------------------------------------------------------------------------------------
	CONSTANT	sim_mode								: boolean := FALSE;  -- set to FALSE for LogicalStep board downloads set to TRUE for SIMULATIONS
	SIGNAL rst, rst_n_filtered, synch_rst			    : std_logic; -- Holds reset values
	SIGNAL sm_clken, blink_sig							: std_logic; -- Holding enable and blink sig
	SIGNAL pb_n_filtered, pb							: std_logic_vector(3 downto 0); -- Holding pb values
	SIGNAL synch2holdingreg1						: std_logic;
	SIGNAL synch2holdingreg2						: std_logic;
	-- Holds NS/EW lights
	SIGNAL NSred											: std_logic;
	SIGNAL NSyellow										: std_logic;
	SIGNAL NSgreen 										: std_logic;
	SIGNAL EWred											: std_logic;
	SIGNAL EWyellow										: std_logic;
	SIGNAL EWgreen 										: std_logic;
	-- NS/EW requests
	SIGNAL NSOut											: std_logic;
	SIGNAL EWOut											: std_logic;
	-- Pedestrian request clear signals
	SIGNAL NSClear											: std_logic;
	SIGNAL EWClear											: std_logic;
	-- NS/EW lights
	SIGNAL NSCrossing											: std_logic;
	SIGNAL EWCrossing											: std_logic;
	
	SIGNAL FourBitNumber							: std_logic_vector(3 downto 0); -- Holds 4-bit value for representing states
	-- Holds concatenated traffic digit value
	SIGNAL NS 										: std_logic_vector(6 downto 0);
	SIGNAL EW 										: std_logic_vector(6 downto 0);

	
BEGIN
----------------------------------------------------------------------------------------------------
-- Instances of internal components, connecting inputs and outputs to internal signals or top-level ports

-- Push-button filter and inverter instances for the pbs
INST0: pb_filters		port map (clkin_50, rst_n, rst_n_filtered, pb_n, pb_n_filtered);
INST1: pb_inverters		port map (rst_n_filtered, rst, pb_n_filtered, pb);

-- Clock generator
INST2: clock_generator 	port map (sim_mode, synch_rst, clkin_50, sm_clken, blink_sig);

-- Generates the synchronous reset signal
INST3: synchronizer port map(clkin_50, synch_rst, rst, synch_rst);

-- Synchronizer for NS and EW traffic light
NSSync: synchronizer     port map (clkin_50,synch_rst, pb(0), synch2holdingreg1);	-- the synchronizer is also reset by synch_rst.
EWSync: synchronizer     port map (clkin_50,synch_rst, pb(1), synch2holdingreg2);	-- the synchronizer is also reset by synch_rst.

-- Holding registers ofr NS and EW traffic light
HoldingReg1: holding_register port map(clkin_50, synch_rst, NSClear, synch2holdingreg1, NSOut);
leds(1) <= NSOut; -- Crossing request for NS
leds(0) <= NSCrossing; -- Crossing signal for NS
HoldingReg2: holding_register port map(clkin_50, synch_rst, EWClear, synch2holdingreg2, EWOut);
leds(3) <= EWOut; -- Crossing request for EW
leds(2) <= EWCrossing; -- Crossing signal for EW

-- Generates instance of state machine that manages state transitions and controls traffic lights
myStateMachine: StateMachine port map(clkin_50, synch_rst, sm_clken, NSOut, EWOut, blink_sig, NSClear, EWClear, NSCrossing, EWCrossing, NSgreen, NSyellow, NSred, EWgreen, EWyellow, EWred, FourBitNumber);
-- Displays which state the TLC is in
leds(7 downto 4) <= FourBitNumber;

-- Holds concatenated traffic light values
NS <= (NSyellow & "00" & NSgreen & "00" & NSred);
EW <= (EWyellow & "00" & EWgreen & "00" & EWred);

-- segment7_mux to display the traffic light values on FPGA (red, amber and green)
SevenSeg: segment7_mux port map(clkin_50, NS, EW, seg7_data, seg7_char2, seg7_char1);

-- Output ports for simulation
-- sim_sm_clken <= sm_clken;
-- sim_blink_sig <= blink_sig;
-- sim_NSgreen <= NSgreen;
-- sim_NSyellow <= NSyellow;
-- sim_NSred <= NSred;
-- sim_EWgreen <= EWgreen;
-- sim_EWyellow <= EWyellow;
-- sim_EWred <= EWred;

END SimpleCircuit;
