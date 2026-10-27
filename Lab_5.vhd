library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Lab_5 is
    port (
        ------------ CLOCK ----------
        --ADC_CLK_10    : in  std_logic;
        --MAX10_CLK1_50 : in  std_logic;
        MAX10_CLK2_50 : in  std_logic;

        ------------ SEG7 ----------
        HEX0          : out std_logic_vector(7 downto 0);
        HEX1          : out std_logic_vector(7 downto 0);
        HEX2          : out std_logic_vector(7 downto 0);
        HEX3          : out std_logic_vector(7 downto 0);
        HEX4          : out std_logic_vector(7 downto 0);
        HEX5          : out std_logic_vector(7 downto 0);

        ------------ KEY ----------
        KEY           : in  std_logic_vector(1 downto 0);

        ------------ LED ----------
        LEDR          : out std_logic_vector(9 downto 0);

        ------------ SW ----------
        SW            : in  std_logic_vector(9 downto 0)
    );
end entity Lab_5;

architecture rtl of Lab_5 is

   type state_type is (WAITING, P_DEBOUNCE, ACC, DELAY, R_DEBOUNCE);
	signal current_state, next_state : state_type;
	signal total, next_total : unsigned(9 downto 0);
	
	constant DEBOUNCE_MAX : unsigned(19 downto 0) := to_unsigned(1000000, 20);
	signal debounce_cnt, next_debounce_cnt : unsigned(19 downto 0);
    
	 -- 7-Segment Signals
    signal hex_val : std_logic_vector(23 downto 0);
    signal seg0, seg1, seg2, seg3, seg4, seg5 : std_logic_vector(6 downto 0);

    -- Component Declaration for SEG7_LUT_6
    component SEG7_LUT_6 is
        port (
            iDIG  : in  std_logic_vector(23 downto 0);
            oSEG0 : out std_logic_vector(6 downto 0);
            oSEG1 : out std_logic_vector(6 downto 0);
            oSEG2 : out std_logic_vector(6 downto 0);
            oSEG3 : out std_logic_vector(6 downto 0);
            oSEG4 : out std_logic_vector(6 downto 0);
            oSEG5 : out std_logic_vector(6 downto 0)
        );
    end component;
	 
begin

	 LEDR <= SW;
	 
	 -- pad the 10bit unsigned total to 24 bits for seven segment
    hex_val <= std_logic_vector(resize(total, 24));

    -- instantiate the 6 digit component
    u_display : SEG7_LUT_6 port map (
        iDIG  => hex_val,
        oSEG0 => seg0,
        oSEG1 => seg1,
        oSEG2 => seg2,
        oSEG3 => seg3,
        oSEG4 => seg4,
        oSEG5 => seg5
    );

    -- map 7-bit segment signals to 8-bit HEX outputs 
    HEX0 <= '1' & seg0;
    HEX1 <= '1' & seg1;
    HEX2 <= '1' & seg2;
    HEX3 <= '1' & seg3;
    HEX4 <= '1' & seg4;
    HEX5 <= '1' & seg5;
	 
----- PROCESS ONE, MOVES FSM FORWARD -----
    process(MAX10_CLK2_50, KEY(0)) 
	 begin
			if KEY(0) = '0' then
				current_state <= WAITING;
				total <= (others => '0');
				debounce_cnt <= (others => '0');
			elsif rising_edge(MAX10_CLK2_50) then
				current_state <= next_state;
				total <= next_total;
				debounce_cnt <= next_debounce_cnt;
			end if;
	end process;

----- PROCESS TWO, CALCULATES TOTAL -----
	process(current_state, total, debounce_cnt, KEY(1), SW)
	begin
		
		next_state <= current_state;
      next_total <= total;
		next_debounce_cnt <= debounce_cnt;
		  
		case current_state is
			when WAITING =>
				next_debounce_cnt <= (others => '0');
				if KEY(1) = '0' then 
					next_state <= P_DEBOUNCE;
				end if;
				
			when P_DEBOUNCE =>
				if KEY(1) = '1' then
					next_state <= WAITING;
				else
					next_debounce_cnt <= debounce_cnt + 1;
					if debounce_cnt = DEBOUNCE_MAX then
						next_state <= ACC;
					end if;
				end if;
				
			when ACC => 
				next_total <= total + unsigned(SW);
				next_debounce_cnt <= (others => '0');
				next_state <= DELAY;
				
			when DELAY =>
				if KEY(1) = '1' then
					next_state <= R_DEBOUNCE;
				end if;
				
			when R_DEBOUNCE =>
				if KEY(1) = '0' then
					next_state <= DELAY;
				else
					next_debounce_cnt <= debounce_cnt + 1;
					if debounce_cnt = DEBOUNCE_MAX then
						next_state <= WAITING;
					end if;
				end if;
				
			when others =>
				next_total <= (others => '0');
				next_state <= WAITING;
		end case;
	end process;
			
	


end architecture rtl;