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

package ntm_algebra_pkg is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -- SYSTEM-SIZE
  constant DATA_SIZE : integer := 128;

  constant CONTROL_X_SIZE : integer := 3;
  constant CONTROL_Y_SIZE : integer := 3;
  constant CONTROL_Z_SIZE : integer := 3;

  type tensor_buffer is array (0 to CONTROL_X_SIZE-1, 0 to CONTROL_Y_SIZE-1, 0 to CONTROL_Z_SIZE-1) of std_logic_vector(DATA_SIZE-1 downto 0);
  type matrix_buffer is array (0 to CONTROL_X_SIZE-1, 0 to CONTROL_Y_SIZE-1) of std_logic_vector(DATA_SIZE-1 downto 0);
  type vector_buffer is array (0 to CONTROL_X_SIZE-1) of std_logic_vector(DATA_SIZE-1 downto 0);

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  signal MONITOR_TEST : string(40 downto 1) := "                                        ";
  signal MONITOR_CASE : string(40 downto 1) := "                                        ";

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -- SYSTEM-SIZE
  constant SIZE_I : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));
  constant SIZE_J : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));
  constant SIZE_K : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));

  constant SIZE : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));

  constant X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- x in 0 to X-1
  constant Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- y in 0 to Y-1
  constant N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- j in 0 to N-1
  constant W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- k in 0 to W-1
  constant L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- l in 0 to L-1
  constant R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- i in 0 to R-1

  -- INTEGERS
  constant P_ZERO  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(0, DATA_SIZE));
  constant P_ONE   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(1, DATA_SIZE));
  constant P_TWO   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(2, DATA_SIZE));
  constant P_THREE : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(3, DATA_SIZE));
  constant P_FOUR  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(4, DATA_SIZE));
  constant P_FIVE  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(5, DATA_SIZE));
  constant P_SIX   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(6, DATA_SIZE));
  constant P_SEVEN : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(7, DATA_SIZE));
  constant P_EIGHT : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(8, DATA_SIZE));
  constant P_NINE  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(9, DATA_SIZE));

  constant N_ONE   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(-1, DATA_SIZE));
  constant N_TWO   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(-2, DATA_SIZE));
  constant N_THREE : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(-3, DATA_SIZE));
  constant N_FOUR  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(-4, DATA_SIZE));
  constant N_FIVE  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(-5, DATA_SIZE));
  constant N_SIX   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(-6, DATA_SIZE));
  constant N_SEVEN : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(-7, DATA_SIZE));
  constant N_EIGHT : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(-8, DATA_SIZE));
  constant N_NINE  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(-9, DATA_SIZE));

  -- Buffer
  constant TENSOR_SAMPLE_A : tensor_buffer := (((P_TWO, P_ONE, P_FOUR), (P_NINE, P_FOUR, P_TWO), (P_ONE, P_ONE, P_TWO)), ((P_EIGHT, P_SIX, P_TWO), (P_EIGHT, P_FIVE, P_TWO), (P_ONE, P_FOUR, P_ONE)), ((P_THREE, P_ONE, P_SIX), (P_FIVE, P_ZERO, P_FOUR), (P_FIVE, P_EIGHT, P_FIVE)));
  constant TENSOR_SAMPLE_B : tensor_buffer := (((P_ONE, P_THREE, P_ONE), (P_TWO, P_FOUR, P_EIGHT), (P_FOUR, P_ONE, P_TWO)), ((P_NINE, P_ONE, P_FIVE), (P_NINE, P_EIGHT, P_ONE), (P_FIVE, P_EIGHT, P_FOUR)), ((P_FIVE, P_FOUR, P_ONE), (P_THREE, P_FOUR, P_SIX), (P_ONE, P_EIGHT, P_EIGHT)));

  constant MATRIX_SAMPLE_A : matrix_buffer := ((P_ONE, P_FOUR, P_ONE), (P_ZERO, P_EIGHT, P_FOUR), (P_FIVE, P_THREE, P_NINE));
  constant MATRIX_SAMPLE_B : matrix_buffer := ((P_ONE, P_TWO, P_SIX), (P_ONE, P_THREE, P_SIX), (P_EIGHT, P_FOUR, P_FOUR));

  constant VECTOR_SAMPLE_A : vector_buffer := (P_FOUR, P_SEVEN, N_THREE);
  constant VECTOR_SAMPLE_B : vector_buffer := (P_THREE, N_NINE, N_ONE);

  constant SCALAR_SAMPLE_A : std_logic_vector(DATA_SIZE-1 downto 0) := P_NINE;
  constant SCALAR_SAMPLE_B : std_logic_vector(DATA_SIZE-1 downto 0) := N_FOUR;

  -- VECTOR-FUNCTIONALITY
  signal STIMULUS_NTM_DOT_PRODUCT_TEST              : boolean := false;
  signal STIMULUS_NTM_VECTOR_CONVOLUTION_TEST       : boolean := false;
  signal STIMULUS_NTM_VECTOR_COSINE_SIMILARITY_TEST : boolean := false;
  signal STIMULUS_NTM_VECTOR_MULTIPLICATION_TEST    : boolean := false;
  signal STIMULUS_NTM_VECTOR_SUMMATION_TEST         : boolean := false;
  signal STIMULUS_NTM_VECTOR_TRANSPOSE_TEST         : boolean := false;

  signal STIMULUS_NTM_DOT_PRODUCT_CASE_0              : boolean := false;
  signal STIMULUS_NTM_VECTOR_CONVOLUTION_CASE_0       : boolean := false;
  signal STIMULUS_NTM_VECTOR_COSINE_SIMILARITY_CASE_0 : boolean := false;
  signal STIMULUS_NTM_VECTOR_MULTIPLICATION_CASE_0    : boolean := false;
  signal STIMULUS_NTM_VECTOR_SUMMATION_CASE_0         : boolean := false;
  signal STIMULUS_NTM_VECTOR_TRANSPOSE_CASE_0         : boolean := false;

  signal STIMULUS_NTM_DOT_PRODUCT_CASE_1              : boolean := false;
  signal STIMULUS_NTM_VECTOR_CONVOLUTION_CASE_1       : boolean := false;
  signal STIMULUS_NTM_VECTOR_COSINE_SIMILARITY_CASE_1 : boolean := false;
  signal STIMULUS_NTM_VECTOR_MULTIPLICATION_CASE_1    : boolean := false;
  signal STIMULUS_NTM_VECTOR_SUMMATION_CASE_1         : boolean := false;
  signal STIMULUS_NTM_VECTOR_TRANSPOSE_CASE_1         : boolean := false;

  -- MATRIX-FUNCTIONALITY
  signal STIMULUS_NTM_MATRIX_CONVOLUTION_TEST       : boolean := false;
  signal STIMULUS_NTM_MATRIX_INVERSE_TEST : boolean := false;
  signal STIMULUS_NTM_MATRIX_MULTIPLICATION_TEST    : boolean := false;
  signal STIMULUS_NTM_MATRIX_PRODUCT_TEST           : boolean := false;
  signal STIMULUS_NTM_MATRIX_SUMMATION_TEST         : boolean := false;
  signal STIMULUS_NTM_MATRIX_TRANSPOSE_TEST         : boolean := false;

  signal STIMULUS_NTM_MATRIX_CONVOLUTION_CASE_0       : boolean := false;
  signal STIMULUS_NTM_MATRIX_INVERSE_CASE_0 : boolean := false;
  signal STIMULUS_NTM_MATRIX_MULTIPLICATION_CASE_0    : boolean := false;
  signal STIMULUS_NTM_MATRIX_PRODUCT_CASE_0           : boolean := false;
  signal STIMULUS_NTM_MATRIX_SUMMATION_CASE_0         : boolean := false;
  signal STIMULUS_NTM_MATRIX_TRANSPOSE_CASE_0         : boolean := false;

  signal STIMULUS_NTM_MATRIX_CONVOLUTION_CASE_1       : boolean := false;
  signal STIMULUS_NTM_MATRIX_INVERSE_CASE_1 : boolean := false;
  signal STIMULUS_NTM_MATRIX_MULTIPLICATION_CASE_1    : boolean := false;
  signal STIMULUS_NTM_MATRIX_PRODUCT_CASE_1           : boolean := false;
  signal STIMULUS_NTM_MATRIX_SUMMATION_CASE_1         : boolean := false;
  signal STIMULUS_NTM_MATRIX_TRANSPOSE_CASE_1         : boolean := false;

  -- TENSOR-FUNCTIONALITY
  signal STIMULUS_NTM_TENSOR_CONVOLUTION_TEST       : boolean := false;
  signal STIMULUS_NTM_TENSOR_INVERSE_TEST : boolean := false;
  signal STIMULUS_NTM_TENSOR_MULTIPLICATION_TEST    : boolean := false;
  signal STIMULUS_NTM_TENSOR_PRODUCT_TEST           : boolean := false;
  signal STIMULUS_NTM_TENSOR_SUMMATION_TEST         : boolean := false;
  signal STIMULUS_NTM_TENSOR_TRANSPOSE_TEST         : boolean := false;

  signal STIMULUS_NTM_TENSOR_CONVOLUTION_CASE_0       : boolean := false;
  signal STIMULUS_NTM_TENSOR_INVERSE_CASE_0 : boolean := false;
  signal STIMULUS_NTM_TENSOR_MULTIPLICATION_CASE_0    : boolean := false;
  signal STIMULUS_NTM_TENSOR_PRODUCT_CASE_0           : boolean := false;
  signal STIMULUS_NTM_TENSOR_SUMMATION_CASE_0         : boolean := false;
  signal STIMULUS_NTM_TENSOR_TRANSPOSE_CASE_0         : boolean := false;

  signal STIMULUS_NTM_TENSOR_CONVOLUTION_CASE_1       : boolean := false;
  signal STIMULUS_NTM_TENSOR_INVERSE_CASE_1 : boolean := false;
  signal STIMULUS_NTM_TENSOR_MULTIPLICATION_CASE_1    : boolean := false;
  signal STIMULUS_NTM_TENSOR_PRODUCT_CASE_1           : boolean := false;
  signal STIMULUS_NTM_TENSOR_SUMMATION_CASE_1         : boolean := false;
  signal STIMULUS_NTM_TENSOR_TRANSPOSE_CASE_1         : boolean := false;

  -----------------------------------------------------------------------
  -- Components
  -----------------------------------------------------------------------

  component ntm_algebra_stimulus is
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

      -- DOT PRODUCT
      -- CONTROL
      DOT_PRODUCT_START : out std_logic;
      DOT_PRODUCT_READY : in  std_logic;

      DOT_PRODUCT_DATA_A_IN_ENABLE : out std_logic;
      DOT_PRODUCT_DATA_B_IN_ENABLE : out std_logic;

      DOT_PRODUCT_DATA_OUT_ENABLE : in std_logic;

      -- DATA
      DOT_PRODUCT_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      DOT_PRODUCT_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      DOT_PRODUCT_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      DOT_PRODUCT_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- VECTOR CONVOLUTION
      -- CONTROL
      VECTOR_CONVOLUTION_START : out std_logic;
      VECTOR_CONVOLUTION_READY : in  std_logic;

      VECTOR_CONVOLUTION_DATA_A_IN_ENABLE : out std_logic;
      VECTOR_CONVOLUTION_DATA_B_IN_ENABLE : out std_logic;

      VECTOR_CONVOLUTION_DATA_ENABLE : in std_logic;

      VECTOR_CONVOLUTION_DATA_OUT_ENABLE : in std_logic;

      -- DATA
      VECTOR_CONVOLUTION_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      VECTOR_CONVOLUTION_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_CONVOLUTION_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_CONVOLUTION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- VECTOR COSINE_SIMILARITY
      -- CONTROL
      VECTOR_COSINE_SIMILARITY_START : out std_logic;
      VECTOR_COSINE_SIMILARITY_READY : in  std_logic;

      VECTOR_COSINE_SIMILARITY_DATA_A_IN_ENABLE : out std_logic;
      VECTOR_COSINE_SIMILARITY_DATA_B_IN_ENABLE : out std_logic;

      VECTOR_COSINE_SIMILARITY_DATA_OUT_ENABLE : in std_logic;

      -- DATA
      VECTOR_COSINE_SIMILARITY_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      VECTOR_COSINE_SIMILARITY_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_COSINE_SIMILARITY_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_COSINE_SIMILARITY_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- VECTOR MULTIPLICATION
      -- CONTROL
      VECTOR_MULTIPLICATION_START : out std_logic;
      VECTOR_MULTIPLICATION_READY : in  std_logic;

      VECTOR_MULTIPLICATION_DATA_IN_ENABLE : out std_logic;

      VECTOR_MULTIPLICATION_DATA_OUT_ENABLE : in std_logic;

      -- DATA
      VECTOR_MULTIPLICATION_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      VECTOR_MULTIPLICATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_MULTIPLICATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- VECTOR SUMMATION
      -- CONTROL
      VECTOR_SUMMATION_START : out std_logic;
      VECTOR_SUMMATION_READY : in  std_logic;

      VECTOR_SUMMATION_DATA_IN_ENABLE : out std_logic;

      VECTOR_SUMMATION_DATA_OUT_ENABLE : in std_logic;

      -- DATA
      VECTOR_SUMMATION_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      VECTOR_SUMMATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_SUMMATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- VECTOR TRANSPOSE
      -- CONTROL
      VECTOR_TRANSPOSE_START : out std_logic;
      VECTOR_TRANSPOSE_READY : in  std_logic;

      VECTOR_TRANSPOSE_DATA_IN_ENABLE : out std_logic;

      VECTOR_TRANSPOSE_DATA_ENABLE : in std_logic;

      VECTOR_TRANSPOSE_DATA_OUT_ENABLE : in std_logic;

      -- DATA
      VECTOR_TRANSPOSE_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      VECTOR_TRANSPOSE_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_TRANSPOSE_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- MATRIX CONVOLUTION
      -- CONTROL
      MATRIX_CONVOLUTION_START : out std_logic;
      MATRIX_CONVOLUTION_READY : in  std_logic;

      MATRIX_CONVOLUTION_DATA_A_IN_I_ENABLE : out std_logic;
      MATRIX_CONVOLUTION_DATA_A_IN_J_ENABLE : out std_logic;
      MATRIX_CONVOLUTION_DATA_B_IN_I_ENABLE : out std_logic;
      MATRIX_CONVOLUTION_DATA_B_IN_J_ENABLE : out std_logic;

      MATRIX_CONVOLUTION_DATA_I_ENABLE : in std_logic;
      MATRIX_CONVOLUTION_DATA_J_ENABLE : in std_logic;

      MATRIX_CONVOLUTION_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_CONVOLUTION_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_CONVOLUTION_SIZE_A_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_CONVOLUTION_SIZE_A_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_CONVOLUTION_SIZE_B_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_CONVOLUTION_SIZE_B_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_CONVOLUTION_DATA_A_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_CONVOLUTION_DATA_B_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_CONVOLUTION_DATA_OUT    : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- MATRIX INVERSE
      -- CONTROL
      MATRIX_INVERSE_START : out std_logic;
      MATRIX_INVERSE_READY : in  std_logic;

      MATRIX_INVERSE_DATA_A_IN_I_ENABLE : out std_logic;
      MATRIX_INVERSE_DATA_A_IN_J_ENABLE : out std_logic;
      MATRIX_INVERSE_DATA_B_IN_I_ENABLE : out std_logic;
      MATRIX_INVERSE_DATA_B_IN_J_ENABLE : out std_logic;

      MATRIX_INVERSE_DATA_I_ENABLE : in std_logic;
      MATRIX_INVERSE_DATA_J_ENABLE : in std_logic;

      MATRIX_INVERSE_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_INVERSE_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_INVERSE_SIZE_A_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_INVERSE_SIZE_A_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_INVERSE_SIZE_B_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_INVERSE_SIZE_B_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_INVERSE_DATA_A_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_INVERSE_DATA_B_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_INVERSE_DATA_OUT    : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- MATRIX MULTIPLICATION
      -- CONTROL
      MATRIX_MULTIPLICATION_START : out std_logic;
      MATRIX_MULTIPLICATION_READY : in  std_logic;

      MATRIX_MULTIPLICATION_DATA_IN_I_ENABLE : out std_logic;
      MATRIX_MULTIPLICATION_DATA_IN_J_ENABLE : out std_logic;

      MATRIX_MULTIPLICATION_DATA_I_ENABLE : in std_logic;
      MATRIX_MULTIPLICATION_DATA_J_ENABLE : in std_logic;

      MATRIX_MULTIPLICATION_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_MULTIPLICATION_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_MULTIPLICATION_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_MULTIPLICATION_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_MULTIPLICATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_MULTIPLICATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- MATRIX PRODUCT
      -- CONTROL
      MATRIX_PRODUCT_START : out std_logic;
      MATRIX_PRODUCT_READY : in  std_logic;

      MATRIX_PRODUCT_DATA_A_IN_I_ENABLE : out std_logic;
      MATRIX_PRODUCT_DATA_A_IN_J_ENABLE : out std_logic;
      MATRIX_PRODUCT_DATA_B_IN_I_ENABLE : out std_logic;
      MATRIX_PRODUCT_DATA_B_IN_J_ENABLE : out std_logic;

      MATRIX_PRODUCT_DATA_I_ENABLE : in std_logic;
      MATRIX_PRODUCT_DATA_J_ENABLE : in std_logic;

      MATRIX_PRODUCT_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_PRODUCT_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_PRODUCT_SIZE_A_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_PRODUCT_SIZE_A_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_PRODUCT_SIZE_B_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_PRODUCT_SIZE_B_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_PRODUCT_DATA_A_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_PRODUCT_DATA_B_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_PRODUCT_DATA_OUT    : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- MATRIX SUMMATION
      -- CONTROL
      MATRIX_SUMMATION_START : out std_logic;
      MATRIX_SUMMATION_READY : in  std_logic;

      MATRIX_SUMMATION_DATA_IN_I_ENABLE : out std_logic;
      MATRIX_SUMMATION_DATA_IN_J_ENABLE : out std_logic;

      MATRIX_SUMMATION_DATA_I_ENABLE : in std_logic;
      MATRIX_SUMMATION_DATA_J_ENABLE : in std_logic;

      MATRIX_SUMMATION_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_SUMMATION_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_SUMMATION_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_SUMMATION_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_SUMMATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_SUMMATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- MATRIX TRANSPOSE
      -- CONTROL
      MATRIX_TRANSPOSE_START : out std_logic;
      MATRIX_TRANSPOSE_READY : in  std_logic;

      MATRIX_TRANSPOSE_DATA_IN_I_ENABLE : out std_logic;
      MATRIX_TRANSPOSE_DATA_IN_J_ENABLE : out std_logic;

      MATRIX_TRANSPOSE_DATA_I_ENABLE : in std_logic;
      MATRIX_TRANSPOSE_DATA_J_ENABLE : in std_logic;

      MATRIX_TRANSPOSE_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_TRANSPOSE_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_TRANSPOSE_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_TRANSPOSE_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_TRANSPOSE_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_TRANSPOSE_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- TENSOR CONVOLUTION
      -- CONTROL
      TENSOR_CONVOLUTION_START : out std_logic;
      TENSOR_CONVOLUTION_READY : in  std_logic;

      TENSOR_CONVOLUTION_DATA_A_IN_I_ENABLE : out std_logic;
      TENSOR_CONVOLUTION_DATA_A_IN_J_ENABLE : out std_logic;
      TENSOR_CONVOLUTION_DATA_A_IN_K_ENABLE : out std_logic;
      TENSOR_CONVOLUTION_DATA_B_IN_I_ENABLE : out std_logic;
      TENSOR_CONVOLUTION_DATA_B_IN_J_ENABLE : out std_logic;
      TENSOR_CONVOLUTION_DATA_B_IN_K_ENABLE : out std_logic;

      TENSOR_CONVOLUTION_DATA_I_ENABLE : in std_logic;
      TENSOR_CONVOLUTION_DATA_J_ENABLE : in std_logic;
      TENSOR_CONVOLUTION_DATA_K_ENABLE : in std_logic;

      TENSOR_CONVOLUTION_DATA_OUT_I_ENABLE : in std_logic;
      TENSOR_CONVOLUTION_DATA_OUT_J_ENABLE : in std_logic;
      TENSOR_CONVOLUTION_DATA_OUT_K_ENABLE : in std_logic;

      -- DATA
      TENSOR_CONVOLUTION_SIZE_A_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_CONVOLUTION_SIZE_A_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_CONVOLUTION_SIZE_A_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_CONVOLUTION_SIZE_B_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_CONVOLUTION_SIZE_B_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_CONVOLUTION_SIZE_B_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_CONVOLUTION_DATA_A_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_CONVOLUTION_DATA_B_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_CONVOLUTION_DATA_OUT    : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- TENSOR INVERSE
      -- CONTROL
      TENSOR_INVERSE_START : out std_logic;
      TENSOR_INVERSE_READY : in  std_logic;

      TENSOR_INVERSE_DATA_A_IN_I_ENABLE : out std_logic;
      TENSOR_INVERSE_DATA_A_IN_J_ENABLE : out std_logic;
      TENSOR_INVERSE_DATA_A_IN_K_ENABLE : out std_logic;
      TENSOR_INVERSE_DATA_B_IN_I_ENABLE : out std_logic;
      TENSOR_INVERSE_DATA_B_IN_J_ENABLE : out std_logic;
      TENSOR_INVERSE_DATA_B_IN_K_ENABLE : out std_logic;

      TENSOR_INVERSE_DATA_I_ENABLE : in std_logic;
      TENSOR_INVERSE_DATA_J_ENABLE : in std_logic;
      TENSOR_INVERSE_DATA_K_ENABLE : in std_logic;

      TENSOR_INVERSE_DATA_OUT_I_ENABLE : in std_logic;
      TENSOR_INVERSE_DATA_OUT_J_ENABLE : in std_logic;
      TENSOR_INVERSE_DATA_OUT_K_ENABLE : in std_logic;

      -- DATA
      TENSOR_INVERSE_SIZE_A_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_INVERSE_SIZE_A_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_INVERSE_SIZE_A_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_INVERSE_SIZE_B_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_INVERSE_SIZE_B_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_INVERSE_SIZE_B_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_INVERSE_DATA_A_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_INVERSE_DATA_B_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_INVERSE_DATA_OUT    : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- TENSOR MULTIPLICATION
      -- CONTROL
      TENSOR_MULTIPLICATION_START : out std_logic;
      TENSOR_MULTIPLICATION_READY : in  std_logic;

      TENSOR_MULTIPLICATION_DATA_IN_I_ENABLE : out std_logic;
      TENSOR_MULTIPLICATION_DATA_IN_J_ENABLE : out std_logic;
      TENSOR_MULTIPLICATION_DATA_IN_K_ENABLE : out std_logic;

      TENSOR_MULTIPLICATION_DATA_I_ENABLE : in std_logic;
      TENSOR_MULTIPLICATION_DATA_J_ENABLE : in std_logic;
      TENSOR_MULTIPLICATION_DATA_K_ENABLE : in std_logic;

      TENSOR_MULTIPLICATION_DATA_OUT_I_ENABLE : in std_logic;
      TENSOR_MULTIPLICATION_DATA_OUT_J_ENABLE : in std_logic;
      TENSOR_MULTIPLICATION_DATA_OUT_K_ENABLE : in std_logic;

      -- DATA
      TENSOR_MULTIPLICATION_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_MULTIPLICATION_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_MULTIPLICATION_SIZE_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_MULTIPLICATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_MULTIPLICATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- TENSOR PRODUCT
      -- CONTROL
      TENSOR_PRODUCT_START : out std_logic;
      TENSOR_PRODUCT_READY : in  std_logic;

      TENSOR_PRODUCT_DATA_A_IN_I_ENABLE : out std_logic;
      TENSOR_PRODUCT_DATA_A_IN_J_ENABLE : out std_logic;
      TENSOR_PRODUCT_DATA_A_IN_K_ENABLE : out std_logic;
      TENSOR_PRODUCT_DATA_B_IN_I_ENABLE : out std_logic;
      TENSOR_PRODUCT_DATA_B_IN_J_ENABLE : out std_logic;
      TENSOR_PRODUCT_DATA_B_IN_K_ENABLE : out std_logic;

      TENSOR_PRODUCT_DATA_I_ENABLE : in std_logic;
      TENSOR_PRODUCT_DATA_J_ENABLE : in std_logic;
      TENSOR_PRODUCT_DATA_K_ENABLE : in std_logic;

      TENSOR_PRODUCT_DATA_OUT_I_ENABLE : in std_logic;
      TENSOR_PRODUCT_DATA_OUT_J_ENABLE : in std_logic;
      TENSOR_PRODUCT_DATA_OUT_K_ENABLE : in std_logic;

      -- DATA
      TENSOR_PRODUCT_SIZE_A_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_PRODUCT_SIZE_A_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_PRODUCT_SIZE_A_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_PRODUCT_SIZE_B_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_PRODUCT_SIZE_B_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_PRODUCT_SIZE_B_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_PRODUCT_DATA_A_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_PRODUCT_DATA_B_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_PRODUCT_DATA_OUT    : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- TENSOR SUMMATION
      -- CONTROL
      TENSOR_SUMMATION_START : out std_logic;
      TENSOR_SUMMATION_READY : in  std_logic;

      TENSOR_SUMMATION_DATA_IN_I_ENABLE : out std_logic;
      TENSOR_SUMMATION_DATA_IN_J_ENABLE : out std_logic;
      TENSOR_SUMMATION_DATA_IN_K_ENABLE : out std_logic;

      TENSOR_SUMMATION_DATA_I_ENABLE : in std_logic;
      TENSOR_SUMMATION_DATA_J_ENABLE : in std_logic;
      TENSOR_SUMMATION_DATA_K_ENABLE : in std_logic;

      TENSOR_SUMMATION_DATA_OUT_I_ENABLE : in std_logic;
      TENSOR_SUMMATION_DATA_OUT_J_ENABLE : in std_logic;
      TENSOR_SUMMATION_DATA_OUT_K_ENABLE : in std_logic;

      -- DATA
      TENSOR_SUMMATION_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_SUMMATION_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_SUMMATION_SIZE_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_SUMMATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_SUMMATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- TENSOR TRANSPOSE
      -- CONTROL
      TENSOR_TRANSPOSE_START : out std_logic;
      TENSOR_TRANSPOSE_READY : in  std_logic;

      TENSOR_TRANSPOSE_DATA_IN_I_ENABLE : out std_logic;
      TENSOR_TRANSPOSE_DATA_IN_J_ENABLE : out std_logic;
      TENSOR_TRANSPOSE_DATA_IN_K_ENABLE : out std_logic;

      TENSOR_TRANSPOSE_DATA_I_ENABLE : in std_logic;
      TENSOR_TRANSPOSE_DATA_J_ENABLE : in std_logic;
      TENSOR_TRANSPOSE_DATA_K_ENABLE : in std_logic;

      TENSOR_TRANSPOSE_DATA_OUT_I_ENABLE : in std_logic;
      TENSOR_TRANSPOSE_DATA_OUT_J_ENABLE : in std_logic;
      TENSOR_TRANSPOSE_DATA_OUT_K_ENABLE : in std_logic;

      -- DATA
      TENSOR_TRANSPOSE_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_TRANSPOSE_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_TRANSPOSE_SIZE_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_TRANSPOSE_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_TRANSPOSE_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  -----------------------------------------------------------------------
  -- Functions
  -----------------------------------------------------------------------

end ntm_algebra_pkg;
