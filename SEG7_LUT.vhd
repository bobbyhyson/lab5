library ieee;
use ieee.std_logic_1164.all;

entity SEG7_LUT is
    port (
        iDIG : in  std_logic_vector(3 downto 0);
        oSEG : out std_logic_vector(6 downto 0)
    );
end entity SEG7_LUT;

architecture Behavioral of SEG7_LUT is
begin

    process(iDIG)
    begin
        case iDIG is
            when x"1" => oSEG <= "1111001"; -- ---t----
            when x"2" => oSEG <= "0100100"; -- |      |
            when x"3" => oSEG <= "0110000"; -- lt    rt
            when x"4" => oSEG <= "0011001"; -- |      |
            when x"5" => oSEG <= "0010010"; -- ---m----
            when x"6" => oSEG <= "0000010"; -- |      |
            when x"7" => oSEG <= "1111000"; -- lb    rb
            when x"8" => oSEG <= "0000000"; -- |      |
            when x"9" => oSEG <= "0011000"; -- ---b----
            when x"a" => oSEG <= "0001000";
            when x"b" => oSEG <= "0000011";
            when x"c" => oSEG <= "1000110";
            when x"d" => oSEG <= "0100001";
            when x"e" => oSEG <= "0000110";
            when x"f" => oSEG <= "0001110";
            when x"0" => oSEG <= "1000000";
            when others => oSEG <= "1111111"; -- Catch-all for 'U', 'X', 'Z', etc.
        end case;
    end process;

end architecture Behavioral;