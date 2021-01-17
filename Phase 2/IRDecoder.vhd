LIBRARY IEEE;
USE IEEE.std_logic_1164.all;


-- THE INPUTS ARE THE IR AND THE FLAG REGISTERS AND CLK
-- THE OUTPUTS ARE 8 BIT ADDRESS FOR BRANCHING, ALL CONTROL SIGNALS
-- INSIDE IT HAS THE CONTROL STORE AND A MICRO PC REGISTER AS WELL AS THE PLA FOR THE MICRO PC


ENTITY IR_DECODER IS 
	PORT(
		IR_REGISTER: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		FLAGS: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		CLK,RST: IN STD_LOGIC;
		BRANCH_ADDRESS: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		PC_OUT,MDR_OUT,Z_OUT,TEMP_OUT,PC_IN,Z_IN,TEMP_IN,MDR_IN,MAR_IN,Y_IN,IR_IN,READ_MEM,WRITE_MEM,CLEAR_Y,CARRY_IN,WMFC,ADDRESS_OUT: OUT STD_LOGIC;
		GENERAL_REGISTERS_IN,GENERAL_REGISTERS_OUT: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		ALU_OPERATION: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		
	);
END IR_DECODER;


ARCHITECTURE ARCH1 OF IR_DECODER IS 

--CONTROL STORE FOR MICRO INSTRUCTIONS
COMPONENT ROM IS
	PORT(
		ADDRESS : IN  std_logic_vector(7 DOWNTO 0);
		DATAOUT : OUT std_logic_vector(19 DOWNTO 0)
	);
	
END COMPONENT;


--PLA TO SET THE VALUE OF THE MICRO PC
COMPONENT PLA_COMP IS 
	PORT( 	
		CLK,RST : STD_LOGIC;
		IR_REGISTER : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		FLAGS : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		MICRO_INSTRUCTION : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
		MICRO_PC: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;



--NEEDED SIGNALS
SIGNAL MICRO_PC: STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL MICRO_INSTRUCTION: STD_LOGIC_VECTOR(19 DOWNTO 0);

-- TEMP SIGNALS TO EXTRACT MICRO INSTRUCTION
SIGNAL F1,F5: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL F2: STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL F3,F6: STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL F4,F7,F8,F9,F10: STD_LOGIC;

-- TEMP SIGNALS FOR GENERAL REGISTERS DECODING
SIGNAL REGISTERS_SRC_IN, REGISTERS_SRC_OUT,REGISTERS_DST_IN, REGISTERS_DST_OUT: STD_LOGIC;
SIGNAL GENERAL_IR_DST,GENERAL_IR_SRC: STD_LOGIC_VECTOR( 2 DOWNTO 0);

--- THE DECODER SHOULD GET THE CURRENT MICROINSTRUCTION FROM THE CONTROL STORE USING THE MICRO PC
--- THEN IT SHOULD DECODE THE MICRO INSTRUCTION TO THE CONTROL SIGNALS
--- THEN IT SHOULD CALCULATE THE NEW VALUE OF THE MICRO PC USING THE PLA 



BEGIN

	--HOW TO TAKE THE VALUE FROM THE MICRO PC AND THEN SET IT IN THE SAME CLOCK???


	--PORT MAPS OF NEEDED COMPONENTS
	PLA: PLA_COMP PORT MAP(CLK, RST, IR_REGISTER, FLAGS, MICRO_INSTRUCTION, MICRO_PC); 
	CONTROL_STORE: ROM PORT MAP(MICRO_PC, MICRO_INSTRUCTION); 
	
	-- EXTRACTING MICROINSTRUCTION TO TEMP VARIABLES
	F1 <= MICRO_INSTRUCTION(19 DOWNTO 16);
	F2 <= MICRO_INSTRUCTION(15 DOWNTO 13);
	F3 <= MICRO_INSTRUCTION(12 DOWNTO 11);
	F4 <= MICRO_INSTRUCTION(10);
	F5 <= MICRO_INSTRUCTION(9 DOWNTO 6);
	F6 <= MICRO_INSTRUCTION(5 DOWNTO 4);
	F7 <= MICRO_INSTRUCTION(3);
	F8 <= MICRO_INSTRUCTION(2);
	F9 <= MICRO_INSTRUCTION(1);
	F10 <= MICRO_INSTRUCTION(0);

	-- EXTRACTING VALUES OF REGISTER FOR DECODING
	GENERAL_IR_DST <= IR_REGISTER( 2 DOWNTO 0) ;
	GENERAL_IR_SRC <= IR_REGISTER( 8 DOWNTO 6) ;

	-- Address for branching
	BRANCH_ADDRESS <= IR_REGISTER( 7 DOWNTO 0);

	PROCESS(CLK)
	BEGIN
	IF FALLING_EDGE(CLK) THEN 
		--DECODING OF THE MICROINSTRUCTION FROM THE CONTROL STORE
		-- F1
		CASE F1  IS
			WHEN "0001" =>
				PC_OUT <= '1';
				MDR_OUT <= '0';
				Z_OUT <= '0';
				TEMP_OUT <= '0';
				ADDRESS_OUT <= '0';
				REGISTERS_DST_OUT <= '0';
				REGISTERS_SRC_OUT <= '0';
							
			when "0010" =>
				PC_OUT <= '0';
				MDR_OUT <= '1';
				Z_OUT <= '0';
				TEMP_OUT <= '0';
				ADDRESS_OUT <= '0';
				REGISTERS_DST_OUT <= '0';
				REGISTERS_SRC_OUT <= '0';
							
			when "0011" =>
				PC_OUT <= '0';
				MDR_OUT <= '0';
				Z_OUT <= '1';
				TEMP_OUT <= '0';
				ADDRESS_OUT <= '0';
				REGISTERS_DST_OUT <= '0';
				REGISTERS_SRC_OUT <= '0';
							
			when "0100" =>
				PC_OUT <= '0';
				MDR_OUT <= '0';
				Z_OUT <= '0';
				TEMP_OUT <= '0';
				ADDRESS_OUT <= '0';
				REGISTERS_DST_OUT <= '0';
				REGISTERS_SRC_OUT <= '1';
			
			when "0101" =>
				PC_OUT <= '0';
				MDR_OUT <= '0';
				Z_OUT <= '0';
				TEMP_OUT <= '0';
				ADDRESS_OUT <= '0';
				REGISTERS_DST_OUT <= '1';
				REGISTERS_SRC_OUT <= '0';
			
			when "0110" =>
				PC_OUT <= '0';
				MDR_OUT <= '0';
				Z_OUT <= '0';
				TEMP_OUT <= '1';
				ADDRESS_OUT <= '0';
				REGISTERS_DST_OUT <= '0';
				REGISTERS_SRC_OUT <= '0';
							
			
			when "0111" =>
				PC_OUT <= '0';
				MDR_OUT <= '0';
				Z_OUT <= '0';
				TEMP_OUT <= '0';
				ADDRESS_OUT <= '1';
				REGISTERS_DST_OUT <= '0';
				REGISTERS_SRC_OUT <= '0';
		
			when others =>
				PC_OUT <= '0';
				MDR_OUT <= '0';
				Z_OUT <= '0';
				TEMP_OUT <= '0';
				ADDRESS_OUT <= '0';
				REGISTERS_DST_OUT <= '0';
				REGISTERS_SRC_OUT <= '0';
		
		END CASE;	




		--F2
		CASE F2 IS
			WHEN "001" =>
				PC_IN <= '1';
				IR_IN <= '0';
				Z_IN <= '0';
				TEMP_IN <= '0';
				REGISTERS_DST_IN <= '0';
				REGISTERS_SRC_IN <= '0';

			WHEN "010" =>
				PC_IN <= '0';
				IR_IN <= '1';
				Z_IN <= '0';
				TEMP_IN <= '0';
				REGISTERS_DST_IN <= '0';
				REGISTERS_SRC_IN <= '0';

			WHEN "011" =>
				PC_IN <= '0';
				IR_IN <= '0';
				Z_IN <= '1';
				TEMP_IN <= '0';
				REGISTERS_DST_IN <= '0';
				REGISTERS_SRC_IN <= '0';

			WHEN "100" =>
				PC_IN <= '0';
				IR_IN <= '0';
				Z_IN <= '0';
				TEMP_IN <= '0';
				REGISTERS_DST_IN <= '0';
				REGISTERS_SRC_IN <= '1';

			WHEN "101" =>
				PC_IN <= '0';
				IR_IN <= '0';
				Z_IN <= '0';
				TEMP_IN <= '0';
				REGISTERS_DST_IN <= '1';
				REGISTERS_SRC_IN <= '0';

			WHEN "110" =>
				PC_IN <= '0';
				IR_IN <= '0';
				Z_IN <= '0';
				TEMP_IN <= '1';
				REGISTERS_DST_IN <= '0';
				REGISTERS_SRC_IN <= '0';

			WHEN OTHERS =>
				PC_IN <= '0';
				IR_IN <= '0';
				Z_IN <= '0';
				TEMP_IN <= '0';
				REGISTERS_DST_IN <= '0';
				REGISTERS_SRC_IN <= '0';
		END CASE;
				


		-- SOURCE AND DESTINATION REGISTERS DECODING FOR OUTPUT
		IF REGISTERS_DST_OUT = '1' THEN 
			CASE GENERAL_IR_DST IS
				WHEN "000" =>
					GENERAL_REGISTERS_OUT <= "0000001";
				WHEN "001" =>
					GENERAL_REGISTERS_OUT <= "0000010";
				WHEN "010" =>
					GENERAL_REGISTERS_OUT <= "0000100";
				WHEN "011" =>
					GENERAL_REGISTERS_OUT <= "0001000";
				WHEN "100" =>
					GENERAL_REGISTERS_OUT <= "0010000";
				WHEN "101" =>
					GENERAL_REGISTERS_OUT <= "0100000";
				WHEN "110" =>
					GENERAL_REGISTERS_OUT <= "1000000";
				WHEN OTHERS =>
					GENERAL_REGISTERS_OUT <= "0000000";	
			END CASE;

		ELSIF REGISTERS_SRC_OUT = '1' THEN 
			CASE GENERAL_IR_SRC IS
				WHEN "000" =>
					GENERAL_REGISTERS_OUT <= "0000001";
				WHEN "001" =>
					GENERAL_REGISTERS_OUT <= "0000010";
				WHEN "010" =>
					GENERAL_REGISTERS_OUT <= "0000100";
				WHEN "011" =>
					GENERAL_REGISTERS_OUT <= "0001000";
				WHEN "100" =>
					GENERAL_REGISTERS_OUT <= "0010000";
				WHEN "101" =>
					GENERAL_REGISTERS_OUT <= "0100000";
				WHEN "110" =>
					GENERAL_REGISTERS_OUT <= "1000000";
				WHEN OTHERS =>
					GENERAL_REGISTERS_OUT <= "0000000";	
			END CASE;

		ELSE
			GENERAL_REGISTERS_OUT <= "0000000";
		END IF;



		-- SOURCE AND DESTINATION REGISTERS DECODING FOR INPUT
		IF REGISTERS_DST_IN = '1' THEN 
			CASE GENERAL_IR_DST IS
				WHEN "000" =>
					GENERAL_REGISTERS_IN <= "0000001";
				WHEN "001" =>
					GENERAL_REGISTERS_IN <= "0000010";
				WHEN "010" =>
					GENERAL_REGISTERS_IN <= "0000100";
				WHEN "011" =>
					GENERAL_REGISTERS_IN <= "0001000";
				WHEN "100" =>
					GENERAL_REGISTERS_IN <= "0010000";
				WHEN "101" =>
					GENERAL_REGISTERS_IN <= "0100000";
				WHEN "110" =>
					GENERAL_REGISTERS_IN <= "1000000";
				WHEN OTHERS =>
					GENERAL_REGISTERS_IN <= "0000000";	
			END CASE;

		ELSIF REGISTERS_SRC_IN = '1' THEN 
			CASE GENERAL_IR_SRC IS
				WHEN "000" =>
					GENERAL_REGISTERS_IN <= "0000001";
				WHEN "001" =>
					GENERAL_REGISTERS_IN <= "0000010";
				WHEN "010" =>
					GENERAL_REGISTERS_IN <= "0000100";
				WHEN "011" =>
					GENERAL_REGISTERS_IN <= "0001000";
				WHEN "100" =>
					GENERAL_REGISTERS_IN <= "0010000";
				WHEN "101" =>
					GENERAL_REGISTERS_IN <= "0100000";
				WHEN "110" =>
					GENERAL_REGISTERS_IN <= "1000000";
				WHEN OTHERS =>
					GENERAL_REGISTERS_IN <= "0000000";	
			END CASE;
		ELSE 
			GENERAL_REGISTERS_IN <= "0000000";
		END IF;

	

		--F3
		CASE F3 IS 
			WHEN "01" =>
				MAR_IN <= '1';
				MDR_IN <= '0';
			WHEN "10" =>
				MAR_IN <= '0';
				MDR_IN <= '1';
			WHEN OTHERS =>
				MAR_IN <= '0';
				MDR_IN <= '0';
		END CASE;

		--F4
		CASE F4 IS 
			WHEN '1' =>
				Y_IN <= '1';
			WHEN OTHERS =>
				Y_IN <= '0';
		END CASE;

		--F5
		ALU_OPERATION <= F5;

		--F6
		CASE F6 IS 
			WHEN "01" =>
				READ_MEM <= '1';
				WRITE_MEM <= '0';
			WHEN "10" =>
				READ_MEM <= '0';
				WRITE_MEM <= '1';
			WHEN OTHERS =>
				READ_MEM <= '0';
				WRITE_MEM <= '0';
		END CASE;

		--F7
		CASE F7 IS 
			WHEN '1' =>
				CLEAR_Y <= '1';
			WHEN OTHERS =>
				CLEAR_Y <= '0';
		END CASE;
		
		--F8
		CASE F8 IS 
			WHEN '1' =>
				CARRY_IN <= '1';
			WHEN OTHERS =>
				CARRY_IN <= '0';
		END CASE;

		--F9
		CASE F9 IS 
			WHEN '1' =>
				WMFC <= '1';
			WHEN OTHERS =>
				WMFC <= '0';
		END CASE;
	END IF;
	END PROCESS;

END ARCHITECTURE;