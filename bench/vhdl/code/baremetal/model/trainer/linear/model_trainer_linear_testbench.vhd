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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.model_arithmetic_pkg.all;
use work.model_math_pkg.all;
use work.model_linear_controller_pkg.all;
use work.model_trainer_linear_pkg.all;

entity model_trainer_linear_testbench is
  generic (
    -- SYSTEM-SIZE
    DATA_SIZE    : integer := 64;
    CONTROL_SIZE : integer := 4;

    X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- x in 0 to X-1
    Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- y in 0 to Y-1
    N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- j in 0 to N-1
    W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- k in 0 to W-1
    L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- l in 0 to L-1
    R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE))  -- i in 0 to R-1
    );
end model_trainer_linear_testbench;

architecture model_trainer_linear_testbench_architecture of model_trainer_linear_testbench is

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- GLOBAL
  signal CLK : std_logic;
  signal RST : std_logic;

  -- CONTROLLER
  -- CONTROL
  signal start_controller : std_logic;
  signal ready_controller : std_logic;

  signal w_in_l_enable_controller : std_logic;
  signal w_in_x_enable_controller : std_logic;

  signal w_out_l_enable_controller : std_logic;
  signal w_out_x_enable_controller : std_logic;

  signal b_in_enable_controller : std_logic;

  signal b_out_enable_controller : std_logic;

  signal x_in_enable_controller : std_logic;

  signal x_out_enable_controller : std_logic;

  signal h_out_enable_controller : std_logic;

  -- DATA
  signal size_t_in_controller : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_x_in_controller : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_l_in_controller : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal w_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal b_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);

  signal x_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal h_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);

  signal h_out_controller : std_logic_vector(DATA_SIZE-1 downto 0);

  -- TRAINER
  -- CONTROL
  signal start_trainer : std_logic;
  signal ready_trainer : std_logic;

  signal x_in_t_enable_trainer : std_logic;
  signal x_in_x_enable_trainer : std_logic;

  signal x_out_t_enable_trainer : std_logic;
  signal x_out_x_enable_trainer : std_logic;

  signal h_in_t_enable_trainer : std_logic;
  signal h_in_l_enable_trainer : std_logic;

  signal h_out_t_enable_trainer : std_logic;
  signal h_out_l_enable_trainer : std_logic;

  signal w_out_l_enable_trainer : std_logic;
  signal w_out_x_enable_trainer : std_logic;

  signal b_out_enable_trainer : std_logic;

  -- DATA
  signal size_t_in_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_x_in_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_l_in_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal x_in_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal h_in_trainer : std_logic_vector(DATA_SIZE-1 downto 0);

  signal w_out_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal b_out_trainer : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- STIMULUS
  model_trainer_linear_stimulus_i : model_trainer_linear_stimulus
    generic map (
      -- SYSTEM-SIZE
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE,

      X => X,
      Y => Y,
      N => N,
      W => W,
      L => L,
      R => R
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      NTM_TRAINER_LINEAR_START => start_trainer,
      NTM_TRAINER_LINEAR_READY => ready_trainer,

      NTM_TRAINER_LINEAR_X_IN_T_ENABLE => x_in_t_enable_trainer,
      NTM_TRAINER_LINEAR_X_IN_X_ENABLE => x_in_x_enable_trainer,

      NTM_TRAINER_LINEAR_X_OUT_T_ENABLE => x_out_t_enable_trainer,
      NTM_TRAINER_LINEAR_X_OUT_X_ENABLE => x_out_x_enable_trainer,

      NTM_TRAINER_LINEAR_H_IN_T_ENABLE => h_in_t_enable_trainer,
      NTM_TRAINER_LINEAR_H_IN_L_ENABLE => h_in_l_enable_trainer,

      NTM_TRAINER_LINEAR_H_OUT_T_ENABLE => h_out_t_enable_trainer,
      NTM_TRAINER_LINEAR_H_OUT_L_ENABLE => h_out_l_enable_trainer,

      NTM_TRAINER_LINEAR_W_OUT_L_ENABLE => w_out_l_enable_trainer,
      NTM_TRAINER_LINEAR_W_OUT_X_ENABLE => w_out_x_enable_trainer,

      NTM_TRAINER_LINEAR_B_OUT_ENABLE => b_out_enable_trainer,

      -- DATA
      NTM_TRAINER_LINEAR_SIZE_T_IN => size_t_in_trainer,
      NTM_TRAINER_LINEAR_SIZE_X_IN => size_x_in_trainer,
      NTM_TRAINER_LINEAR_SIZE_L_IN => size_l_in_trainer,

      NTM_TRAINER_LINEAR_X_IN => x_in_trainer,
      NTM_TRAINER_LINEAR_H_IN => h_in_trainer,

      NTM_TRAINER_LINEAR_W_OUT => w_out_trainer,
      NTM_TRAINER_LINEAR_B_OUT => b_out_trainer
      );

  -- CONTROLLER
  controller : model_controller
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_controller,
      READY => ready_controller,

      W_IN_L_ENABLE => w_in_l_enable_controller,
      W_IN_X_ENABLE => w_in_x_enable_controller,

      W_OUT_L_ENABLE => w_out_l_enable_controller,
      W_OUT_X_ENABLE => w_out_x_enable_controller,

      B_IN_ENABLE => b_in_enable_controller,

      B_OUT_ENABLE => b_out_enable_controller,

      X_IN_ENABLE => x_in_enable_controller,

      X_OUT_ENABLE => x_out_enable_controller,

      H_OUT_ENABLE => h_out_enable_controller,

      -- DATA
      SIZE_X_IN => size_x_in_controller,
      SIZE_L_IN => size_l_in_controller,

      W_IN => w_in_controller,
      B_IN => b_in_controller,

      X_IN => x_in_controller,

      H_OUT => h_out_controller
      );

  -- TRAINER
  trainer : model_trainer
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_trainer,
      READY => ready_trainer,

      X_IN_T_ENABLE => x_in_t_enable_trainer,
      X_IN_X_ENABLE => x_in_x_enable_trainer,

      X_OUT_T_ENABLE => x_out_t_enable_trainer,
      X_OUT_X_ENABLE => x_out_x_enable_trainer,

      H_IN_T_ENABLE => h_in_t_enable_trainer,
      H_IN_L_ENABLE => h_in_l_enable_trainer,

      H_OUT_T_ENABLE => h_out_t_enable_trainer,
      H_OUT_L_ENABLE => h_out_l_enable_trainer,

      W_OUT_L_ENABLE => w_out_l_enable_trainer,
      W_OUT_X_ENABLE => w_out_x_enable_trainer,

      B_OUT_L_ENABLE => b_out_enable_trainer,

      -- DATA
      SIZE_T_IN => size_t_in_trainer,
      SIZE_X_IN => size_x_in_trainer,
      SIZE_L_IN => size_l_in_trainer,

      X_IN => x_in_trainer,
      H_IN => h_in_trainer,

      W_OUT => w_out_trainer,
      B_OUT => b_out_trainer
      );

end model_trainer_linear_testbench_architecture;