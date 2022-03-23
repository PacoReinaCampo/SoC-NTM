%{
###################################################################################
##                                            __ _      _     _                  ##
##                                           / _(_)    | |   | |                 ##
##                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |                 ##
##               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |                 ##
##              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |                 ##
##               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|                 ##
##                  | |                                                          ##
##                  |_|                                                          ##
##                                                                               ##
##                                                                               ##
##              Peripheral-NTM for MPSoC                                         ##
##              Neural Turing Machine for MPSoC                                  ##
##                                                                               ##
###################################################################################

###################################################################################
##                                                                               ##
## Copyright (c) 2020-2024 by the author(s)                                      ##
##                                                                               ##
## Permission is hereby granted, free of charge, to any person obtaining a copy  ##
## of this software and associated documentation files (the "Software"), to deal ##
## in the Software without restriction, including without limitation the rights  ##
## to use, copy, modify, merge, publish, distribute, sublicense, and/or sell     ##
## copies of the Software, and to permit persons to whom the Software is         ##
## furnished to do so, subject to the following conditions:                      ##
##                                                                               ##
## The above copyright notice and this permission notice shall be included in    ##
## all copies or substantial portions of the Software.                           ##
##                                                                               ##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    ##
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,      ##
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE   ##
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER        ##
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, ##
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN     ##
## THE SOFTWARE.                                                                 ##
##                                                                               ##
## ============================================================================= ##
## Author(s):                                                                    ##
##   Paco Reina Campo <pacoreinacampo@queenfield.tech>                           ##
##                                                                               ##
###################################################################################
%}


function DATA_Y_OUT = ntm_state_vector_output(DATA_K_IN, DATA_A_IN, DATA_B_IN, DATA_C_IN, DATA_D_IN, DATA_U_IN, INITIAL_X, k)
  addpath(genpath('../feedback'));

  % y(k) = C�exp(A,k)�x(0) + summation(C�exp(A,k-j)�B�u(j))[j in 0 to k-1] + D�u(k)
  DATA_A_OUT = ntm_state_matrix_state(DATA_K_IN, DATA_A_IN, DATA_B_IN, DATA_C_IN, DATA_D_IN);
  DATA_B_OUT = ntm_state_matrix_input(DATA_K_IN, DATA_B_IN, DATA_D_IN);
  DATA_C_OUT = ntm_state_matrix_output(DATA_K_IN, DATA_C_IN, DATA_D_IN);
  DATA_D_OUT = ntm_state_matrix_feedforward(DATA_K_IN, DATA_D_IN);

  DATA_Y_OUT = DATA_C_OUT*(DATA_A_OUT^k)*INITIAL_X;

  for j = 1:k
    DATA_Y_OUT = DATA_Y_OUT + DATA_C_OUT*(DATA_A_OUT^(k-j))*DATA_B_OUT*DATA_U_IN(:, k);
  end

  DATA_Y_OUT = DATA_Y_OUT + DATA_D_OUT*DATA_U_IN(:, k);
end