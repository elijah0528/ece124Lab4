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
   component segment7_mux port (
            clk        	: in  	std_logic := '0';
			 DIN2 			: in  	std_logic_vector(6 downto 0);	--bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DIN1 			: in  	std_logic_vector(6 downto 0); --bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DOUT			: out	std_logic_vector(6 downto 0);
			 DIG2			: out	std_logic;
			 DIG1			: out	std_logic
   );
   end component;

   component clock_generator port (
			sim_mode			: in boolean;
			reset				: in std_logic;
            clkin      		    : in  std_logic;
			sm_clken			: out	std_logic;
			blink		  		: out std_logic
  );
   end component;

    component pb_filters port (
			clkin				: in std_logic;
			rst_n				: in std_logic;
			rst_n_filtered	    : out std_logic;
			pb_n				: in  std_logic_vector (3 downto 0);
			pb_n_filtered	    : out	std_logic_vector(3 downto 0)							 
 );
   end component;
	component pb_inverters port (
			rst_n				: in  std_logic;
			rst				    : out	std_logic;							 
			pb_n_filtered	    : in  std_logic_vector (3 downto 0);
			pb					: out	std_logic_vector(3 downto 0)							 
  );
   end component;
	
component synchronizer port(
		clk					: in std_logic;
		reset					: in std_logic;
		din					: in std_logic;
		dout					: out std_logic 
);
end component; 
component holding_register port (
		clk					: in std_logic;
		reset					: in std_logic;
		register_clr		: in std_logic;
		din					: in std_logic;
		dout					: out std_logic
);
end component;
component StateMachine port(
	clk_in, reset, sm_clken, NSOut, EWOut, blink_sig			: IN std_logic;
	NSClear, EWClear,NSCrossing, EWCrossing, NSgreen, NSyellow, NSred, EWgreen, EWyellow, EWred				: OUT std_logic;
	FourBitNumber															: OUT std_logic_vector(3 downto 0)
);
end component;			
----------------------------------------------------------------------------------------------------
	CONSTANT	sim_mode								: boolean := FALSE;  -- set to FALSE for LogicalStep board downloads																						-- set to TRUE for SIMULATIONS
	SIGNAL rst, rst_n_filtered, synch_rst			    : std_logic;
	SIGNAL sm_clken, blink_sig							: std_logic; 
	SIGNAL pb_n_filtered, pb							: std_logic_vector(3 downto 0); 
	SIGNAL synch2holdingreg1						: std_logic;
	SIGNAL synch2holdingreg2						: std_logic;
	SIGNAL NSred											: std_logic;
	SIGNAL NSyellow										: std_logic;
	SIGNAL NSgreen 										: std_logic;
	SIGNAL EWred											: std_logic;
	SIGNAL EWyellow										: std_logic;
	SIGNAL EWgreen 										: std_logic;
	
	SIGNAL NSOut											: std_logic;
	SIGNAL EWOut											: std_logic;
	SIGNAL NSClear											: std_logic;
	SIGNAL EWClear											: std_logic;
	SIGNAL NSCrossing											: std_logic;
	SIGNAL EWCrossing											: std_logic;
	
	
	SIGNAL FourBitNumber							: std_logic_vector(3 downto 0);
	SIGNAL NS 										: std_logic_vector(6 downto 0);
	SIGNAL EW 										: std_logic_vector(6 downto 0);



	
BEGIN
----------------------------------------------------------------------------------------------------
INST0: pb_filters		port map (clkin_50, rst_n, rst_n_filtered, pb_n, pb_n_filtered);
INST1: pb_inverters		port map (rst_n_filtered, rst, pb_n_filtered, pb);
INST2: clock_generator 	port map (sim_mode, synch_rst, clkin_50, sm_clken, blink_sig);
INST3: synchronizer port map(clkin_50, synch_rst, rst, synch_rst);

NSSync: synchronizer     port map (clkin_50,synch_rst, pb(0), synch2holdingreg1);	-- the synchronizer is also reset by synch_rst.
EWSync: synchronizer     port map (clkin_50,synch_rst, pb(1), synch2holdingreg2);	-- the synchronizer is also reset by synch_rst.

HoldingReg1: holding_register port map(clkin_50, synch_rst, NSClear, synch2holdingreg1, NSOut);
leds(1) <= NSOut;
leds(0) <= NSCrossing;
HoldingReg2: holding_register port map(clkin_50, synch_rst, EWClear, synch2holdingreg2, EWOut);
leds(3) <= EWOut;
leds(2) <= EWCrossing;

myStateMachine: StateMachine port map(clkin_50, synch_rst, sm_clken, NSOut, EWOut, blink_sig, NSClear, EWClear, NSCrossing, EWCrossing, NSgreen, NSyellow, NSred, EWgreen, EWyellow, EWred, FourBitNumber);

leds(7 downto 4) <= FourBitNumber;
NS <= (NSyellow & "00" & NSgreen & "00" & NSred);
EW <= (EWyellow & "00" & EWgreen & "00" & EWred);





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
