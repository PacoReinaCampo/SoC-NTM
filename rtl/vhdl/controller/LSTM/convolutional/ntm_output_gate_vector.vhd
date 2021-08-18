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

use work.ntm_pkg.all;

entity ntm_output_gate_vector is
  generic (
    X : integer := 64;
    W : integer := 64;
    H : integer := 64;

    DATA_SIZE : integer := 512
  );
  port (
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic;

    -- DATA
    W_IN : in std_logic_arithmetic_vector_matrix(H-1 downto 0)(X-1 downto 0)(DATA_SIZE-1 downto 0);
    K_IN : in std_logic_arithmetic_vector_matrix(H-1 downto 0)(W-1 downto 0)(DATA_SIZE-1 downto 0);
    U_IN : in std_logic_arithmetic_vector_matrix(H-1 downto 0)(H-1 downto 0)(DATA_SIZE-1 downto 0);

    X_IN : in std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
    R_IN : in std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
    H_IN : in std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);

    B_IN : in std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);

    MODULO : in  std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);
    O_OUT  : out std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0)
  );
end entity;

architecture ntm_output_gate_vector_architecture of ntm_output_gate_vector is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- VECTOR LOGISTIC FUNCTION
  -- CONTROL
  signal start_vector_logistic_function : std_logic;
  signal ready_vector_logistic_function : std_logic;

  -- DATA
  signal modulo_vector_logistic_function   : std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_in_vector_logistic_function  : std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_out_vector_logistic_function : std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);

  -- VECTOR ADDER
  -- CONTROL
  signal start_vector_adder : std_logic;
  signal ready_vector_adder : std_logic;

  signal operation_vector_adder : std_logic;

  -- DATA
  signal modulo_vector_adder    : std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_a_in_vector_adder : std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_adder : std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_out_vector_adder  : std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);

  -- MATRIX CONVOLUTION X
  -- CONTROL
  signal start_matrix_convolution_x : std_logic;
  signal ready_matrix_convolution_x : std_logic;

  -- DATA
  signal modulo_matrix_convolution_x    : std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_a_in_matrix_convolution_x : std_logic_arithmetic_vector_matrix(H-1 downto 0)(X-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_convolution_x : std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_out_matrix_convolution_x  : std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);

  -- MATRIX CONVOLUTION W
  -- CONTROL
  signal start_matrix_convolution_w : std_logic;
  signal ready_matrix_convolution_w : std_logic;

  -- DATA
  signal modulo_matrix_convolution_w    : std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_a_in_matrix_convolution_w : std_logic_arithmetic_vector_matrix(H-1 downto 0)(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_convolution_w : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_out_matrix_convolution_w  : std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);

  -- MATRIX CONVOLUTION H
  -- CONTROL
  signal start_matrix_convolution_h : std_logic;
  signal ready_matrix_convolution_h : std_logic;

  -- DATA
  signal modulo_matrix_convolution_h    : std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_a_in_matrix_convolution_h : std_logic_arithmetic_vector_matrix(H-1 downto 0)(H-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_convolution_h : std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_out_matrix_convolution_h  : std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  ntm_vector_logistic_function_i : ntm_vector_logistic_function
    generic map (
      X => H,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_logistic_function,
      READY => ready_vector_logistic_function,

      -- DATA
      MODULO   => modulo_vector_logistic_function,
      DATA_IN  => data_in_vector_logistic_function,
      DATA_OUT => data_out_vector_logistic_function
    );

  ntm_vector_adder_i : ntm_vector_adder
    generic map (
      X => H,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_adder,
      READY => ready_vector_adder,

      OPERATION => operation_vector_adder,

      -- DATA
      MODULO    => modulo_vector_adder,
      DATA_A_IN => data_a_in_vector_adder,
      DATA_B_IN => data_b_in_vector_adder,
      DATA_OUT  => data_out_vector_adder
    );

  ntm_matrix_convolution_h_i : ntm_matrix_convolution
    generic map (
      X => H,
      Y => X,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_convolution_x,
      READY => ready_matrix_convolution_x,

      -- DATA
      MODULO    => modulo_matrix_convolution_x,
      DATA_A_IN => data_a_in_matrix_convolution_x,
      DATA_B_IN => data_b_in_matrix_convolution_x,
      DATA_OUT  => data_out_matrix_convolution_x
    );

  ntm_matrix_convolution_w_i : ntm_matrix_convolution
    generic map (
      X => H,
      Y => W,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_convolution_w,
      READY => ready_matrix_convolution_w,

      -- DATA
      MODULO    => modulo_matrix_convolution_w,
      DATA_A_IN => data_a_in_matrix_convolution_w,
      DATA_B_IN => data_b_in_matrix_convolution_w,
      DATA_OUT  => data_out_matrix_convolution_w
    );

  ntm_matrix_convolution_h_i : ntm_matrix_convolution
    generic map (
      X => H,
      Y => H,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_convolution_h,
      READY => ready_matrix_convolution_h,

      -- DATA
      MODULO    => modulo_matrix_convolution_h,
      DATA_A_IN => data_a_in_matrix_convolution_h,
      DATA_B_IN => data_b_in_matrix_convolution_h,
      DATA_OUT  => data_out_matrix_convolution_h
    );

end architecture;