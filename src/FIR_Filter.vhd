LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

--Entity FIR Low Pass Filter
--fir_in is considered multiplied by 2^-7 (fixed point with 7 bits of fractional part)
--fir_out is considered multiplied by 2^-6 (fixed point with 6 bits of fractional part)
--coef_i are considered multiplied by 2^-15 (fixed point with 15 bits of fractional part)
ENTITY FIR_Filter IS
    PORT (
        --CLOCK
        clk : IN STD_LOGIC;

        --RESET
        rst : IN STD_LOGIC;

        --INPUT 16 BIT
        fir_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        --OUTPUT 16 BIT
        fir_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);

        --CONVOLUTION'S COEFFICIENTS
        coef_0 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        coef_1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        coef_2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        coef_3 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        coef_4 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        coef_5 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        coef_6 : IN STD_LOGIC_VECTOR(15 DOWNTO 0)
    );

END FIR_Filter;

ARCHITECTURE struct OF FIR_Filter IS

    --D FLIP-FLOP N-BIT positive edge triggered 
    COMPONENT DFF_N IS
        --Number of bits 
        GENERIC (Nbit : NATURAL := 16);
        PORT (
            --CLOCK
            clk : IN STD_LOGIC;
            --RESET
            a_rst_n : IN STD_LOGIC;
            --INPUT
            d : IN STD_LOGIC_VECTOR(Nbit - 1 DOWNTO 0);
            --OUTPUT
            q : OUT STD_LOGIC_VECTOR(Nbit - 1 DOWNTO 0)
        );
    END COMPONENT;

    --Definition of array of signal used for the "GENERATE" function
    TYPE const_i_a IS ARRAY (0 TO 6) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    TYPE sign_xn_a IS ARRAY (0 TO 6) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    TYPE sign_coef_out_a IS ARRAY (0 TO 6) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    TYPE sign_mul_out_a IS ARRAY (0 TO 6) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    TYPE sign_mul_D_out_a IS ARRAY (0 TO 6) OF STD_LOGIC_VECTOR(31 DOWNTO 0);

    --Array of signals representing the coefficients
    SIGNAL const_i : const_i_a;

    --Signals representing the connection between the output of a register 
    --and the input of the next one in the shift register
    SIGNAL xn_to_xn_1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL xn_1_to_xn_2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL xn_2_to_xn_3 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL xn_3_to_xn_4 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL xn_4_to_xn_5 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL xn_5_to_xn_6 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL xn_6_to_add : STD_LOGIC_VECTOR(15 DOWNTO 0);
    --Array of the signals above
    SIGNAL sign_xn : sign_xn_a;

    --Signals representing the coefficiets in output of the registers
    SIGNAL coef_out_0 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL coef_out_1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL coef_out_2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL coef_out_3 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL coef_out_4 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL coef_out_5 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL coef_out_6 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    --Array of the signals above
    SIGNAL sign_coef_out : sign_coef_out_a;

    --Signals representing the result of the multiplication
    SIGNAL mul_out_0 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL mul_out_1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL mul_out_2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL mul_out_3 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL mul_out_4 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL mul_out_5 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL mul_out_6 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    --Array of the signals above
    SIGNAL sign_mul_out : sign_mul_out_a;

    --Signals representing the result of the multiplication
    --in output of the registers
    SIGNAL mul_out_D_0 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL mul_out_D_1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL mul_out_D_2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL mul_out_D_3 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL mul_out_D_4 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL mul_out_D_5 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL mul_out_D_6 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    --Array of the signals above
    SIGNAL sign_mul_D_out : sign_mul_D_out_a;

    --Signals representing the result of the first stage of sums
    SIGNAL rca1_out1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL rca1_out2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL rca1_out3 : STD_LOGIC_VECTOR(31 DOWNTO 0);

    --Signals representing the result of the first stage of sums
    --in output of the registers
    SIGNAL dff1_out1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dff1_out2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dff1_out3 : STD_LOGIC_VECTOR(31 DOWNTO 0);

    --Signal representing x(n-6) in ouput of the register
    SIGNAL dff6 : STD_LOGIC_VECTOR(31 DOWNTO 0);

    --Signals representing the result of the second stage of sums
    SIGNAL rca2_out1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL rca2_out2 : STD_LOGIC_VECTOR(31 DOWNTO 0);

    --Signals representing the result of the second stage of sums
    --in output of the registers
    SIGNAL dff2_out1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dff2_out2 : STD_LOGIC_VECTOR(31 DOWNTO 0);

    --Signal representing the result of the last sums
    SIGNAL rca3_out : STD_LOGIC_VECTOR(31 DOWNTO 0);

    --Final output
    SIGNAL outp : STD_LOGIC_VECTOR(15 DOWNTO 0);
    
    --Constants used to "instantiate" DFF_N
    CONSTANT Nbit : INTEGER := 16;
    CONSTANT Mbit : INTEGER := 32;

BEGIN
    --Mapping the elements in the array
    const_i(0) <= coef_0;
    const_i(1) <= coef_1;
    const_i(2) <= coef_2;
    const_i(3) <= coef_3;
    const_i(4) <= coef_4;
    const_i(5) <= coef_5;
    const_i(6) <= coef_6;

    --Mapping the elements in the array
    xn_to_xn_1 <= sign_xn(0);
    xn_1_to_xn_2 <= sign_xn(1);
    xn_2_to_xn_3 <= sign_xn(2);
    xn_3_to_xn_4 <= sign_xn(3);
    xn_4_to_xn_5 <= sign_xn(4);
    xn_5_to_xn_6 <= sign_xn(5);
    xn_6_to_add <= sign_xn(6);

    --Generation of the shif register used for x(n),...,x(n-6)
    GEN1 : FOR i IN 0 TO 6 GENERATE
        FIRST : IF i = 0 GENERATE
            DFF1 : DFF_N
            GENERIC MAP
            (
                Nbit => Nbit
            )
            PORT MAP
            (
                clk => clk,
                a_rst_n => rst,
                d => fir_in,
                q => sign_xn(0)
            );
        END GENERATE FIRST;
        INTERNAL : IF i > 0 AND i < 6 GENERATE
            DFFI : DFF_N
            GENERIC MAP
            (
                Nbit => Nbit
            )
            PORT MAP
            (
                clk => clk,
                a_rst_n => rst,
                d => sign_xn(i - 1),
                q => sign_xn(i)
            );
        END GENERATE INTERNAL;
        LAST : IF i = 6 GENERATE
            DFF6 : DFF_N
            GENERIC MAP
            (
                Nbit => Nbit
            )
            PORT MAP
            (
                clk => clk,
                a_rst_n => rst,
                d => sign_xn(5),
                q => sign_xn(6)
            );
        END GENERATE LAST;
    END GENERATE GEN1;

    --Mapping the elements in the array
    coef_out_0 <= sign_coef_out(0);
    coef_out_1 <= sign_coef_out(1);
    coef_out_2 <= sign_coef_out(2);
    coef_out_3 <= sign_coef_out(3);
    coef_out_4 <= sign_coef_out(4);
    coef_out_5 <= sign_coef_out(5);
    coef_out_6 <= sign_coef_out(6);

    --Generation of the registers for
    --the coefficients in input
    GEN2 : FOR i IN 0 TO 6 GENERATE
        DFF_C : DFF_N
        GENERIC MAP
        (
            Nbit => Nbit
        )
        PORT MAP
        (
            clk => clk,
            a_rst_n => rst,
            d => const_i(i),
            q => sign_coef_out(i)
        );
    END GENERATE GEN2;

    --Mapping the elements in the array
    mul_out_0 <= sign_mul_out(0);
    mul_out_1 <= sign_mul_out(1);
    mul_out_2 <= sign_mul_out(2);
    mul_out_3 <= sign_mul_out(3);
    mul_out_4 <= sign_mul_out(4);
    mul_out_5 <= sign_mul_out(5);
    mul_out_6 <= sign_mul_out(6);

    --Process for the multiplication of x(n),...,x(n-6) and the coefficients
    mul_proc : PROCESS (sign_xn, sign_coef_out)
    BEGIN

        --Initialization
        FOR i IN 0 TO 6 LOOP
            sign_mul_out(i) <= (OTHERS => '0');
        END LOOP;

        --Multiplication
        FOR k IN 0 TO 6 LOOP
            sign_mul_out(k) <= STD_LOGIC_VECTOR(signed(sign_xn(k)) * signed(sign_coef_out(k)));
        END LOOP;

    END PROCESS;

    --Mapping the elements in the array
    mul_out_D_0 <= sign_mul_D_out(0);
    mul_out_D_1 <= sign_mul_D_out(1);
    mul_out_D_2 <= sign_mul_D_out(2);
    mul_out_D_3 <= sign_mul_D_out(3);
    mul_out_D_4 <= sign_mul_D_out(4);
    mul_out_D_5 <= sign_mul_D_out(5);
    mul_out_D_6 <= sign_mul_D_out(6);

    --Generation of the registers for the multiplications' results
    GEN3 : FOR i IN 0 TO 6 GENERATE
        DFF_M : DFF_N
        GENERIC MAP
        (
            --32 bit
            Nbit => Mbit
        )
        PORT MAP
        (
            clk => clk,
            a_rst_n => rst,
            d => sign_mul_out(i),
            q => sign_mul_D_out(i)
        );
    END GENERATE GEN3;

    --First stage of sums
    rca1_out1 <= STD_LOGIC_VECTOR(signed(sign_mul_D_out(0)) + signed(sign_mul_D_out(1)));
    rca1_out2 <= STD_LOGIC_VECTOR(signed(sign_mul_D_out(2)) + signed(sign_mul_D_out(3)));
    rca1_out3 <= STD_LOGIC_VECTOR(signed(sign_mul_D_out(4)) + signed(sign_mul_D_out(5)));

    --Register for x(n-6)
    DFF_6 : DFF_N
    GENERIC MAP
    (
        Nbit => Mbit
    )
    PORT MAP
    (
        clk => clk,
        a_rst_n => rst,
        d => sign_mul_D_out(6),
        q => dff6
    );

    --Register for the first result of the first stage of sums
    DFFR_1 : DFF_N
    GENERIC MAP
    (
        Nbit => Mbit
    )
    PORT MAP
    (
        clk => clk,
        a_rst_n => rst,
        d => rca1_out1,
        q => dff1_out1
    );

    --Register for the second result of the first stage of sums
    DFFR_2 : DFF_N
    GENERIC MAP
    (
        Nbit => Mbit
    )
    PORT MAP
    (
        clk => clk,
        a_rst_n => rst,
        d => rca1_out2,
        q => dff1_out2
    );

    --Register for the third result of the first stage of sums
    DFFR_3 : DFF_N
    GENERIC MAP
    (
        Nbit => Mbit
    )
    PORT MAP
    (
        clk => clk,
        a_rst_n => rst,
        d => rca1_out3,
        q => dff1_out3
    );

    --Second stage of sums
    rca2_out1 <= STD_LOGIC_VECTOR(signed(dff1_out1) + signed(dff1_out2));
    rca2_out2 <= STD_LOGIC_VECTOR(signed(dff1_out3) + signed(dff6));

    --Register for the first result of the second stage of sums
    DFFR1_4 : DFF_N
    GENERIC MAP
    (
        Nbit => Mbit
    )
    PORT MAP
    (
        clk => clk,
        a_rst_n => rst,
        d => rca2_out1,
        q => dff2_out1
    );

    --Register for the second result of the second stage of sums
    DFFR1_5 : DFF_N
    GENERIC MAP
    (
        Nbit => Mbit
    )
    PORT MAP
    (
        clk => clk,
        a_rst_n => rst,
        d => rca2_out2,
        q => dff2_out2
    );

    --Last stage of sums
    rca3_out <= STD_LOGIC_VECTOR(signed(dff2_out1) + signed(dff2_out2));

    --From 32 to 16 bits, now the fractional part is 22 bits (15+7) =>
    --I cut the last 16 bits
    outp <= rca3_out(31 DOWNTO 16);

    --Last register
    DFF_LAST : DFF_N
    GENERIC MAP
    (
        Nbit => Nbit
    )
    PORT MAP
    (
        clk => clk,
        a_rst_n => rst,
        d => outp,
        q => fir_out
    );

END struct;