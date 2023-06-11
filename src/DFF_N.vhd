LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

--D Flip-Flop positive edge triggered, asynchronous reset
ENTITY DFF_N IS

	--Number of bits
	GENERIC (Nbit : NATURAL := 3);

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

END DFF_N;

ARCHITECTURE struct OF DFF_N IS
BEGIN

	ddf_n_proc : PROCESS (clk, a_rst_n)
	BEGIN
		--asynchronous reset
		IF (a_rst_n = '1') THEN
			q <= (OTHERS => '0');
		ELSIF (rising_edge(clk)) THEN
			q <= d;
		END IF;
	END PROCESS;

END struct;