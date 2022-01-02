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

entity ntm_vector_softmax_function is
  generic (
    DATA_SIZE    : integer := 128;
    CONTROL_SIZE : integer := 64
    );
  port (
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic;

    DATA_IN_VECTOR_ENABLE : in std_logic;
    DATA_IN_SCALAR_ENABLE : in std_logic;

    DATA_OUT_VECTOR_ENABLE : out std_logic;
    DATA_OUT_SCALAR_ENABLE : out std_logic;

    -- DATA
    MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    SIZE_IN   : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
    LENGTH_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
    DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_vector_softmax_function_architecture of ntm_vector_softmax_function is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type softmax_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_VECTOR_STATE,                 -- STEP 1
    INPUT_SCALAR_STATE,                 -- STEP 2
    ENDER_VECTOR_STATE,                 -- STEP 3
    ENDER_SCALAR_STATE                  -- STEP 4
    );

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

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

  -- Finite State Machine
  signal softmax_ctrl_fsm_int : softmax_ctrl_fsm;

  -- Internal Signals
  signal index_vector_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_scalar_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- SCALAR SOFTMAX
  -- CONTROL
  signal start_scalar_softmax_function : std_logic;
  signal ready_scalar_softmax_function : std_logic;

  signal data_in_enable_scalar_softmax_function : std_logic;

  signal data_out_enable_scalar_softmax_function : std_logic;

  -- DATA
  signal modulo_in_scalar_softmax_function : std_logic_vector(DATA_SIZE-1 downto 0);
  signal length_in_scalar_softmax_function : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_scalar_softmax_function   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_softmax_function  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- DATA_OUT = exponentiation(EULER,DATA_IN)/summation(exponentiation(EULER,DATA_IN) [i in 0 to LENGTH_IN-1])

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      DATA_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      DATA_OUT_VECTOR_ENABLE <= '0';
      DATA_OUT_SCALAR_ENABLE <= '0';

      -- Control Internal
      start_scalar_softmax_function <= '0';

      index_vector_loop <= ZERO_CONTROL;
      index_scalar_loop <= ZERO_CONTROL;

      data_in_enable_scalar_softmax_function <= '0';

      -- Data Internal
      modulo_in_scalar_softmax_function <= ZERO_DATA;
      length_in_scalar_softmax_function <= ZERO_CONTROL;
      data_in_scalar_softmax_function   <= ZERO_DATA;

    elsif (rising_edge(CLK)) then

      case softmax_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          DATA_OUT_VECTOR_ENABLE <= '0';
          DATA_OUT_SCALAR_ENABLE <= '0';

          if (START = '1') then
            index_vector_loop <= ZERO_CONTROL;
            index_scalar_loop <= ZERO_CONTROL;

            -- FSM Control
            softmax_ctrl_fsm_int <= INPUT_VECTOR_STATE;
          end if;

        when INPUT_VECTOR_STATE =>      -- STEP 1

          if (((DATA_IN_VECTOR_ENABLE = '1') and (DATA_IN_SCALAR_ENABLE = '1')) or (index_scalar_loop = ZERO_CONTROL)) then
            -- Data Inputs
            modulo_in_scalar_softmax_function <= MODULO_IN;
            length_in_scalar_softmax_function <= LENGTH_IN;

            data_in_scalar_softmax_function <= DATA_IN;

            -- Control Internal
            start_scalar_softmax_function <= '1';

            data_in_enable_scalar_softmax_function <= '1';

            -- FSM Control
            softmax_ctrl_fsm_int <= ENDER_SCALAR_STATE;
          end if;

          -- Control Outputs
          DATA_OUT_VECTOR_ENABLE <= '0';
          DATA_OUT_SCALAR_ENABLE <= '0';

        when INPUT_SCALAR_STATE =>      -- STEP 2

          if (DATA_IN_SCALAR_ENABLE = '1') then
            -- Data Inputs
            data_in_scalar_softmax_function <= DATA_IN;

            -- Control Internal
            data_in_enable_scalar_softmax_function <= '1';

            -- FSM Control
            if (unsigned(index_scalar_loop) = unsigned(LENGTH_IN)-unsigned(ONE_CONTROL)) then
              softmax_ctrl_fsm_int <= ENDER_VECTOR_STATE;
            else
              softmax_ctrl_fsm_int <= ENDER_SCALAR_STATE;
            end if;
          end if;

          -- Control Outputs
          DATA_OUT_SCALAR_ENABLE <= '0';

        when ENDER_VECTOR_STATE =>      -- STEP 3

          if (data_out_enable_scalar_softmax_function = '1') then
            if ((unsigned(index_vector_loop) = unsigned(SIZE_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_scalar_loop) = unsigned(LENGTH_IN)-unsigned(ONE_CONTROL))) then
              -- Data Outputs
              DATA_OUT <= data_out_scalar_softmax_function;

              -- Control Outputs
              DATA_OUT_VECTOR_ENABLE <= '1';
              DATA_OUT_SCALAR_ENABLE <= '1';

              READY <= '1';

              -- Control Internal
              index_vector_loop <= ZERO_CONTROL;
              index_scalar_loop <= ZERO_CONTROL;

              -- FSM Control
              softmax_ctrl_fsm_int <= STARTER_STATE;
            elsif ((unsigned(index_vector_loop) < unsigned(SIZE_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_scalar_loop) = unsigned(LENGTH_IN)-unsigned(ONE_CONTROL))) then
              -- Data Outputs
              DATA_OUT <= data_out_scalar_softmax_function;

              -- Control Outputs
              DATA_OUT_VECTOR_ENABLE <= '1';
              DATA_OUT_SCALAR_ENABLE <= '1';

              -- Control Internal
              index_vector_loop <= std_logic_vector(unsigned(index_vector_loop) + unsigned(ONE_CONTROL));
              index_scalar_loop <= ZERO_CONTROL;

              -- FSM Control
              softmax_ctrl_fsm_int <= INPUT_VECTOR_STATE;
            end if;
          else
            -- Control Internal
            start_scalar_softmax_function <= '0';

            data_in_enable_scalar_softmax_function <= '0';
          end if;

        when ENDER_SCALAR_STATE =>      -- STEP 4

          if (data_out_enable_scalar_softmax_function = '1') then
            if (unsigned(index_scalar_loop) < unsigned(LENGTH_IN)-unsigned(ONE_CONTROL)) then
              -- Data Outputs
              DATA_OUT <= data_out_scalar_softmax_function;

              -- Control Outputs
              DATA_OUT_SCALAR_ENABLE <= '1';

              -- Control Internal
              index_scalar_loop <= std_logic_vector(unsigned(index_scalar_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              softmax_ctrl_fsm_int <= INPUT_SCALAR_STATE;
            end if;
          else
            -- Control Internal
            start_scalar_softmax_function <= '0';

            data_in_enable_scalar_softmax_function <= '0';
          end if;

        when others =>
          -- FSM Control
          softmax_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- SCALAR SOFTMAX
  scalar_softmax_function : ntm_scalar_softmax_function
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_softmax_function,
      READY => ready_scalar_softmax_function,

      DATA_IN_ENABLE => data_in_enable_scalar_softmax_function,

      DATA_OUT_ENABLE => data_out_enable_scalar_softmax_function,

      -- DATA
      MODULO_IN => modulo_in_scalar_softmax_function,
      LENGTH_IN => length_in_scalar_softmax_function,
      DATA_IN   => data_in_scalar_softmax_function,
      DATA_OUT  => data_out_scalar_softmax_function
      );

end architecture;
