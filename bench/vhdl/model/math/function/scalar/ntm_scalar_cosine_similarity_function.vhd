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

entity ntm_scalar_cosine_similarity_function is
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

    DATA_A_IN_ENABLE : in std_logic;
    DATA_B_IN_ENABLE : in std_logic;

    DATA_OUT_ENABLE : out std_logic;

    -- DATA
    LENGTH_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
    DATA_A_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_B_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_scalar_cosine_similarity_function_architecture of ntm_scalar_cosine_similarity_function is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type controller_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_STATE,                        -- STEP 1
    SCALAR_PRODUCT_STATE,               -- STEP 2
    SCALAR_MULTIPLIER_STATE,            -- STEP 3
    SCALAR_DIVIDER_STATE                -- STEP 4
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
  signal controller_ctrl_fsm_int : controller_ctrl_fsm;

  -- Data Internal
  signal data_int_scalar_product : std_logic_vector(DATA_SIZE-1 downto 0);

  -- Control Internal
  signal index_product_ab_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_product_aa_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_product_bb_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_a_in_product_int : std_logic;
  signal data_b_in_product_int : std_logic;
  
  signal data_out_product_ab_int : std_logic;
  signal data_out_product_aa_int : std_logic;
  signal data_out_product_bb_int : std_logic;

  -- SCALAR MULTIPLIER
  -- CONTROL
  signal start_scalar_multiplier : std_logic;
  signal ready_scalar_multiplier : std_logic;

  -- DATA
  signal data_a_in_scalar_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_multiplier  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR DIVIDER
  -- CONTROL
  signal start_scalar_divider : std_logic;
  signal ready_scalar_divider : std_logic;

  -- DATA
  signal data_a_in_scalar_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_divider  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR PRODUCT AB
  -- CONTROL
  signal start_scalar_product_ab : std_logic;
  signal ready_scalar_product_ab : std_logic;

  signal data_a_in_enable_scalar_product_ab : std_logic;
  signal data_b_in_enable_scalar_product_ab : std_logic;

  signal data_out_enable_scalar_product_ab : std_logic;

  -- DATA
  signal length_in_scalar_product_ab : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_scalar_product_ab : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_product_ab : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_product_ab  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR PRODUCT AA
  -- CONTROL
  signal start_scalar_product_aa : std_logic;
  signal ready_scalar_product_aa : std_logic;

  signal data_a_in_enable_scalar_product_aa : std_logic;
  signal data_b_in_enable_scalar_product_aa : std_logic;

  signal data_out_enable_scalar_product_aa : std_logic;

  -- DATA
  signal length_in_scalar_product_aa : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_scalar_product_aa : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_product_aa : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_product_aa  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR PRODUCT BB
  -- CONTROL
  signal start_scalar_product_bb : std_logic;
  signal ready_scalar_product_bb : std_logic;

  signal data_a_in_enable_scalar_product_bb : std_logic;
  signal data_b_in_enable_scalar_product_bb : std_logic;

  signal data_out_enable_scalar_product_bb : std_logic;

  -- DATA
  signal length_in_scalar_product_bb : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_scalar_product_bb : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_product_bb : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_product_bb  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- DATA_OUT = (DATA_A_IN · DATA_B_IN)/((DATA_A_IN · DATA_A_IN)(DATA_B_IN · DATA_B_IN))

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      DATA_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      DATA_OUT_ENABLE <= '0';

    elsif (rising_edge(CLK)) then

      case controller_ctrl_fsm_int is
        when STARTER_STATE =>  -- STEP 0
          -- Control Outputs
          READY <= '0';

          DATA_OUT_ENABLE <= '0';

          if (START = '1') then
            -- Control Internal
            start_scalar_product_ab <= '1';
            start_scalar_product_aa <= '1';
            start_scalar_product_bb <= '1';

            data_a_in_product_int <= '0';
            data_b_in_product_int <= '0';
  
            data_out_product_ab_int <= '0';
            data_out_product_aa_int <= '0';
            data_out_product_bb_int <= '0';

            index_product_ab_loop <= ZERO_CONTROL;
            index_product_aa_loop <= ZERO_CONTROL;
            index_product_bb_loop <= ZERO_CONTROL;

            -- Data Inputs
            length_in_scalar_product_ab <= LENGTH_IN;
            length_in_scalar_product_aa <= LENGTH_IN;
            length_in_scalar_product_ab <= LENGTH_IN;

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_STATE;
          end if;

        when INPUT_STATE =>  -- STEP 1

          if ((DATA_A_IN_ENABLE = '1') or (unsigned(index_product_aa_loop) = unsigned(ZERO_CONTROL))) then
            -- Data Inputs
            data_a_in_scalar_product_ab <= DATA_A_IN;
            data_a_in_scalar_product_aa <= DATA_A_IN;
            data_a_in_scalar_product_bb <= DATA_A_IN;

            -- Control Internal
            data_a_in_enable_scalar_product_ab <= '1';
            data_a_in_enable_scalar_product_aa <= '1';
            data_a_in_enable_scalar_product_bb <= '1';

            data_a_in_product_int <= '1';
          else
            -- Control Inputs
            data_a_in_enable_scalar_product_ab <= '0';
            data_a_in_enable_scalar_product_aa <= '0';
            data_a_in_enable_scalar_product_bb <= '0';
          end if;

          if ((DATA_B_IN_ENABLE = '1') or (unsigned(index_product_aa_loop) = unsigned(ZERO_CONTROL))) then
            -- Data Inputs
            data_b_in_scalar_product_ab <= DATA_B_IN;
            data_b_in_scalar_product_aa <= DATA_B_IN;
            data_b_in_scalar_product_bb <= DATA_B_IN;

            -- Control Internal
            data_b_in_enable_scalar_product_ab <= '1';
            data_b_in_enable_scalar_product_aa <= '1';
            data_b_in_enable_scalar_product_bb <= '1';

            data_b_in_product_int <= '1';
          else
            -- Control Inputs
            data_b_in_enable_scalar_product_ab <= '0';
            data_b_in_enable_scalar_product_aa <= '0';
            data_b_in_enable_scalar_product_bb <= '0';
          end if;

          if (data_a_in_product_int = '1' and data_b_in_product_int = '1') then
            -- Control Internal
            data_a_in_enable_scalar_product_ab <= '0';
            data_a_in_enable_scalar_product_aa <= '0';
            data_a_in_enable_scalar_product_bb <= '0';

            data_b_in_enable_scalar_product_ab <= '0';
            data_b_in_enable_scalar_product_aa <= '0';
            data_b_in_enable_scalar_product_bb <= '0';

            data_a_in_product_int <= '0';
            data_b_in_product_int <= '0';

            -- FSM Control
            controller_ctrl_fsm_int <= SCALAR_PRODUCT_STATE;
          else
            -- Control Internal
            start_scalar_product_ab <= '0';
            start_scalar_product_aa <= '0';
            start_scalar_product_bb <= '0';
          end if;

          -- Control Outputs
          DATA_OUT_ENABLE <= '0';

        when SCALAR_PRODUCT_STATE =>  -- STEP 2

          if (ready_scalar_product_ab = '1') then
            if (unsigned(index_product_ab_loop) = unsigned(LENGTH_IN)-unsigned(ONE_CONTROL)) then
              -- Control Internal
              index_product_ab_loop <= ZERO_CONTROL;
            else
              -- Control Internal
              index_product_ab_loop <= std_logic_vector(unsigned(index_product_ab_loop)+unsigned(ONE_CONTROL));
            end if;

            -- Control Internal
            data_out_product_ab_int <= '1';
          end if;

          if (ready_scalar_product_aa = '1') then
            if (unsigned(index_product_aa_loop) = unsigned(LENGTH_IN)-unsigned(ONE_CONTROL)) then
              -- Control Internal
              index_product_aa_loop <= ZERO_CONTROL;
            else
              -- Control Internal
              index_product_aa_loop <= std_logic_vector(unsigned(index_product_aa_loop)+unsigned(ONE_CONTROL));
            end if;

            -- Control Internal
            data_out_product_aa_int <= '1';
          end if;

          if (ready_scalar_product_bb = '1') then
            if (unsigned(index_product_bb_loop) = unsigned(LENGTH_IN)-unsigned(ONE_CONTROL)) then
              -- Control Internal
              index_product_bb_loop <= ZERO_CONTROL;
            else
              -- Control Internal
              index_product_bb_loop <= std_logic_vector(unsigned(index_product_bb_loop)+unsigned(ONE_CONTROL));
            end if;

            -- Control Internal
            data_out_product_bb_int <= '1';
          end if;

          if (data_out_product_ab_int = '1' and data_out_product_aa_int = '1' and data_out_product_bb_int = '1') then
            if ((unsigned(index_product_ab_loop) = unsigned(LENGTH_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_product_aa_loop) = unsigned(LENGTH_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_product_bb_loop) = unsigned(LENGTH_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internals
              data_a_in_scalar_multiplier <= data_out_scalar_product_aa;
              data_b_in_scalar_multiplier <= data_out_scalar_product_bb;

              -- Control Internal
              start_scalar_multiplier <= '1';

              -- FSM Control
              controller_ctrl_fsm_int <= SCALAR_MULTIPLIER_STATE;
            else
              -- FSM Control
              controller_ctrl_fsm_int <= INPUT_STATE;
            end if;

            -- Control Outputs
            DATA_OUT_ENABLE <= '1';

            -- Control Internal
            data_out_product_ab_int <= '0';
            data_out_product_aa_int <= '0';
            data_out_product_bb_int <= '0';
          else
            -- Control Internal
            data_a_in_product_int <= '0';
            data_b_in_product_int <= '0';
          end if;

        when SCALAR_MULTIPLIER_STATE =>  -- STEP 3

          if (ready_scalar_multiplier = '1') then
            -- Control Internal
            start_scalar_divider <= '1';

            -- Data Internal
            data_a_in_scalar_divider <= data_out_scalar_product_ab;
            data_b_in_scalar_divider <= data_out_scalar_multiplier;

            -- FSM Control
            controller_ctrl_fsm_int <= SCALAR_DIVIDER_STATE;
          else
             -- Control Outputs
            DATA_OUT_ENABLE <= '0';

            -- Control Internal
            start_scalar_multiplier <= '0';
          end if;

        when SCALAR_DIVIDER_STATE =>  -- STEP 4

          if (ready_scalar_divider = '1') then
            -- Data Outputs
            DATA_OUT <= data_out_scalar_divider;

            -- Control Outputs
            READY <= '1';

            -- FSM Control
            controller_ctrl_fsm_int <= STARTER_STATE;
          else
            -- Control Internal
            start_scalar_divider <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- SCALAR MULTIPLIER
  scalar_multiplier : ntm_scalar_multiplier
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_multiplier,
      READY => ready_scalar_multiplier,

      -- DATA
      DATA_A_IN => data_a_in_scalar_multiplier,
      DATA_B_IN => data_b_in_scalar_multiplier,
      DATA_OUT  => data_out_scalar_multiplier
      );

  -- SCALAR DIVIDER
  scalar_divider : ntm_scalar_divider
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_divider,
      READY => ready_scalar_divider,

      -- DATA
      DATA_A_IN => data_a_in_scalar_divider,
      DATA_B_IN => data_b_in_scalar_divider,
      DATA_OUT  => data_out_scalar_divider
      );

  -- SCALAR PRODUCT AB
  scalar_product_ab : ntm_scalar_product
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_product_ab,
      READY => ready_scalar_product_ab,

      DATA_A_IN_ENABLE => data_a_in_enable_scalar_product_ab,
      DATA_B_IN_ENABLE => data_b_in_enable_scalar_product_ab,

      DATA_OUT_ENABLE => data_out_enable_scalar_product_ab,

      -- DATA
      LENGTH_IN => length_in_scalar_product_ab,
      DATA_A_IN => data_a_in_scalar_product_ab,
      DATA_B_IN => data_b_in_scalar_product_ab,
      DATA_OUT  => data_out_scalar_product_ab
      );

  -- SCALAR PRODUCT AA
  scalar_product_aa : ntm_scalar_product
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_product_aa,
      READY => ready_scalar_product_aa,

      DATA_A_IN_ENABLE => data_a_in_enable_scalar_product_aa,
      DATA_B_IN_ENABLE => data_b_in_enable_scalar_product_aa,

      DATA_OUT_ENABLE => data_out_enable_scalar_product_aa,

      -- DATA
      LENGTH_IN => length_in_scalar_product_aa,
      DATA_A_IN => data_a_in_scalar_product_aa,
      DATA_B_IN => data_b_in_scalar_product_aa,
      DATA_OUT  => data_out_scalar_product_aa
      );

  -- SCALAR PRODUCT BB
  scalar_product_bb : ntm_scalar_product
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_product_bb,
      READY => ready_scalar_product_bb,

      DATA_A_IN_ENABLE => data_a_in_enable_scalar_product_bb,
      DATA_B_IN_ENABLE => data_b_in_enable_scalar_product_bb,

      DATA_OUT_ENABLE => data_out_enable_scalar_product_bb,

      -- DATA
      LENGTH_IN => length_in_scalar_product_bb,
      DATA_A_IN => data_a_in_scalar_product_bb,
      DATA_B_IN => data_b_in_scalar_product_bb,
      DATA_OUT  => data_out_scalar_product_bb
      );

end architecture;
