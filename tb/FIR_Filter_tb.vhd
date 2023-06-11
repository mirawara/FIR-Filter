LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY FIR_Filter_tb IS
END ENTITY;

ARCHITECTURE test_bench OF FIR_Filter_tb IS
    COMPONENT FIR_Wrapper IS
        PORT (

            --CLOCK
            CLK : IN STD_LOGIC;

            --RESET
            RST : IN STD_LOGIC;

            --INPUT
            FIR_IN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

            --OUTPUT
            FIR_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    CONSTANT clk_period : TIME := 8 ns;
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL rst_tb : STD_LOGIC := '1';
    SIGNAL testing : BOOLEAN := true;
    SIGNAL fir_in_tb : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL fir_out_tb : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN
    clk <= NOT clk AFTER clk_period/2 WHEN testing ELSE
        '0';

    dut : FIR_Wrapper
    PORT MAP(
        CLK => clk,
        RST => rst_tb,
        FIR_IN => fir_in_tb,
        FIR_OUT => fir_out_tb
    );

    stimulus : PROCESS
    BEGIN
        --Only "1" as input 
        fir_in_tb <= "0000000010000000";
        WAIT FOR 100 ns;
        WAIT UNTIL rising_edge(clk);
        rst_tb <= '0';
        WAIT FOR 70 ns;

        --Sequence of ”1”,”2”,”3”,”4”,”5”,”6”,”7”
        WAIT UNTIL rising_edge(clk);
        fir_in_tb <= "0000000100000000";
        WAIT UNTIL rising_edge(clk);
        fir_in_tb <= "0000000110000000";
        WAIT UNTIL rising_edge(clk);
        fir_in_tb <= "0000001000000000";
        WAIT UNTIL rising_edge(clk);
        fir_in_tb <= "0000001010000000";
        WAIT UNTIL rising_edge(clk);
        fir_in_tb <= "0000001100000000";
        WAIT UNTIL rising_edge(clk);
        fir_in_tb <= "0000001110000000";
        WAIT FOR 100 ns;

        --Reset checking
        rst_tb <= '1';
        WAIT FOR 100 ns;
        rst_tb <= '0';

        --Only "2" as input
        WAIT UNTIL rising_edge(clk);
        fir_in_tb <= "0000000100000000";
        WAIT FOR 100 ns;

        --Reset checking
        rst_tb <= '1';
        WAIT FOR 15 ns;
        rst_tb <= '0';

        --Only "-1" as input
        WAIT UNTIL rising_edge(clk);
        fir_in_tb <= "1111111110000000";
        WAIT FOR 100 ns;

        --Reset checking
        rst_tb <= '1';
        WAIT FOR 15 ns;
        rst_tb <= '0';

        --Only "-2" as input
        WAIT UNTIL rising_edge(clk);
        fir_in_tb <= "1111111100000000";
        WAIT FOR 100 ns;

        --Sequence of ”-2”,”-3”,”-2”,”-3”...
        WAIT UNTIL rising_edge(clk);
        fir_in_tb <= "1111111010000000";
        WAIT UNTIL rising_edge(clk);
        fir_in_tb <= "1111111100000000";
        WAIT UNTIL rising_edge(clk);
        fir_in_tb <= "1111111010000000";
        WAIT UNTIL rising_edge(clk);
        fir_in_tb <= "1111111100000000";
        WAIT UNTIL rising_edge(clk);
        fir_in_tb <= "1111111010000000";
        WAIT UNTIL rising_edge(clk);
        fir_in_tb <= "1111111100000000";

        --Reset checking
        WAIT FOR 100 ns;
        rst_tb <= '1';
        WAIT FOR 15 ns;
        rst_tb <= '0';

        --Only "32767*2^-7" as input
        WAIT UNTIL rising_edge(clk);
        fir_in_tb <= "0111111111111111";
        WAIT FOR 100 ns;
        testing <= false;

    END PROCESS;
END test_bench;