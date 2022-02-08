--------------------------------------------------------------------------------
--                                            __ _      _     _               --
--                                           / _(_)    | |   | |              --
--                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |              --
--               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |              --
--              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |              --
--               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|              --
--                  | |                                                       --
--                  |_|                                                       --
--                                                                            --
--                                                                            --
--              Peripheral-NTM for MPSoC                                      --
--              Neural Turing Machine for MPSoC                               --
--                                                                            --
--------------------------------------------------------------------------------

-- Copyright (c) 2020-2021 by the author(s)
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
--
--------------------------------------------------------------------------------
-- Author(s):
--   Paco Reina Campo <pacoreinacampo@queenfield.tech>

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ntm_math_pkg.all;
use work.dnc_read_heads_pkg.all;

entity dnc_read_heads_stimulus is
  generic (
    -- SYSTEM-SIZE
    DATA_SIZE    : integer := 128;
    CONTROL_SIZE : integer := 64;

    X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- x in 0 to X-1
    Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- y in 0 to Y-1
    N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- j in 0 to N-1
    W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- k in 0 to W-1
    L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- l in 0 to L-1
    R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE))  -- i in 0 to R-1
    );
  port (
    -- GLOBAL
    CLK : out std_logic;
    RST : out std_logic;

    -- FREE GATES
    -- CONTROL
    DNC_FREE_GATES_START : out std_logic;
    DNC_FREE_GATES_READY : in  std_logic;

    DNC_FREE_GATES_F_IN_ENABLE : out std_logic;

    DNC_FREE_GATES_F_OUT_ENABLE : in std_logic;

    -- DATA
    DNC_FREE_GATES_SIZE_R_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);

    DNC_FREE_GATES_F_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    DNC_FREE_GATES_F_OUT : in std_logic_vector(DATA_SIZE-1 downto 0);

    -- READ KEYS
    -- CONTROL
    DNC_READ_KEYS_START : out std_logic;
    DNC_READ_KEYS_READY : in  std_logic;

    DNC_READ_KEYS_K_IN_I_ENABLE : out std_logic;
    DNC_READ_KEYS_K_IN_K_ENABLE : out std_logic;

    DNC_READ_KEYS_K_I_ENABLE : in std_logic;
    DNC_READ_KEYS_K_K_ENABLE : in std_logic;

    DNC_READ_KEYS_K_OUT_I_ENABLE : in std_logic;
    DNC_READ_KEYS_K_OUT_K_ENABLE : in std_logic;

    -- DATA
    DNC_READ_KEYS_SIZE_R_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    DNC_READ_KEYS_SIZE_W_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);

    DNC_READ_KEYS_K_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    DNC_READ_KEYS_K_OUT : in std_logic_vector(DATA_SIZE-1 downto 0);

    -- READ MODES
    -- CONTROL
    DNC_READ_MODES_START : out std_logic;
    DNC_READ_MODES_READY : in  std_logic;

    DNC_READ_MODES_PI_IN_I_ENABLE : out std_logic;
    DNC_READ_MODES_PI_IN_P_ENABLE : out std_logic;

    DNC_READ_MODES_PI_OUT_I_ENABLE : in std_logic;
    DNC_READ_MODES_PI_OUT_P_ENABLE : in std_logic;

    -- DATA
    DNC_READ_MODES_SIZE_R_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);

    DNC_READ_MODES_PI_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    DNC_READ_MODES_PI_OUT : in std_logic_vector(DATA_SIZE-1 downto 0);

    -- READ STRENGTHS
    -- CONTROL
    DNC_READ_STRENGTHS_START : out std_logic;
    DNC_READ_STRENGTHS_READY : in  std_logic;

    DNC_READ_STRENGTHS_BETA_IN_ENABLE  : out std_logic;
    DNC_READ_STRENGTHS_BETA_OUT_ENABLE : in  std_logic;

    -- DATA
    DNC_READ_STRENGTHS_SIZE_R_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);

    DNC_READ_STRENGTHS_BETA_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    DNC_READ_STRENGTHS_BETA_OUT : in std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture dnc_read_heads_stimulus_architecture of dnc_read_heads_stimulus is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  constant PERIOD : time := 10 ns;

  constant WAITING : time := 50 ns;
  constant WORKING : time := 1 ms;

  constant ZERO_CONTROL  : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, CONTROL_SIZE));
  constant ONE_CONTROL   : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, CONTROL_SIZE));
  constant TWO_CONTROL   : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(2, CONTROL_SIZE));
  constant THREE_CONTROL : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(3, CONTROL_SIZE));

  constant ZERO_DATA  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));
  constant ONE_DATA   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, DATA_SIZE));
  constant TWO_DATA   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(2, DATA_SIZE));
  constant THREE_DATA : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(3, DATA_SIZE));

  constant FULL  : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '1');
  constant EMPTY : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');

  constant EULER : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- LOOP
  signal index_i_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- GLOBAL
  signal clk_int : std_logic;
  signal rst_int : std_logic;

  -- CONTROL
  signal start_int : std_logic;

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- clk generation
  clk_process : process
  begin
    clk_int <= '1';
    wait for PERIOD/2;

    clk_int <= '0';
    wait for PERIOD/2;
  end process;

  CLK <= clk_int;

  -- rst generation
  rst_process : process
  begin
    rst_int <= '0';
    wait for WAITING;

    rst_int <= '1';
    wait for WORKING;
  end process;

  RST <= rst_int;

  -- start generation
  start_process : process
  begin
    start_int <= '0';
    wait for WAITING;

    start_int <= '1';
    wait for PERIOD;

    start_int <= '0';
    wait for WORKING;
  end process;

  -- FUNCTIONALITY
  DNC_FREE_GATES_START     <= start_int;
  DNC_READ_KEYS_START      <= start_int;
  DNC_READ_MODES_START     <= start_int;
  DNC_READ_STRENGTHS_START <= start_int;

  -----------------------------------------------------------------------
  -- STIMULUS
  -----------------------------------------------------------------------

  main_test : process
  begin

    if (STIMULUS_DNC_FREE_GATES_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_DNC_FREE_GATES_TEST            ";
      -------------------------------------------------------------------

      -- DATA
      DNC_FREE_GATES_SIZE_R_IN <= THREE_CONTROL;

      if (STIMULUS_DNC_FREE_GATES_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_DNC_FREE_GATES_CASE 0          ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        DNC_FREE_GATES_F_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        FREE_GATES_FIRST_RUN : loop
          if (DNC_FREE_GATES_F_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(DNC_FREE_GATES_SIZE_R_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            DNC_FREE_GATES_F_IN_ENABLE <= '1';

            -- DATA
            DNC_FREE_GATES_F_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((DNC_FREE_GATES_F_OUT_ENABLE = '1' or DNC_FREE_GATES_START = '1') and (unsigned(index_i_loop) < unsigned(DNC_FREE_GATES_SIZE_R_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            DNC_FREE_GATES_F_IN_ENABLE <= '1';

            -- DATA
            DNC_FREE_GATES_F_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            DNC_FREE_GATES_F_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit FREE_GATES_FIRST_RUN when DNC_FREE_GATES_READY = '1';
        end loop FREE_GATES_FIRST_RUN;
      end if;

      if (STIMULUS_DNC_FREE_GATES_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_DNC_FREE_GATES_CASE 1          ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        DNC_FREE_GATES_F_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        FREE_GATES_SECOND_RUN : loop
          if ((DNC_FREE_GATES_F_OUT_ENABLE = '1') and (unsigned(index_i_loop) = unsigned(DNC_FREE_GATES_SIZE_R_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            DNC_FREE_GATES_F_IN_ENABLE <= '1';

            -- DATA
            DNC_FREE_GATES_F_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif (((DNC_FREE_GATES_F_OUT_ENABLE = '1') or (DNC_FREE_GATES_START = '1')) and (unsigned(index_i_loop) < unsigned(DNC_FREE_GATES_SIZE_R_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            DNC_FREE_GATES_F_IN_ENABLE <= '1';

            -- DATA
            DNC_FREE_GATES_F_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            DNC_FREE_GATES_F_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit FREE_GATES_SECOND_RUN when DNC_FREE_GATES_READY = '1';
        end loop FREE_GATES_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;
    if (STIMULUS_DNC_READ_KEYS_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_DNC_READ_KEYS_TEST             ";
      -------------------------------------------------------------------

      -- DATA
      DNC_READ_KEYS_SIZE_R_IN <= THREE_CONTROL;
      DNC_READ_KEYS_SIZE_W_IN <= THREE_CONTROL;

      if (STIMULUS_DNC_READ_KEYS_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_DNC_READ_KEYS_CASE 0           ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        DNC_READ_KEYS_K_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        READ_KEYS_FIRST_RUN : loop
          if (DNC_READ_KEYS_K_I_ENABLE = '1' and DNC_READ_KEYS_K_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            DNC_READ_KEYS_K_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            DNC_READ_KEYS_K_IN_I_ENABLE <= '1';
            DNC_READ_KEYS_K_IN_K_ENABLE <= '1';
          elsif (DNC_READ_KEYS_K_I_ENABLE = '1' and DNC_READ_KEYS_K_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            DNC_READ_KEYS_K_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            DNC_READ_KEYS_K_IN_I_ENABLE <= '1';
            DNC_READ_KEYS_K_IN_K_ENABLE <= '1';
          elsif (DNC_READ_KEYS_K_K_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            DNC_READ_KEYS_K_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            DNC_READ_KEYS_K_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            DNC_READ_KEYS_K_IN_I_ENABLE <= '0';
            DNC_READ_KEYS_K_IN_K_ENABLE <= '0';
          end if;

          -- LOOP
          if (DNC_READ_KEYS_K_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(DNC_READ_KEYS_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(DNC_READ_KEYS_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (DNC_READ_KEYS_K_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(DNC_READ_KEYS_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(DNC_READ_KEYS_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((DNC_READ_KEYS_K_K_ENABLE = '1' or DNC_READ_KEYS_START = '1') and (unsigned(index_j_loop) < unsigned(DNC_READ_KEYS_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit READ_KEYS_FIRST_RUN when DNC_READ_KEYS_READY = '1';
        end loop READ_KEYS_FIRST_RUN;
      end if;

      if (STIMULUS_DNC_READ_KEYS_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_DNC_READ_KEYS_CASE 1           ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        DNC_READ_KEYS_K_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        READ_KEYS_SECOND_RUN : loop
          if (DNC_READ_KEYS_K_I_ENABLE = '1' and DNC_READ_KEYS_K_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            DNC_READ_KEYS_K_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            DNC_READ_KEYS_K_IN_I_ENABLE <= '1';
            DNC_READ_KEYS_K_IN_K_ENABLE <= '1';
          elsif (DNC_READ_KEYS_K_I_ENABLE = '1' and DNC_READ_KEYS_K_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            DNC_READ_KEYS_K_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            DNC_READ_KEYS_K_IN_I_ENABLE <= '1';
            DNC_READ_KEYS_K_IN_K_ENABLE <= '1';
          elsif (DNC_READ_KEYS_K_K_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            DNC_READ_KEYS_K_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            DNC_READ_KEYS_K_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            DNC_READ_KEYS_K_IN_I_ENABLE <= '0';
            DNC_READ_KEYS_K_IN_K_ENABLE <= '0';
          end if;

          -- LOOP
          if (DNC_READ_KEYS_K_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(DNC_READ_KEYS_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(DNC_READ_KEYS_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (DNC_READ_KEYS_K_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(DNC_READ_KEYS_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(DNC_READ_KEYS_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((DNC_READ_KEYS_K_K_ENABLE = '1' or DNC_READ_KEYS_START = '1') and (unsigned(index_j_loop) < unsigned(DNC_READ_KEYS_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit READ_KEYS_SECOND_RUN when DNC_READ_KEYS_READY = '1';
        end loop READ_KEYS_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_DNC_READ_MODES_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_DNC_READ_MODES_TEST            ";
      -------------------------------------------------------------------

      -- DATA
      DNC_READ_MODES_SIZE_R_IN <= THREE_CONTROL;

      if (STIMULUS_DNC_READ_MODES_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_DNC_READ_MODES_CASE 0          ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        DNC_READ_MODES_PI_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        READ_MODES_FIRST_RUN : loop
          if (DNC_READ_MODES_PI_OUT_I_ENABLE = '1' and DNC_READ_MODES_PI_OUT_P_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            DNC_READ_MODES_PI_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            DNC_READ_MODES_PI_IN_I_ENABLE <= '1';
            DNC_READ_MODES_PI_IN_P_ENABLE <= '1';
          elsif (DNC_READ_MODES_PI_OUT_I_ENABLE = '1' and DNC_READ_MODES_PI_OUT_P_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            DNC_READ_MODES_PI_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            DNC_READ_MODES_PI_IN_I_ENABLE <= '1';
            DNC_READ_MODES_PI_IN_P_ENABLE <= '1';
          elsif (DNC_READ_MODES_PI_IN_P_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            DNC_READ_MODES_PI_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            DNC_READ_MODES_PI_IN_P_ENABLE <= '1';
          else
            -- CONTROL
            DNC_READ_MODES_PI_IN_I_ENABLE <= '0';
            DNC_READ_MODES_PI_IN_P_ENABLE <= '0';
          end if;

          -- LOOP
          if (DNC_READ_MODES_PI_OUT_P_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(DNC_READ_MODES_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(THREE_CONTROL)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (DNC_READ_MODES_PI_OUT_P_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(DNC_READ_MODES_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(THREE_CONTROL)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((DNC_READ_MODES_PI_OUT_P_ENABLE = '1' or DNC_READ_MODES_START = '1') and (unsigned(index_j_loop) < unsigned(THREE_CONTROL)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit READ_MODES_FIRST_RUN when DNC_READ_MODES_READY = '1';
        end loop READ_MODES_FIRST_RUN;
      end if;

      if (STIMULUS_DNC_READ_MODES_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_DNC_READ_MODES_CASE 1          ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        DNC_READ_MODES_PI_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        READ_MODES_SECOND_RUN : loop
          if (DNC_READ_MODES_PI_OUT_I_ENABLE = '1' and DNC_READ_MODES_PI_OUT_P_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            DNC_READ_MODES_PI_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            DNC_READ_MODES_PI_IN_I_ENABLE <= '1';
            DNC_READ_MODES_PI_IN_P_ENABLE <= '1';
          elsif (DNC_READ_MODES_PI_OUT_I_ENABLE = '1' and DNC_READ_MODES_PI_OUT_P_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            DNC_READ_MODES_PI_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            DNC_READ_MODES_PI_IN_I_ENABLE <= '1';
            DNC_READ_MODES_PI_IN_P_ENABLE <= '1';
          elsif (DNC_READ_MODES_PI_OUT_P_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            DNC_READ_MODES_PI_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            DNC_READ_MODES_PI_IN_P_ENABLE <= '1';
          else
            -- CONTROL
            DNC_READ_MODES_PI_IN_I_ENABLE <= '0';
            DNC_READ_MODES_PI_IN_P_ENABLE <= '0';
          end if;

          -- LOOP
          if (DNC_READ_MODES_PI_OUT_P_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(DNC_READ_MODES_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(THREE_CONTROL)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (DNC_READ_MODES_PI_OUT_P_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(DNC_READ_MODES_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(THREE_CONTROL)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((DNC_READ_MODES_PI_OUT_P_ENABLE = '1' or DNC_READ_MODES_START = '1') and (unsigned(index_j_loop) < unsigned(THREE_CONTROL)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit READ_MODES_SECOND_RUN when DNC_READ_MODES_READY = '1';
        end loop READ_MODES_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_DNC_READ_STRENGTHS_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_DNC_READ_STRENGTHS_TEST        ";
      -------------------------------------------------------------------

      -- DATA
      DNC_READ_STRENGTHS_SIZE_R_IN <= THREE_CONTROL;

      if (STIMULUS_DNC_READ_STRENGTHS_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_DNC_READ_STRENGTHS_CASE 0      ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        DNC_READ_STRENGTHS_BETA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        READ_STRENGTHS_FIRST_RUN : loop
          if (DNC_READ_STRENGTHS_BETA_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(DNC_READ_STRENGTHS_SIZE_R_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            DNC_READ_STRENGTHS_BETA_IN_ENABLE <= '1';

            -- DATA
            DNC_READ_STRENGTHS_BETA_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((DNC_READ_STRENGTHS_BETA_OUT_ENABLE = '1' or DNC_READ_STRENGTHS_START = '1') and (unsigned(index_i_loop) < unsigned(DNC_READ_STRENGTHS_SIZE_R_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            DNC_READ_STRENGTHS_BETA_IN_ENABLE <= '1';

            -- DATA
            DNC_READ_STRENGTHS_BETA_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            DNC_READ_STRENGTHS_BETA_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit READ_STRENGTHS_FIRST_RUN when DNC_READ_STRENGTHS_READY = '1';
        end loop READ_STRENGTHS_FIRST_RUN;
      end if;

      if (STIMULUS_DNC_READ_STRENGTHS_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_DNC_READ_STRENGTHS_CASE 1      ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        DNC_READ_STRENGTHS_BETA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        READ_STRENGTHS_SECOND_RUN : loop
          if ((DNC_READ_STRENGTHS_BETA_OUT_ENABLE = '1') and (unsigned(index_i_loop) = unsigned(DNC_READ_STRENGTHS_SIZE_R_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            DNC_READ_STRENGTHS_BETA_IN_ENABLE <= '1';

            -- DATA
            DNC_READ_STRENGTHS_BETA_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif (((DNC_READ_STRENGTHS_BETA_OUT_ENABLE = '1') or (DNC_READ_STRENGTHS_START = '1')) and (unsigned(index_i_loop) < unsigned(DNC_READ_STRENGTHS_SIZE_R_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            DNC_READ_STRENGTHS_BETA_IN_ENABLE <= '1';

            -- DATA
            DNC_READ_STRENGTHS_BETA_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            DNC_READ_STRENGTHS_BETA_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit READ_STRENGTHS_SECOND_RUN when DNC_READ_STRENGTHS_READY = '1';
        end loop READ_STRENGTHS_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    assert false
      report "END OF TEST"
      severity failure;

  end process main_test;

end architecture;
