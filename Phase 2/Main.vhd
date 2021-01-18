LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

entity PDP is
  GENERIC (n : integer:=16);
  port (
    CLK, RST: IN std_logic
  ) ;
end PDP;

architecture PDP_ARCH of PDP is

    component ALU IS
        GENERIC (n : integer:=16);
        PORT ( A,B: IN std_logic_vector (n-1 DOWNTO 0);
        SEL: IN std_logic_vector (3 DOWNTO 0);
        FLAG : INOUT std_logic_vector (2 DOWNTO 0);
        C : OUT std_logic_vector (n-1 DOWNTO 0));
    END component;

    component mREGISTER IS
	GENERIC (n : INTEGER := 16);
	PORT (
		clk, RST, enable : IN STD_LOGIC;
		d : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
		q : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0));
    END component;

    component tristate IS
    generic(num: integer:= 16);
    PORT( enable : IN std_logic;
            d : IN std_logic_vector(num-1 downto 0);
            q : OUT std_logic_vector(num-1 downto 0));
    END component;

    component IR_DECODER IS 
      PORT(
        IR_REGISTER: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        FLAGS: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        CLK,RST: IN STD_LOGIC;
        BRANCH_ADDRESS: INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        PC_OUT,MDR_OUT,Z_OUT,TEMP_OUT,PC_IN,Z_IN,TEMP_IN,MDR_IN,MAR_IN,Y_IN,IR_IN,READ_MEM,WRITE_MEM,CLEAR_Y,CARRY_IN,WMFC,ADDRESS_OUT: OUT STD_LOGIC;
        GENERAL_REGISTERS_IN,GENERAL_REGISTERS_OUT: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        ALU_OPERATION: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        
      );
    END component;

    component ram IS
      GENERIC (n : INTEGER := 16);
      PORT (
        clk : IN STD_LOGIC;
        w : IN STD_LOGIC;
        r : IN STD_LOGIC;
        WMFC : INOUT STD_LOGIC;
        address : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        data : INOUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        WRITE_TO_MDR : OUT STD_LOGIC);
    END component;

    signal PDP_BUS: STD_LOGIC_VECTOR(n - 1 DOWNTO 0):= (OTHERS => '0');
    signal Z,Y,ALU_OUT: STD_LOGIC_VECTOR(n - 1 DOWNTO 0):= (OTHERS => '0');
    signal R0,R1,R2,R3,R4,R5,SP,PC,IR,MAR,MDR,TEMP: STD_LOGIC_VECTOR(n - 1 DOWNTO 0):= (OTHERS => '0');
    signal FLAG: STD_LOGIC_VECTOR(2 DOWNTO 0):= (OTHERS => '0');
    signal PC_OUT,MDR_OUT,Z_OUT,TEMP_OUT,PC_IN,Z_IN,TEMP_IN,MDR_IN,MAR_IN,Y_IN,IR_IN,READ_MEM,WRITE_MEM,CLEAR_Y,CARRY_IN,WMFC,ADDRESS_OUT:STD_LOGIC;
    signal GENERAL_REGISTERS_IN,GENERAL_REGISTERS_OUT: STD_LOGIC_VECTOR(6 DOWNTO 0);
    signal ALU_OPERATION:  STD_LOGIC_VECTOR(3 DOWNTO 0);
    signal RAM_DATA : STD_LOGIC_VECTOR(n - 1 DOWNTO 0):= (OTHERS => '0');
    signal MDR_DATA_IN : STD_LOGIC_VECTOR(n - 1 DOWNTO 0):= (OTHERS => '0');
    signal MDR_SELECTOR : STD_LOGIC:='0';
    signal BRANCH_ADDRESS: STD_LOGIC_VECTOR(n-1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL CLEAR_RST_Y,RAM_TO_MDR: STD_LOGIC:= '0'; 

begin
    
    MDR_SELECTOR <= MDR_IN OR RAM_TO_MDR;
    MDR_DATA_IN <= PDP_BUS WHEN MDR_IN = '1' ELSE RAM_DATA WHEN RAM_TO_MDR = '1';
    CLEAR_RST_Y <= RST OR CLEAR_Y;

    REG_R0: mREGISTER GENERIC MAP(n) PORT MAP(CLK,RST,GENERAL_REGISTERS_IN(0),PDP_BUS,R0);
    REG_R1: mREGISTER GENERIC MAP(n) PORT MAP(CLK,RST,GENERAL_REGISTERS_IN(1),PDP_BUS,R1);
    REG_R2: mREGISTER GENERIC MAP(n) PORT MAP(CLK,RST,GENERAL_REGISTERS_IN(2),PDP_BUS,R2);
    REG_R3: mREGISTER GENERIC MAP(n) PORT MAP(CLK,RST,GENERAL_REGISTERS_IN(3),PDP_BUS,R3);
    REG_R4: mREGISTER GENERIC MAP(n) PORT MAP(CLK,RST,GENERAL_REGISTERS_IN(4),PDP_BUS,R4);
    REG_R5: mREGISTER GENERIC MAP(n) PORT MAP(CLK,RST,GENERAL_REGISTERS_IN(5),PDP_BUS,R5);
    REG_SP: mREGISTER GENERIC MAP(n) PORT MAP(CLK,RST,GENERAL_REGISTERS_IN(6),PDP_BUS,SP);
    REG_PC: mREGISTER GENERIC MAP(n) PORT MAP(CLK,RST,PC_IN,PDP_BUS,PC);
    REG_IR: mREGISTER GENERIC MAP(n) PORT MAP(CLK,RST,IR_IN,PDP_BUS,IR);
    REG_MAR: mREGISTER GENERIC MAP(n) PORT MAP(CLK,RST,MAR_IN,PDP_BUS,MAR);
    REG_MDR: mREGISTER GENERIC MAP(n) PORT MAP(CLK,RST,MDR_SELECTOR,MDR_DATA_IN,MDR);
    REG_TEMP: mREGISTER GENERIC MAP(n) PORT MAP(CLK,RST,TEMP_IN,PDP_BUS,TEMP);
    -- REG_Y: mREGISTER GENERIC MAP(n) PORT MAP(CLK,CLEAR_RST_Y,Y_IN,PDP_BUS,Y);
    REG_Z: mREGISTER GENERIC MAP(n) PORT MAP(CLK,RST,Z_IN,ALU_OUT,Z);

    Y <= PDP_BUS WHEN Y_IN = '1'
      ELSE (OTHERS => '0') WHEN CLEAR_RST_Y = '1'
      ELSE Y;

    TRI_R0:   tristate GENERIC MAP(n) PORT MAP(GENERAL_REGISTERS_OUT(0) ,R0,PDP_BUS);
    TRI_R1:   tristate GENERIC MAP(n) PORT MAP(GENERAL_REGISTERS_OUT(1) ,R1,PDP_BUS);
    TRI_R2:   tristate GENERIC MAP(n) PORT MAP(GENERAL_REGISTERS_OUT(2) ,R2,PDP_BUS);
    TRI_R3:   tristate GENERIC MAP(n) PORT MAP(GENERAL_REGISTERS_OUT(3) ,R3,PDP_BUS);
    TRI_R4:   tristate GENERIC MAP(n) PORT MAP(GENERAL_REGISTERS_OUT(4) ,R4,PDP_BUS);
    TRI_R5:   tristate GENERIC MAP(n) PORT MAP(GENERAL_REGISTERS_OUT(5) ,R5,PDP_BUS);
    TRI_SP:   tristate GENERIC MAP(n) PORT MAP(GENERAL_REGISTERS_OUT(6) ,SP,PDP_BUS);
    TRI_PC:   tristate GENERIC MAP(n) PORT MAP(PC_OUT ,PC,PDP_BUS);
    TRI_MDR:  tristate GENERIC MAP(n) PORT MAP(MDR_OUT,MDR,PDP_BUS);
    TRI_TEMP: tristate GENERIC MAP(n) PORT MAP(TEMP_OUT,TEMP,PDP_BUS);
    TRI_Z:    tristate GENERIC MAP(n) PORT MAP(Z_OUT,Z,PDP_BUS);
    TRI_IR:   tristate GENERIC MAP(n) PORT MAP(ADDRESS_OUT,BRANCH_ADDRESS,PDP_BUS);

    ALU_PORTMAP: ALU GENERIC MAP(n) PORT MAP(Y,PDP_BUS,ALU_OPERATION,FLAG,ALU_OUT);

    RAM_PORTMAP: ram GENERIC MAP(n) PORT MAP(CLK,WRITE_MEM,READ_MEM,WMFC,MAR,RAM_DATA, RAM_TO_MDR);

    DECODER_PORTMAP: IR_DECODER GENERIC MAP(n) PORT MAP(IR,FLAG,CLK,RST,BRANCH_ADDRESS,PC_OUT,MDR_OUT,Z_OUT,TEMP_OUT,PC_IN,Z_IN,TEMP_IN,MDR_IN,MAR_IN,Y_IN,IR_IN,READ_MEM,WRITE_MEM,CLEAR_Y,CARRY_IN,WMFC,ADDRESS_OUT,GENERAL_REGISTERS_IN,GENERAL_REGISTERS_OUT,ALU_OPERATION);

    end PDP_ARCH ; -- PDP_ARCH