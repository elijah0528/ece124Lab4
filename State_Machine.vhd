library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Team members: Elijah Kurien and Wilson Chen

Entity StateMachine IS Port
(
	clk_in, reset, sm_clken, NSOut, EWOut, blink_sig								: IN std_logic;
	
	NSClear, EWClear,NSCrossing, EWCrossing 								: out std_logic;
	NSgreen, NSyellow, NSred, EWgreen, EWyellow, EWred				: OUT std_logic;
	FourBitNumber																: OUT std_logic_vector(3 downto 0)
);
END ENTITY;
 

Architecture SM of StateMachine

 is


TYPE STATE_NAMES IS (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15);   -- list all the STATE_NAMES values


SIGNAL current_state, next_state	:  STATE_NAMES;     	-- signals of type STATE_NAMES


BEGIN

Register_Section: PROCESS (clk_in) is
BEGIN
	IF(rising_edge(clk_in)) THEN
		IF (reset = '1') THEN
			current_state <= S0;
		ELSIF (reset = '0' and sm_clken = '1') THEN
			current_state <= next_State;
		END IF;
	END IF;
END PROCESS;	


-- TRANSITION LOGIC PROCESS EXAMPLE

Transition_Section: PROCESS (current_state) 

BEGIN
	CASE current_state IS
		WHEN S0 =>
			FourBitNumber <= "0000";
			if(EWOut = '1' AND NSOut = '0')then
				next_state <= S6;
			else
				next_state <= S1;
			end if;
		WHEN S1 =>
			FourBitNumber <= "0001";

			if(EWOut = '1' AND NSOut = '0')then
				next_state <= S6;
			else		
				next_state <= S2;
			end if;
		WHEN S2 =>
			FourBitNumber <= "0010";

		
			next_state <= S3;
		WHEN S3 =>
			FourBitNumber <= "0011";

		
			next_state <= S4;
		WHEN S4 =>
			FourBitNumber <= "0100";

		
			next_state <= S5;
		WHEN S5 =>
			FourBitNumber <= "0101";

		
			next_state <= S6;
		WHEN S6 =>
			FourBitNumber <= "0110";

		
			next_state <= S7;
		WHEN S7 =>
			FourBitNumber <= "0111";

		
			next_state <= S8;
		WHEN S8 =>
			FourBitNumber <= "1000";


			if(EWOut = '0' AND NSOut = '1')then
				next_state <= S14;
			else			
				next_state <= S9;
			end if;
		WHEN S9 =>
			FourBitNumber <= "1001";

		
			if(EWOut = '0' AND NSOut = '1')then
				next_state <= S14;
			else			
				next_state <= S10;
			end if;
		WHEN S10 =>
			FourBitNumber <= "1010";

		
			next_state <= S11;
		WHEN S11 =>
			FourBitNumber <= "1011";

		
			next_state <= S12;
		WHEN S12 =>
			FourBitNumber <= "1100";

	
			next_state <= S13;
		WHEN S13 =>
			FourBitNumber <= "1101";

		
			next_state <= S14;
		WHEN S14 =>
			FourBitNumber <= "1110";

		
			next_state <= S15;
		WHEN S15 =>
			FourBitNumber <= "1111";

		
			next_state <= S0;
		WHEN OTHERS =>
			FourBitNumber <= "0000";

			next_state <= S0;
	END CASE;
END PROCESS;
 
 
-- DECODER SECTION PROCESS EXAMPLE (MOORE FORM SHOWN)

Decoder_Section: PROCESS (current_state) is
BEGIN
    CASE current_state IS
			WHEN S0 =>        
				 NSgreen <= blink_sig;
				 NSyellow <= '0';
				 NSred <= '0';
				 
				 EWgreen <= '0';
				 EWyellow <= '0';
				 EWred <= '1';
				 
				 NSClear <= '0';
 				 EWClear <= '0';
				 NSCrossing <= '0';
				 EWCrossing <= '0';
				 
			WHEN S1 =>        
				 NSgreen <= blink_sig;
				 NSyellow <= '0';
				 NSred <= '0';
				 
				 EWgreen <= '0';
				 EWyellow <= '0';
				 EWred <= '1';
				 
				 NSClear <= '0';
 				 EWClear <= '0';
				 NSCrossing <= '0';
				 EWCrossing <= '0';
				 
			WHEN S2 =>        
				 NSgreen <= '1';
				 NSyellow <= '0';
				 NSred <= '0';
				 
				 EWgreen <= '0';
				 EWyellow <= '0';
				 EWred <= '1';
				 
				 NSClear <= '0';
 				 EWClear <= '0';
				 NSCrossing <= '1';
				 EWCrossing <= '0';
				 
			WHEN S3 =>        
				 NSgreen <= '1';
				 NSyellow <= '0';
				 NSred <= '0';
				 
				 EWgreen <= '0';
				 EWyellow <= '0';
				 EWred <= '1';
				 
				 NSClear <= '0';
 				 EWClear <= '0';
				 NSCrossing <= '1';
				 EWCrossing <= '0';
	
			WHEN S4 =>        
				 NSgreen <= '1';
				 NSyellow <= '0';
				 NSred <= '0';
				 
				 EWgreen <= '0';
				 EWyellow <= '0';
				 EWred <= '1';
				 
				 NSClear <= '0';
 				 EWClear <= '0';
				 NSCrossing <= '1';
				 EWCrossing <= '0';
	
			WHEN S5 =>        
				 NSgreen <= '1';
				 NSyellow <= '0';
				 NSred <= '0';
				 
				 EWgreen <= '0';
				 EWyellow <= '0';
				 EWred <= '1';
				 
				 NSClear <= '0';
 				 EWClear <= '0';
				 NSCrossing <= '1';
				 EWCrossing <= '0';
	

			WHEN S6 =>        
				 NSgreen <= '0';
				 NSyellow <= '1';
				 NSred <= '0';
				 
				 EWgreen <= '0';
				 EWyellow <= '0';
				 EWred <= '1';
				 
				 NSClear <= '1';
 				 EWClear <= '0';
				 NSCrossing <= '0';
				 EWCrossing <= '0';
	

			WHEN S7 =>        
				 NSgreen <= '0';
				 NSyellow <= '1';
				 NSred <= '0';
				 
				 Ewgreen <= '0';
				 EWyellow <= '0';
				 EWred <= '1';
				 
				 NSClear <= '0';
 				 EWClear <= '0';
				 NSCrossing <= '0';
				 EWCrossing <= '0';
	

			WHEN S8 =>        
				 NSgreen <= '0';
				 NSyellow <= '0';
				 NSred <= '1';
				 
				 EWgreen <= blink_sig;
				 EWyellow <= '0';
				 EWred <= '0';
				 
				 NSClear <= '0';
 				 EWClear <= '0';
				 NSCrossing <= '0';
				 EWCrossing <= '0';
	

			WHEN S9 =>        
				 NSgreen <= '0';
				 NSyellow <= '0';
				 NSred <= '1';
				 
				 EWgreen <= blink_sig;
				 EWyellow <= '0';
				 EWred <= '0';
				 
				 NSClear <= '0';
 				 EWClear <= '0';
				 NSCrossing <= '0';
				 EWCrossing <= '0';
	

			WHEN S10 =>        
				 NSgreen <= '0';
				 NSyellow <= '0';
				 NSred <= '1';
				 
				 EWgreen <= '1';
				 EWyellow <= '0';
				 EWred <= '0';
				 
				 NSClear <= '0';
 				 EWClear <= '0';
				 NSCrossing <= '0';
				 EWCrossing <= '1';
	

			WHEN S11 =>        
				 NSgreen <= '0';
				 NSyellow <= '0';
				 NSred <= '1';
				 
				 EWgreen <= '1';
				 EWyellow <= '0';
				 EWred <= '0';
				 
				 NSClear <= '0';
 				 EWClear <= '0';
				 NSCrossing <= '0';
				 EWCrossing <= '1';
	

				 
			WHEN S12 =>        
				 NSgreen <= '0';
				 NSyellow <= '0';
				 NSred <= '1';
				 
				 EWgreen <= '1';
				 EWyellow <= '0';
				 EWred <= '0';
				 
				 NSClear <= '0';
 				 EWClear <= '0';
				 NSCrossing <= '0';
				 EWCrossing <= '1';
	

				 
			WHEN S13 =>        
				 NSgreen <= '0';
				 NSyellow <= '0';
				 NSred <= '1';
				 
				 EWgreen <= '1';
				 EWyellow <= '0';
				 EWred <= '0';
				 
				 NSClear <= '0';
 				 EWClear <= '0';
				 NSCrossing <= '0';
				 EWCrossing <= '1';
	

				 
			WHEN S14 =>        
				 NSgreen <= '0';
				 NSyellow <= '0';
				 NSred <= '1';
				 
				 EWgreen <= '0';
				 EWyellow <= '1';
				 EWred <= '0';
				 
				 NSClear <= '0';
 				 EWClear <= '1';
				 NSCrossing <= '0';
				 EWCrossing <= '0';
	


				 
			WHEN S15 =>        
				 NSgreen <= '0';
				 NSyellow <= '0';
				 NSred <= '1';
				 
				 EWgreen <= '0';
				 EWyellow <= '1';
				 EWred <= '0';
				 
				 NSClear <= '0';
 				 EWClear <= '0';
				 NSCrossing <= '0';
				 EWCrossing <= '0';
	

			WHEN OTHERS =>        
				 NSgreen <= '0';
				 NSyellow <= '0';
				 NSred <= '0';
				 
				 EWgreen <= '0';
				 EWyellow <= '0';
				 EWred <= '0';
				 
				 NSClear <= '0';
 				 EWClear <= '0';
				 NSCrossing <= '0';
				 EWCrossing <= '0';
	


    END CASE;
END PROCESS;

 END ARCHITECTURE SM;
