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

use work.ntm_arithmetic_pkg.all;
use work.ntm_math_pkg.all;
use work.dnc_core_pkg.all;

entity dnc_memory_matrix is
  generic (
    DATA_SIZE    : integer := 64;
    CONTROL_SIZE : integer := 64
    );
  port (
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic;

    M_IN_J_ENABLE : in std_logic;       -- for j in 0 to N-1
    M_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1

    W_IN_J_ENABLE : in std_logic;       -- for j in 0 to N-1
    V_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1
    E_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1

    W_OUT_J_ENABLE : out std_logic;     -- for j in 0 to N-1
    V_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1
    E_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

    M_OUT_J_ENABLE : out std_logic;     -- for j in 0 to N-1
    M_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

    -- DATA
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    M_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    V_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    E_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    M_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture dnc_memory_matrix_architecture of dnc_memory_matrix is

  -----------------------------------------------------------------------
  -- Functionality
  -----------------------------------------------------------------------

  -- Inputs:
  -- M_IN [N,W]
  -- W_IN [N]
  -- E_IN [W]
  -- V_IN [W]

  -- Outputs:
  -- M_OUT [N,W]

  -- States:
  -- INPUT_N_STATE, CLEAN_IN_N_STATE
  -- INPUT_W_STATE, CLEAN_IN_W_STATE

  -- OUTPUT_N_STATE, CLEAN_OUT_N_STATE
  -- OUTPUT_W_STATE, CLEAN_OUT_W_STATE

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -- Finite State Machine
  type controller_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_FIRST_STATE,                  -- STEP 1
    CLEAN_FIRST_STATE,                  -- STEP 2
    INPUT_SECOND_I_STATE,               -- STEP 3
    INPUT_SECOND_J_STATE,               -- STEP 4
    CLEAN_SECOND_I_STATE,               -- STEP 5
    CLEAN_SECOND_J_STATE                -- STEP 6
    );

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal controller_ctrl_fsm_int : controller_ctrl_fsm;

  -- Buffer
  signal matrix_m_int : matrix_buffer;

  signal vector_w_int : vector_buffer;
  signal vector_v_int : vector_buffer;
  signal vector_e_int : vector_buffer;

  signal matrix_out_int : matrix_buffer;

  -- Control Internal
  signal index_i_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_m_in_i_int : std_logic;
  signal data_m_in_j_int : std_logic;

  signal data_w_in_int : std_logic;
  signal data_v_in_int : std_logic;
  signal data_e_in_int : std_logic;

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- M(t;j;k) = M(t-1;j;k) o (E - w(t;j)·transpose(e(t;k))) + w(t;j)·transpose(v(t;k))

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      M_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      M_OUT_J_ENABLE <= '0';
      M_OUT_K_ENABLE <= '0';

      W_OUT_J_ENABLE <= '0';
      V_OUT_K_ENABLE <= '0';
      E_OUT_K_ENABLE <= '0';

      -- Control Internal
      index_i_loop <= ZERO_CONTROL;
      index_j_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Data Outputs
          M_OUT <= ZERO_DATA;

          -- Control Outputs
          READY <= '0';

          M_OUT_J_ENABLE <= '0';
          M_OUT_K_ENABLE <= '0';

          if (START = '1') then
            -- Control Outputs
            W_OUT_J_ENABLE <= '1';
            V_OUT_K_ENABLE <= '1';
            E_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_FIRST_STATE;
          else
            -- Control Outputs
            W_OUT_J_ENABLE <= '0';
            V_OUT_K_ENABLE <= '0';
            E_OUT_K_ENABLE <= '0';
          end if;

        when INPUT_FIRST_STATE =>       -- STEP 1 v,e

          if (V_IN_K_ENABLE = '1') then
            -- Data Inputs
            vector_v_int(to_integer(unsigned(index_j_loop))) <= V_IN;

            -- Control Internal
            data_v_in_int <= '1';
          end if;

          if (E_IN_K_ENABLE = '1') then
            -- Data Inputs
            vector_e_int(to_integer(unsigned(index_j_loop))) <= E_IN;

            -- Control Internal
            data_e_in_int <= '1';
          end if;

          -- Control Outputs
          V_OUT_K_ENABLE <= '0';
          E_OUT_K_ENABLE <= '0';

          if (data_v_in_int = '1' and data_e_in_int = '1') then
            -- Control Internal
            data_v_in_int <= '0';
            data_e_in_int <= '0';

            -- FSM Control
            controller_ctrl_fsm_int <= CLEAN_FIRST_STATE;
          end if;

        when CLEAN_FIRST_STATE =>       -- STEP 2

          if (unsigned(index_j_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            V_OUT_K_ENABLE <= '1';
            E_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_j_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_SECOND_I_STATE;
          elsif (unsigned(index_j_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            V_OUT_K_ENABLE <= '1';
            E_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_FIRST_STATE;
          end if;

        when INPUT_SECOND_I_STATE =>    -- STEP 3 M,w

          if ((M_IN_J_ENABLE = '1') and (M_IN_K_ENABLE = '1')) then
            -- Data Inputs
            matrix_m_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop))) <= M_IN;

            -- Control Internal
            data_m_in_i_int <= '1';
            data_m_in_j_int <= '1';
          end if;

          if (W_IN_J_ENABLE = '1') then
            -- Data Inputs
            vector_w_int(to_integer(unsigned(index_i_loop))) <= W_IN;

            -- Control Internal
            data_w_in_int <= '1';
          end if;

          if (data_m_in_i_int = '1' and data_m_in_j_int = '1' and data_w_in_int = '1') then
            -- Control Internal
            data_m_in_i_int <= '0';
            data_m_in_j_int <= '0';
            data_w_in_int   <= '0';

            -- Data Internal
            matrix_out_int <= function_dnc_memory_matrix (
              SIZE_N_IN => SIZE_N_IN,
              SIZE_W_IN => SIZE_W_IN,

              matrix_m_input => matrix_m_int,

              vector_w_input => vector_w_int,
              vector_v_input => vector_v_int,
              vector_e_input => vector_e_int
              );

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_SECOND_J_STATE;
          end if;

          -- Control Outputs
          M_OUT_J_ENABLE <= '0';
          M_OUT_K_ENABLE <= '0';

          W_OUT_J_ENABLE <= '0';

        when INPUT_SECOND_J_STATE =>    -- STEP 4 w

          if (M_IN_J_ENABLE = '1') then
            -- Data Inputs
            matrix_m_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop))) <= M_IN;

            -- FSM Control
            if (unsigned(index_j_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              controller_ctrl_fsm_int <= INPUT_SECOND_I_STATE;
            else
              controller_ctrl_fsm_int <= INPUT_SECOND_J_STATE;
            end if;
          end if;

          -- Control Outputs
          M_OUT_K_ENABLE <= '0';

          W_OUT_J_ENABLE <= '0';

        when CLEAN_SECOND_I_STATE =>    -- STEP 5

          if ((unsigned(index_i_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            M_OUT <= matrix_out_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- Control Outputs
            READY <= '1';

            M_OUT_J_ENABLE <= '1';
            M_OUT_K_ENABLE <= '1';

            W_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_SECOND_I_STATE;
          elsif ((unsigned(index_i_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            M_OUT <= matrix_out_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- Control Outputs
            M_OUT_J_ENABLE <= '1';
            M_OUT_K_ENABLE <= '1';

            W_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_SECOND_I_STATE;
          end if;

        when CLEAN_SECOND_J_STATE =>    -- STEP 6

          if (unsigned(index_j_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            M_OUT <= matrix_out_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- Control Outputs
            M_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_SECOND_J_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

end architecture;
