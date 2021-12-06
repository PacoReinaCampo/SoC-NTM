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
-- out the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included out
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
use work.ntm_function_pkg.all;

entity ntm_function_stimulus is
  generic (
    -- SYSTEM-SIZE
    DATA_SIZE  : integer := 512;
    INDEX_SIZE : integer := 512;

    X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- x out 0 to X-1
    Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- y out 0 to Y-1
    N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- j out 0 to N-1
    W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- k out 0 to W-1
    L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- l out 0 to L-1
    R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE))   -- i out 0 to R-1
    );
  port (
    -- GLOBAL
    CLK : out std_logic;
    RST : out std_logic;

    -----------------------------------------------------------------------
    -- STIMULUS SCALAR
    -----------------------------------------------------------------------

    -- SCALAR CONVOLUTION
    -- CONTROL
    SCALAR_CONVOLUTION_START : out std_logic;
    SCALAR_CONVOLUTION_READY : in  std_logic;

    SCALAR_CONVOLUTION_DATA_IN_ENABLE : out std_logic;

    SCALAR_CONVOLUTION_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    SCALAR_CONVOLUTION_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_CONVOLUTION_LENGTH_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_CONVOLUTION_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_CONVOLUTION_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_CONVOLUTION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR COSINE SIMILARITY
    -- CONTROL
    SCALAR_COSINE_SIMILARITY_START : out std_logic;
    SCALAR_COSINE_SIMILARITY_READY : in  std_logic;

    SCALAR_COSINE_SIMILARITY_DATA_IN_ENABLE : out std_logic;

    SCALAR_COSINE_SIMILARITY_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    SCALAR_COSINE_SIMILARITY_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_COSINE_SIMILARITY_LENGTH_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_COSINE_SIMILARITY_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_COSINE_SIMILARITY_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_COSINE_SIMILARITY_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR MULTIPLICATION
    -- CONTROL
    SCALAR_MULTIPLICATION_START : out std_logic;
    SCALAR_MULTIPLICATION_READY : in  std_logic;

    SCALAR_MULTIPLICATION_DATA_IN_ENABLE : out std_logic;

    SCALAR_MULTIPLICATION_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    SCALAR_MULTIPLICATION_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_MULTIPLICATION_LENGTH_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_MULTIPLICATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_MULTIPLICATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR COSH
    -- CONTROL
    SCALAR_COSH_START : out std_logic;
    SCALAR_COSH_READY : in  std_logic;

    -- DATA
    SCALAR_COSH_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_COSH_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_COSH_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR SINH
    -- CONTROL
    SCALAR_SINH_START : out std_logic;
    SCALAR_SINH_READY : in  std_logic;

    -- DATA
    SCALAR_SINH_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_SINH_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_SINH_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR TANH
    -- CONTROL
    SCALAR_TANH_START : out std_logic;
    SCALAR_TANH_READY : in  std_logic;

    -- DATA
    SCALAR_TANH_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_TANH_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_TANH_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- CONTROL
    SCALAR_LOGISTIC_START : out std_logic;
    SCALAR_LOGISTIC_READY : in  std_logic;

    -- DATA
    SCALAR_LOGISTIC_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_LOGISTIC_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_LOGISTIC_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR SOFTMAX
    -- CONTROL
    SCALAR_SOFTMAX_START : out std_logic;
    SCALAR_SOFTMAX_READY : in  std_logic;

    SCALAR_SOFTMAX_DATA_IN_ENABLE : out std_logic;

    SCALAR_SOFTMAX_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    SCALAR_SOFTMAX_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_SOFTMAX_LENGTH_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_SOFTMAX_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_SOFTMAX_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR ONEPLUS
    -- CONTROL
    SCALAR_ONEPLUS_START : out std_logic;
    SCALAR_ONEPLUS_READY : in  std_logic;

    -- DATA
    SCALAR_ONEPLUS_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_ONEPLUS_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_ONEPLUS_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR SUMMATION
    -- CONTROL
    SCALAR_SUMMATION_START : out std_logic;
    SCALAR_SUMMATION_READY : in  std_logic;

    SCALAR_SUMMATION_DATA_IN_ENABLE : out std_logic;

    SCALAR_SUMMATION_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    SCALAR_SUMMATION_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_SUMMATION_LENGTH_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_SUMMATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_SUMMATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -----------------------------------------------------------------------
    -- STIMULUS VECTOR
    -----------------------------------------------------------------------

    -- VECTOR CONVOLUTION
    -- CONTROL
    VECTOR_CONVOLUTION_START : out std_logic;
    VECTOR_CONVOLUTION_READY : in  std_logic;

    VECTOR_CONVOLUTION_DATA_A_IN_VECTOR_ENABLE : out std_logic;
    VECTOR_CONVOLUTION_DATA_A_IN_SCALAR_ENABLE : out std_logic;
    VECTOR_CONVOLUTION_DATA_B_IN_VECTOR_ENABLE : out std_logic;
    VECTOR_CONVOLUTION_DATA_B_IN_SCALAR_ENABLE : out std_logic;

    VECTOR_CONVOLUTION_DATA_OUT_VECTOR_ENABLE : in std_logic;
    VECTOR_CONVOLUTION_DATA_OUT_SCALAR_ENABLE : in std_logic;

    -- DATA
    VECTOR_CONVOLUTION_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_CONVOLUTION_SIZE_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_CONVOLUTION_LENGTH_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_CONVOLUTION_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_CONVOLUTION_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_CONVOLUTION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR COSINE SIMILARITY
    -- CONTROL
    VECTOR_COSINE_SIMILARITY_START : out std_logic;
    VECTOR_COSINE_SIMILARITY_READY : in  std_logic;

    VECTOR_COSINE_SIMILARITY_DATA_A_IN_VECTOR_ENABLE : out std_logic;
    VECTOR_COSINE_SIMILARITY_DATA_A_IN_SCALAR_ENABLE : out std_logic;
    VECTOR_COSINE_SIMILARITY_DATA_B_IN_VECTOR_ENABLE : out std_logic;
    VECTOR_COSINE_SIMILARITY_DATA_B_IN_SCALAR_ENABLE : out std_logic;

    VECTOR_COSINE_SIMILARITY_DATA_OUT_VECTOR_ENABLE : in std_logic;
    VECTOR_COSINE_SIMILARITY_DATA_OUT_SCALAR_ENABLE : in std_logic;

    -- DATA
    VECTOR_COSINE_SIMILARITY_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_COSINE_SIMILARITY_SIZE_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_COSINE_SIMILARITY_LENGTH_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_COSINE_SIMILARITY_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_COSINE_SIMILARITY_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_COSINE_SIMILARITY_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR MULTIPLICATION
    -- CONTROL
    VECTOR_MULTIPLICATION_START : out std_logic;
    VECTOR_MULTIPLICATION_READY : in  std_logic;

    VECTOR_MULTIPLICATION_DATA_IN_VECTOR_ENABLE : out std_logic;
    VECTOR_MULTIPLICATION_DATA_IN_SCALAR_ENABLE : out std_logic;

    VECTOR_MULTIPLICATION_DATA_OUT_VECTOR_ENABLE : in std_logic;
    VECTOR_MULTIPLICATION_DATA_OUT_SCALAR_ENABLE : in std_logic;

    -- DATA
    VECTOR_MULTIPLICATION_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_MULTIPLICATION_SIZE_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_MULTIPLICATION_LENGTH_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_MULTIPLICATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_MULTIPLICATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR COSH
    -- CONTROL
    VECTOR_COSH_START : out std_logic;
    VECTOR_COSH_READY : in  std_logic;

    VECTOR_COSH_DATA_IN_ENABLE : out std_logic;

    VECTOR_COSH_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_COSH_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_COSH_SIZE_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_COSH_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_COSH_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR SINH
    -- CONTROL
    VECTOR_SINH_START : out std_logic;
    VECTOR_SINH_READY : in  std_logic;

    VECTOR_SINH_DATA_IN_ENABLE : out std_logic;

    VECTOR_SINH_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_SINH_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_SINH_SIZE_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_SINH_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_SINH_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR TANH
    -- CONTROL
    VECTOR_TANH_START : out std_logic;
    VECTOR_TANH_READY : in  std_logic;

    VECTOR_TANH_DATA_IN_ENABLE : out std_logic;

    VECTOR_TANH_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_TANH_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_TANH_SIZE_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_TANH_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_TANH_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR LOGISTIC
    -- CONTROL
    VECTOR_LOGISTIC_START : out std_logic;
    VECTOR_LOGISTIC_READY : in  std_logic;

    VECTOR_LOGISTIC_DATA_IN_ENABLE : out std_logic;

    VECTOR_LOGISTIC_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_LOGISTIC_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_LOGISTIC_SIZE_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_LOGISTIC_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_LOGISTIC_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR SOFTMAX
    -- CONTROL
    VECTOR_SOFTMAX_START : out std_logic;
    VECTOR_SOFTMAX_READY : in  std_logic;

    VECTOR_SOFTMAX_DATA_IN_VECTOR_ENABLE : out std_logic;
    VECTOR_SOFTMAX_DATA_IN_SCALAR_ENABLE : out std_logic;

    VECTOR_SOFTMAX_DATA_OUT_VECTOR_ENABLE : in std_logic;
    VECTOR_SOFTMAX_DATA_OUT_SCALAR_ENABLE : in std_logic;

    -- DATA
    VECTOR_SOFTMAX_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_SOFTMAX_SIZE_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_SOFTMAX_LENGTH_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_SOFTMAX_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_SOFTMAX_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR ONEPLUS
    -- CONTROL
    VECTOR_ONEPLUS_START : out std_logic;
    VECTOR_ONEPLUS_READY : in  std_logic;

    VECTOR_ONEPLUS_DATA_IN_ENABLE : out std_logic;

    VECTOR_ONEPLUS_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_ONEPLUS_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_ONEPLUS_SIZE_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_ONEPLUS_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_ONEPLUS_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR SUMMATION
    -- CONTROL
    VECTOR_SUMMATION_START : out std_logic;
    VECTOR_SUMMATION_READY : in  std_logic;

    VECTOR_SUMMATION_DATA_IN_VECTOR_ENABLE : out std_logic;
    VECTOR_SUMMATION_DATA_IN_SCALAR_ENABLE : out std_logic;

    VECTOR_SUMMATION_DATA_OUT_VECTOR_ENABLE : in std_logic;
    VECTOR_SUMMATION_DATA_OUT_SCALAR_ENABLE : in std_logic;

    -- DATA
    VECTOR_SUMMATION_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_SUMMATION_SIZE_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_SUMMATION_LENGTH_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_SUMMATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_SUMMATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -----------------------------------------------------------------------
    -- STIMULUS MATRIX
    -----------------------------------------------------------------------

    -- MATRIX CONVOLUTION
    -- CONTROL
    MATRIX_CONVOLUTION_START : out std_logic;
    MATRIX_CONVOLUTION_READY : in  std_logic;

    MATRIX_CONVOLUTION_DATA_A_IN_MATRIX_ENABLE : out std_logic;
    MATRIX_CONVOLUTION_DATA_A_IN_VECTOR_ENABLE : out std_logic;
    MATRIX_CONVOLUTION_DATA_A_IN_SCALAR_ENABLE : out std_logic;
    MATRIX_CONVOLUTION_DATA_B_IN_MATRIX_ENABLE : out std_logic;
    MATRIX_CONVOLUTION_DATA_B_IN_VECTOR_ENABLE : out std_logic;
    MATRIX_CONVOLUTION_DATA_B_IN_SCALAR_ENABLE : out std_logic;

    MATRIX_CONVOLUTION_DATA_OUT_MATRIX_ENABLE : in std_logic;
    MATRIX_CONVOLUTION_DATA_OUT_VECTOR_ENABLE : in std_logic;
    MATRIX_CONVOLUTION_DATA_OUT_SCALAR_ENABLE : in std_logic;

    -- DATA
    MATRIX_CONVOLUTION_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_CONVOLUTION_SIZE_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_CONVOLUTION_SIZE_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_CONVOLUTION_LENGTH_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_CONVOLUTION_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_CONVOLUTION_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_CONVOLUTION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX COSINE SIMILARITY
    -- CONTROL
    MATRIX_COSINE_SIMILARITY_START : out std_logic;
    MATRIX_COSINE_SIMILARITY_READY : in  std_logic;

    MATRIX_COSINE_SIMILARITY_DATA_A_IN_MATRIX_ENABLE : out std_logic;
    MATRIX_COSINE_SIMILARITY_DATA_A_IN_VECTOR_ENABLE : out std_logic;
    MATRIX_COSINE_SIMILARITY_DATA_A_IN_SCALAR_ENABLE : out std_logic;
    MATRIX_COSINE_SIMILARITY_DATA_B_IN_MATRIX_ENABLE : out std_logic;
    MATRIX_COSINE_SIMILARITY_DATA_B_IN_VECTOR_ENABLE : out std_logic;
    MATRIX_COSINE_SIMILARITY_DATA_B_IN_SCALAR_ENABLE : out std_logic;

    MATRIX_COSINE_SIMILARITY_DATA_OUT_MATRIX_ENABLE : in std_logic;
    MATRIX_COSINE_SIMILARITY_DATA_OUT_VECTOR_ENABLE : in std_logic;
    MATRIX_COSINE_SIMILARITY_DATA_OUT_SCALAR_ENABLE : in std_logic;

    -- DATA
    MATRIX_COSINE_SIMILARITY_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_COSINE_SIMILARITY_SIZE_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_COSINE_SIMILARITY_SIZE_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_COSINE_SIMILARITY_LENGTH_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_COSINE_SIMILARITY_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_COSINE_SIMILARITY_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_COSINE_SIMILARITY_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX MULTIPLICATION
    -- CONTROL
    MATRIX_MULTIPLICATION_START : out std_logic;
    MATRIX_MULTIPLICATION_READY : in  std_logic;

    MATRIX_MULTIPLICATION_DATA_IN_MATRIX_ENABLE : out std_logic;
    MATRIX_MULTIPLICATION_DATA_IN_VECTOR_ENABLE : out std_logic;
    MATRIX_MULTIPLICATION_DATA_IN_SCALAR_ENABLE : out std_logic;

    MATRIX_MULTIPLICATION_DATA_OUT_MATRIX_ENABLE : in std_logic;
    MATRIX_MULTIPLICATION_DATA_OUT_VECTOR_ENABLE : in std_logic;
    MATRIX_MULTIPLICATION_DATA_OUT_SCALAR_ENABLE : in std_logic;

    -- DATA
    MATRIX_MULTIPLICATION_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_MULTIPLICATION_SIZE_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_MULTIPLICATION_SIZE_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_MULTIPLICATION_LENGTH_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_MULTIPLICATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_MULTIPLICATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX COSH
    -- CONTROL
    MATRIX_COSH_START : out std_logic;
    MATRIX_COSH_READY : in  std_logic;

    MATRIX_COSH_DATA_IN_I_ENABLE : out std_logic;
    MATRIX_COSH_DATA_IN_J_ENABLE : out std_logic;

    MATRIX_COSH_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_COSH_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_COSH_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_COSH_SIZE_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_COSH_SIZE_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_COSH_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_COSH_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX SINH
    -- CONTROL
    MATRIX_SINH_START : out std_logic;
    MATRIX_SINH_READY : in  std_logic;

    MATRIX_SINH_DATA_IN_I_ENABLE : out std_logic;
    MATRIX_SINH_DATA_IN_J_ENABLE : out std_logic;

    MATRIX_SINH_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_SINH_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_SINH_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_SINH_SIZE_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_SINH_SIZE_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_SINH_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_SINH_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX TANH
    -- CONTROL
    MATRIX_TANH_START : out std_logic;
    MATRIX_TANH_READY : in  std_logic;

    MATRIX_TANH_DATA_IN_I_ENABLE : out std_logic;
    MATRIX_TANH_DATA_IN_J_ENABLE : out std_logic;

    MATRIX_TANH_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_TANH_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_TANH_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_TANH_SIZE_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_TANH_SIZE_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_TANH_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_TANH_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX LOGISTIC
    -- CONTROL
    MATRIX_LOGISTIC_START : out std_logic;
    MATRIX_LOGISTIC_READY : in  std_logic;

    MATRIX_LOGISTIC_DATA_IN_I_ENABLE : out std_logic;
    MATRIX_LOGISTIC_DATA_IN_J_ENABLE : out std_logic;

    MATRIX_LOGISTIC_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_LOGISTIC_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_LOGISTIC_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_LOGISTIC_SIZE_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_LOGISTIC_SIZE_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_LOGISTIC_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_LOGISTIC_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX SOFTMAX
    -- CONTROL
    MATRIX_SOFTMAX_START : out std_logic;
    MATRIX_SOFTMAX_READY : in  std_logic;

    MATRIX_SOFTMAX_DATA_IN_MATRIX_ENABLE : out std_logic;
    MATRIX_SOFTMAX_DATA_IN_VECTOR_ENABLE : out std_logic;
    MATRIX_SOFTMAX_DATA_IN_SCALAR_ENABLE : out std_logic;

    MATRIX_SOFTMAX_DATA_OUT_MATRIX_ENABLE : in std_logic;
    MATRIX_SOFTMAX_DATA_OUT_VECTOR_ENABLE : in std_logic;
    MATRIX_SOFTMAX_DATA_OUT_SCALAR_ENABLE : in std_logic;

    -- DATA
    MATRIX_SOFTMAX_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_SOFTMAX_SIZE_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_SOFTMAX_SIZE_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_SOFTMAX_LENGTH_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_SOFTMAX_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_SOFTMAX_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX ONEPLUS
    -- CONTROL
    MATRIX_ONEPLUS_START : out std_logic;
    MATRIX_ONEPLUS_READY : in  std_logic;

    MATRIX_ONEPLUS_DATA_IN_I_ENABLE : out std_logic;
    MATRIX_ONEPLUS_DATA_IN_J_ENABLE : out std_logic;

    MATRIX_ONEPLUS_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_ONEPLUS_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_ONEPLUS_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_ONEPLUS_SIZE_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_ONEPLUS_SIZE_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_ONEPLUS_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_ONEPLUS_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX SUMMATION
    -- CONTROL
    MATRIX_SUMMATION_START : out std_logic;
    MATRIX_SUMMATION_READY : in  std_logic;

    MATRIX_SUMMATION_DATA_IN_MATRIX_ENABLE : out std_logic;
    MATRIX_SUMMATION_DATA_IN_VECTOR_ENABLE : out std_logic;
    MATRIX_SUMMATION_DATA_IN_SCALAR_ENABLE : out std_logic;

    MATRIX_SUMMATION_DATA_OUT_MATRIX_ENABLE : in std_logic;
    MATRIX_SUMMATION_DATA_OUT_VECTOR_ENABLE : in std_logic;
    MATRIX_SUMMATION_DATA_OUT_SCALAR_ENABLE : in std_logic;

    -- DATA
    MATRIX_SUMMATION_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_SUMMATION_SIZE_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_SUMMATION_SIZE_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_SUMMATION_LENGTH_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_SUMMATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_SUMMATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_function_stimulus_architecture of ntm_function_stimulus is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  constant PERIOD : time := 10 ns;

  constant WAITING : time := 50 ns;
  constant WORKING : time := 1 ms;

  constant ZERO  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));
  constant ONE   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, DATA_SIZE));
  constant TWO   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(2, DATA_SIZE));
  constant THREE : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(3, DATA_SIZE));

  constant EMPTY : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');
  constant FULL  : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '1');

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- LOOP
  signal index_i_loop : std_logic_vector(DATA_SIZE-1 downto 0) := ONE;
  signal index_j_loop : std_logic_vector(DATA_SIZE-1 downto 0) := ONE;

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

  -- SCALAR-FUNCTIONALITY
  SCALAR_CONVOLUTION_START       <= start_int;
  SCALAR_COSINE_SIMILARITY_START <= start_int;
  SCALAR_COSH_START              <= start_int;
  SCALAR_SINH_START              <= start_int;
  SCALAR_TANH_START              <= start_int;
  SCALAR_LOGISTIC_START          <= start_int;
  SCALAR_SOFTMAX_START           <= start_int;
  SCALAR_ONEPLUS_START           <= start_int;
  SCALAR_SUMMATION_START         <= start_int;

  -- VECTOR-FUNCTIONALITY
  VECTOR_CONVOLUTION_START       <= start_int;
  VECTOR_COSINE_SIMILARITY_START <= start_int;
  VECTOR_COSH_START              <= start_int;
  VECTOR_SINH_START              <= start_int;
  VECTOR_TANH_START              <= start_int;
  VECTOR_LOGISTIC_START          <= start_int;
  VECTOR_SOFTMAX_START           <= start_int;
  VECTOR_ONEPLUS_START           <= start_int;
  VECTOR_SUMMATION_START         <= start_int;

  -- MATRIX-FUNCTIONALITY
  MATRIX_CONVOLUTION_START       <= start_int;
  MATRIX_COSINE_SIMILARITY_START <= start_int;
  MATRIX_COSH_START              <= start_int;
  MATRIX_SINH_START              <= start_int;
  MATRIX_TANH_START              <= start_int;
  MATRIX_LOGISTIC_START          <= start_int;
  MATRIX_SOFTMAX_START           <= start_int;
  MATRIX_ONEPLUS_START           <= start_int;
  MATRIX_SUMMATION_START         <= start_int;

  -----------------------------------------------------------------------
  -- STIMULUS
  -----------------------------------------------------------------------

  main_test : process
  begin

    -------------------------------------------------------------------
    -- SCALAR-ARITHMETIC
    -------------------------------------------------------------------

    -------------------------------------------------------------------
    -- VECTOR-ARITHMETIC
    -------------------------------------------------------------------

    -------------------------------------------------------------------
    -- MATRIX-ARITHMETIC
    -------------------------------------------------------------------

    assert false
      report "END OF TEST"
      severity failure;

  end process main_test;

end architecture;
