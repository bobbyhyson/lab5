library ieee;
use ieee.std_logic_1164.all;

entity SEG7_LUT_6 is
    port (
        iDIG  : in  std_logic_vector(23 downto 0);
        oSEG0 : out std_logic_vector(6 downto 0);
        oSEG1 : out std_logic_vector(6 downto 0);
        oSEG2 : out std_logic_vector(6 downto 0);
        oSEG3 : out std_logic_vector(6 downto 0);
        oSEG4 : out std_logic_vector(6 downto 0);
        oSEG5 : out std_logic_vector(6 downto 0)
    );
end entity SEG7_LUT_6;

architecture Structural of SEG7_LUT_6 is

    -- Declare the SEG7_LUT component before instantiating it
    component SEG7_LUT is
        port (
            iDIG : in  std_logic_vector(3 downto 0);
            oSEG : out std_logic_vector(6 downto 0)
        );
    end component;

begin

    -- Instantiate the 6 lookup tables and map the slices of iDIG to each
    u0 : SEG7_LUT port map ( oSEG => oSEG0, iDIG => iDIG(3 downto 0) );
    u1 : SEG7_LUT port map ( oSEG => oSEG1, iDIG => iDIG(7 downto 4) );
    u2 : SEG7_LUT port map ( oSEG => oSEG2, iDIG => iDIG(11 downto 8) );
    u3 : SEG7_LUT port map ( oSEG => oSEG3, iDIG => iDIG(15 downto 12) );
    u4 : SEG7_LUT port map ( oSEG => oSEG4, iDIG => iDIG(19 downto 16) );
    u5 : SEG7_LUT port map ( oSEG => oSEG5, iDIG => iDIG(23 downto 20) );

end architecture Structural;