LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY rom IS
	PORT(
		address : IN  std_logic_vector(7 DOWNTO 0);
		dataout : OUT std_logic_vector(19 DOWNTO 0));
END rom;

ARCHITECTURE arch_rom OF rom IS

	TYPE rom_type IS ARRAY(0 TO 511) OF std_logic_vector(19 DOWNTO 0);
    
	SIGNAL rom : rom_type := (
        8#000# =>	"00010110111101010000",
        8#001# =>	"00110010000000000010",
        8#002# =>	"00100100000000000000",
        8#003# =>	"00000000000000110000",
        8#004# =>	"00011110010000110000",
        8#005# =>	"01110110000000000000",
        8#006# =>	"00110010000000000001",
        8#007# =>	"10000000000000000001",
        8#010# =>	"10010000000000000001",
        8#011# =>	"00000000000000000001",
        8#012# =>	"01100110000000000100",
        8#013# =>	"00000000000000110000",
        8#014# =>	"01100110000001000100",
        8#015# =>	"00000000000000110000",
        8#016# =>	"01100110000010000100",
        8#017# =>	"00000000000000110000",
        8#020# =>	"01100110000011000100",
        8#021# =>	"00000000000000110000",
        8#022# =>	"01100110000100000100",
        8#023# =>	"00000000000000110000",
        8#024# =>	"01100110000101000100",
        8#025# =>	"00000000000000110000",
        8#026# =>	"01100110000110000100",
        8#027# =>	"00000000000000110000",
        8#030# =>	"00000110000111000100",
        8#031# =>	"00000000000000110000",
        8#032# =>	"00000110001000000100",
        8#033# =>	"00000000000000110000",
        8#034# =>	"00000110001001000100",
        8#035# =>	"00000000000000110000",
        8#036# =>	"00000110001010000100",
        8#037# =>	"00000000000000110000",
        8#040# =>	"00000110001011000100",
        8#041# =>	"00000000000000110000",
        8#042# =>	"00000110001100000100",
        8#043# =>	"00000000000000110000",
        8#044# =>	"00000110001101000100",
        8#045# =>	"00000000000000110000",
        8#046# =>	"00000110001110000100",
        8#047# =>	"00000000000000110000",
        8#050# =>	"00000110001111001100",
        8#051# =>	"00000000000000110000",
        8#052# =>	"01100110011111000100",
        8#053# =>	"00000000000000110000",
        8#054# =>	"01100000000010000101",
        8#101# =>	"01001100000000000000",
        8#102# =>	"00000000000000110000",
        8#111# =>	"01000000100000010000",
        8#112# =>	"00000000000000110010",
        8#121# =>	"01000110111101010000",
        8#122# =>	"00111000000000000000",
        8#123# =>	"00000000000000110010",
        8#141# =>	"01000110011110000000",
        8#142# =>	"00111000100000010000",
        8#143# =>	"00000000000000110010",
        8#161# =>	"00010110111101010000",
        8#162# =>	"00110010000000000010",
        8#163# =>	"00100000010000000000",
        8#164# =>	"01000110000000000000",
        8#165# =>	"00110000100000010010",
        8#166# =>	"00100000100000010010",
        8#167# =>	"00101100000000000000",
        8#170# =>	"00000000000000110010",
        8#201# =>	"01010000010000000000",
        8#202# =>	"00000000000000110000",
        8#211# =>	"01010000100000010000",
        8#212# =>	"00000000000000110010",
        8#221# =>	"01010110111101010000",
        8#222# =>	"00111010000000000000",
        8#223# =>	"00000000000000110010",
        8#241# =>	"01010110011110000000",
        8#242# =>	"00111010100000010000",
        8#243# =>	"00000000000000110010",
        8#261# =>	"00010110111101010000",
        8#262# =>	"00110010000000000010",
        8#263# =>	"00100000010000000000",
        8#264# =>	"01010110000000000000",
        8#265# =>	"00110000100000010010",
        8#266# =>	"00100000100000010010",
        8#267# =>	"00100000010000000000",
        8#270# =>	"00000000000000110000",
        8#274# =>	"00110001000000100001",
        8#275# =>	"00111010000000000001",
        OTHERS => "00000000000000000000"
    );

	BEGIN
		dataout <= rom(to_integer(unsigned(address)));
END arch_rom;