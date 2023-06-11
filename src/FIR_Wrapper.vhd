LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

--Wrapper, used to give the coefficients as input too
ENTITY FIR_Wrapper IS
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
END FIR_Wrapper;

ARCHITECTURE beh OF FIR_Wrapper IS

    --FIR FIlter
    COMPONENT FIR_Filter IS
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            fir_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            fir_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            coef_0 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            coef_1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            coef_2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            coef_3 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            coef_4 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            coef_5 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            coef_6 : IN STD_LOGIC_VECTOR(15 DOWNTO 0)
        );

    END COMPONENT;

    --Constants representing the coefficients (with 15 bits of fractional part) 
    --[Initialized here because they aren't declared as "signal"]
    CONSTANT coef_0 : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000110111010";
    CONSTANT coef_1 : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000101000001100";
    CONSTANT coef_2 : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0001111011010101";
    CONSTANT coef_3 : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0010101011001101";
    CONSTANT coef_4 : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0001111011010101";
    CONSTANT coef_5 : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000101000001100";
    CONSTANT coef_6 : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000110111010";

BEGIN
    --Mapping
    FIR : FIR_Filter
    PORT MAP
    (
        rst => RST,
        clk => CLK,
        fir_in => FIR_IN,
        fir_out => FIR_OUT,
        coef_0 => coef_0,
        coef_1 => coef_1,
        coef_2 => coef_2,
        coef_3 => coef_3,
        coef_4 => coef_4,
        coef_5 => coef_5,
        coef_6 => coef_6
    );
END beh;