-- top design module

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    generic (   DBIT : integer := 8; -- # Data bits
		SB_TICK : integer :=16; -- # Ticks for stop bits, 16/24/32 for 1/1.5/2 stop bits 
   	        DVSR : integer := 326; -- # Baud rate divisor DVSR = 100/(16 * baud rate)
		DVSR_BIT : integer := 9; -- # Bits of DVSR
		DVSR_BIT2 : integer := 18; -- # For code converter
		ADDR_WIDTH: integer := 8; -- Adresses
		DATA_WIDTH: integer :=8 ); -- Ascii code 8 bits

    port ( rx, clk, reset : in  STD_LOGIC;
           loudspeaker : out  STD_LOGIC;
	   play : in std_logic; 
 	   leds : out std_logic_vector(7 downto 0) );
end top;

architecture Behavioral of top is
-----------------------baud_rate_generator----------------------------------
	component baud_rate_generator is
        generic (N : integer := 9; -- number of bits needed to count to M
                 M : integer := 326 ); -- mod-m
        
        port ( clk, reset : in  STD_LOGIC;
               max_tick : out  STD_LOGIC;
               q : out  STD_LOGIC_VECTOR(N-1 downto 0));
	end component;
-----------------------uart_rx-----------------------------------
    component uart_rx is
        generic ( DBIT : integer := 8; -- # data bits
		  SB_TICK : integer := 16 ); -- # ticks for stop bits. 

        port ( clk, reset: in std_logic;
	       from_rx: in std_logic;
               s_tick: in std_logic;
               to_rx_done_tick: out std_logic;
               to_dout: out std_logic_vector(7 downto 0) );	  
	end component; 
-----------------------CodeConverter-----------------------------------
    component CodeConverter is
	   port ( from_dout : in  STD_LOGIC_VECTOR (7 downto 0);
		  to_m_in : out  STD_LOGIC_VECTOR (17 downto 0) );
	end component;
-----------------------mod_m_counter-----------------------------------
	component mod_m_counter is
	   generic (N : integer := 18); -- number of bits
		 
	   port (clk : in  STD_LOGIC;
             	 reset : in  STD_LOGIC;
             	 from_m_in : in STD_LOGIC_VECTOR(N-1 downto 0);
	     	 to_t_in: out std_logic );
	end component;
-----------------------T_FF--------------------------------------------
    component T_FF is
        port ( clk, reset : in STD_LOGIC;
               from_t_in : in  STD_LOGIC;
               from_clr_FF : in  STD_LOGIC;
               to_ldspkr : out  STD_LOGIC );
    end component; 
-----------------------FSM--------------------------------------------
    component FSM is
        generic (ADDR_WIDTH: integer:=8;
                 DATA_WIDTH: integer:=8 );
        
        port ( from_play : in  STD_LOGIC;
              from_rx_done_tick : in  STD_LOGIC;
              from_dout : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
              to_abus : out STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
              to_wr_en : out  STD_LOGIC;
              from_rdbus : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
              to_td_on : out  STD_LOGIC;
              from_td_done : in  STD_LOGIC;
              to_clr_FF : out  STD_LOGIC;
              reset : in  STD_LOGIC;
              clk : in  STD_LOGIC);
    end component;
-----------------------RAM--------------------------------------------
    component RAM is
        generic ( ADDR_WIDTH: integer := 8;
                  DATA_WIDTH: integer := 8 );
        port ( clk: in std_logic;
               we: in std_logic;
               addr: in std_logic_vector(ADDR_WIDTH-1 downto 0);
               wrbus: in std_logic_vector(DATA_WIDTH-1 downto 0);
               rdbus: out std_logic_vector(DATA_WIDTH-1 downto 0) );
    end component;
-----------------------TimerDelay------------------------------------------
    component TimerDelay is
        port (clk, reset : in std_logic;
              from_td_on : in std_logic;
              to_td_done : out std_logic );
    end component;
-----------------------Signals------------------------------------------
	signal tick : std_logic; 
	signal dout : std_logic_vector(7 downto 0);
	signal m_in : std_logic_vector(17 downto 0);
	signal rx_done_tick, t_in, clr_FF : std_logic; 
	signal abus : std_logic_vector(7 downto 0);
	signal wr_en : std_logic; 
	signal ram_data : std_logic_vector(7 downto 0);
	signal td_on, td_done : std_logic;
begin 

leds <= dout;
-----------------------Baud_rate_generator-----------------------------------
 baud_gen_unit : baud_rate_generator 
	   generic map (M => DVSR, N=> DVSR_BIT)
	   
	   port map (clk => clk,
                reset => reset,
		q => open, max_tick => tick );
 -----------------------uart_rx-----------------------------------
 uart_rx_unit : uart_rx 
	      generic map (DBIT => DBIT, SB_TICK => SB_TICK)
              
	      port map ( clk => clk,
			reset => reset,
			from_rx => rx,	
			s_tick => tick, 
			to_rx_done_tick => rx_done_tick, 
			to_dout => dout ); 	
-----------------------CodeConverter-----------------------------------
 code_converter_unit : CodeConverter port map ( from_dout => ram_data, to_m_in => m_in);							 
-----------------------mod_m_counter-----------------------------------		 
 mod_m_cntr_unit : mod_m_counter 
	 generic map(N=> DVSR_BIT2)
	 port map ( clk => clk,	
		   reset => reset,
		   from_m_in =>  m_in,	
		   to_t_in => t_in );						 
-----------------------T_FF-------------------------------------------
 t_ff_unit : T_FF port map ( clk => clk,
			     reset => reset,
	   		     from_t_in => t_in,
		  	     from_clr_FF => clr_FF,
			     to_ldspkr => loudspeaker );
-----------------------FSM--------------------------------------------				 
 fsm_unit : FSM 
	  generic map(ADDR_WIDTH => ADDR_WIDTH, DATA_WIDTH => DATA_WIDTH)
          port map ( from_play => play,
		     from_rx_done_tick => rx_done_tick,
              	     from_dout =>  dout,
		     to_abus => abus,
	  	     to_wr_en => wr_en,
		     from_rdbus => ram_data,
		     to_td_on => td_on,
		     from_td_done => td_done,
              	     to_clr_FF => clr_FF,
                     reset => reset,
                     clk => clk );

RAM_unit : RAM 
	generic map(ADDR_WIDTH => ADDR_WIDTH, DATA_WIDTH => DATA_WIDTH)
        port map( clk => clk,
		  we => wr_en,	
		  addr => abus,
		  wrbus => dout,
		  rdbus => ram_data );
			
delay_unit : TimerDelay 
	port map( clk => clk,
	          reset => reset,
	          from_td_on => td_on, 
	          to_td_done => td_done); 	  
end Behavioral;
