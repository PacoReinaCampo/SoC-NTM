////////////////////////////////////////////////////////////////////////////////
//                                            __ _      _     _               //
//                                           / _(_)    | |   | |              //
//                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |              //
//               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |              //
//              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |              //
//               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|              //
//                  | |                                                       //
//                  |_|                                                       //
//                                                                            //
//                                                                            //
//              Peripheral-NTM for MPSoC                                      //
//              Neural Turing Machine for MPSoC                               //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020-2021 by the author(s)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
////////////////////////////////////////////////////////////////////////////////
// Author(s):
//   Paco Reina Campo <pacoreinacampo@queenfield.tech>

module ntm_input_gate_vector #(
  parameter [31:0] DATA_SIZE=512
)
  (
    // GLOBAL
    input CLK,
    input RST,

    // CONTROL
    input START,
    output reg READY,

    input W_IN_L_ENABLE,  // for l in 0 to L-1
    input W_IN_X_ENABLE,  // for x in 0 to X-1
    input X_IN_ENABLE,  // for x in 0 to X-1
    input K_IN_I_ENABLE,  // for i in 0 to R-1 (read heads flow)
    input K_IN_L_ENABLE,  // for l in 0 to L-1
    input K_IN_K_ENABLE,  // for k in 0 to W-1
    input R_IN_I_ENABLE,  // for i in 0 to R-1 (read heads flow)
    input R_IN_K_ENABLE,  // for k in 0 to W-1
    input U_IN_ENABLE,  // for l in 0 to L-1 (square matrix)
    input H_IN_ENABLE,  // for l in 0 to L-1
    input B_IN_ENABLE,  // for l in 0 to L-1
    output reg I_OUT_ENABLE,  // for l in 0 to L-1

    // DATA
    input [DATA_SIZE-1:0] SIZE_X_IN,
    input [DATA_SIZE-1:0] SIZE_W_IN,
    input [DATA_SIZE-1:0] SIZE_L_IN,
    input [DATA_SIZE-1:0] SIZE_R_IN,
    input [DATA_SIZE-1:0] W_IN,
    input [DATA_SIZE-1:0] X_IN,
    input [DATA_SIZE-1:0] K_IN,
    input [DATA_SIZE-1:0] R_IN,
    input [DATA_SIZE-1:0] U_IN,
    input [DATA_SIZE-1:0] H_IN,
    input [DATA_SIZE-1:0] B_IN,
    output reg [DATA_SIZE-1:0] I_OUT
  );

  ///////////////////////////////////////////////////////////////////////
  // Types
  ///////////////////////////////////////////////////////////////////////

  parameter [2:0] STARTER_STATE = 0;
  parameter [2:0] MATRIX_CONVOLUTION_STATE = 1;
  parameter [2:0] VECTOR_ADDER_STATE = 2;
  parameter [2:0] VECTOR_LOGISTIC_STATE = 3;
  parameter [2:0] ENDER_STATE = 4;

  ///////////////////////////////////////////////////////////////////////
  // Constants
  ///////////////////////////////////////////////////////////////////////

  parameter ZERO = 0;
  parameter ONE = 1;

  ///////////////////////////////////////////////////////////////////////
  // Signals
  ///////////////////////////////////////////////////////////////////////

  // Finite State Machine
  reg [2:0] controller_ctrl_fsm_int;

  // VECTOR ADDER
  // CONTROL
  wire start_vector_adder;
  wire ready_vector_adder;

  wire operation_vector_adder;
  wire data_a_in_enable_vector_adder;
  wire data_b_in_enable_vector_adder;
  wire data_out_enable_vector_adder;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_vector_adder;
  wire [DATA_SIZE-1:0] size_in_vector_adder;
  wire [DATA_SIZE-1:0] data_a_in_vector_adder;
  wire [DATA_SIZE-1:0] data_b_in_vector_adder;
  wire [DATA_SIZE-1:0] data_out_vector_adder;

  // MATRIX CONVOLUTION
  // CONTROL
  wire start_matrix_convolution;
  wire ready_matrix_convolution;

  wire data_a_in_matrix_enable_matrix_convolution;
  wire data_a_in_vector_enable_matrix_convolution;
  wire data_a_in_scalar_enable_matrix_convolution;
  wire data_b_in_matrix_enable_matrix_convolution;
  wire data_b_in_vector_enable_matrix_convolution;
  wire data_b_in_scalar_enable_matrix_convolution;
  wire data_out_matrix_enable_matrix_convolution;
  wire data_out_vector_enable_matrix_convolution;
  wire data_out_scalar_enable_matrix_convolution;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_matrix_convolution;
  wire [DATA_SIZE-1:0] size_i_in_matrix_convolution;
  wire [DATA_SIZE-1:0] size_j_in_matrix_convolution;
  wire [DATA_SIZE-1:0] length_in_matrix_convolution;
  wire [DATA_SIZE-1:0] data_a_in_matrix_convolution;
  wire [DATA_SIZE-1:0] data_b_in_matrix_convolution;
  wire [DATA_SIZE-1:0] data_out_matrix_convolution;

  // VECTOR LOGISTIC
  // CONTROL
  wire start_vector_logistic;
  wire ready_vector_logistic;

  wire data_in_enable_vector_logistic;
  wire data_out_enable_vector_logistic;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_vector_logistic;
  wire [DATA_SIZE-1:0] size_in_vector_logistic;
  wire [DATA_SIZE-1:0] data_in_vector_logistic;
  wire data_out_vector_logistic;

  ///////////////////////////////////////////////////////////////////////
  // Body
  ///////////////////////////////////////////////////////////////////////

  // i(t;l) = sigmoid(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + U(l;l)*h(t-1;l) + U(l-1;l-1)*h(t;l-1) + b(t;l))

  // CONTROL
  always @(posedge CLK or posedge RST) begin
    if(RST == 1'b0) begin
      // Data Outputs
      I_OUT <= ZERO;

      // Control Outputs
      READY <= 1'b0;
    end
    else begin
      case(controller_ctrl_fsm_int)
        STARTER_STATE : begin  // STEP 0
          // Control Outputs
          READY <= 1'b0;

          if(START == 1'b1) begin
            // FSM Control
            controller_ctrl_fsm_int <= MATRIX_CONVOLUTION_STATE;
          end
        end

        MATRIX_CONVOLUTION_STATE : begin  // STEP 1
        end

        VECTOR_ADDER_STATE : begin  // STEP 2
        end

        VECTOR_LOGISTIC_STATE : begin  // STEP 3
        end

        ENDER_STATE : begin  // STEP 4
        end

        default : begin
          // FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
        end
      endcase
    end
  end

  // VECTOR ADDER
  ntm_vector_adder #(
    .DATA_SIZE(DATA_SIZE)
  )
  vector_adder(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_adder),
    .READY(ready_vector_adder),

    .OPERATION(operation_vector_adder),

    .DATA_A_IN_ENABLE(data_a_in_enable_vector_adder),
    .DATA_B_IN_ENABLE(data_b_in_enable_vector_adder),
    .DATA_OUT_ENABLE(data_out_enable_vector_adder),

    // DATA
    .MODULO_IN(modulo_in_vector_adder),
    .SIZE_IN(size_in_vector_adder),
    .DATA_A_IN(data_a_in_vector_adder),
    .DATA_B_IN(data_b_in_vector_adder),
    .DATA_OUT(data_out_vector_adder)
  );

  // MATRIX CONVOLUTION
  ntm_matrix_convolution_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  matrix_convolution_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_convolution),
    .READY(ready_matrix_convolution),

    .DATA_A_IN_MATRIX_ENABLE(data_a_in_matrix_enable_matrix_convolution),
    .DATA_A_IN_VECTOR_ENABLE(data_a_in_vector_enable_matrix_convolution),
    .DATA_A_IN_SCALAR_ENABLE(data_a_in_scalar_enable_matrix_convolution),
    .DATA_B_IN_MATRIX_ENABLE(data_b_in_matrix_enable_matrix_convolution),
    .DATA_B_IN_VECTOR_ENABLE(data_b_in_vector_enable_matrix_convolution),
    .DATA_B_IN_SCALAR_ENABLE(data_b_in_scalar_enable_matrix_convolution),
    .DATA_OUT_MATRIX_ENABLE(data_out_matrix_enable_matrix_convolution),
    .DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_matrix_convolution),
    .DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_matrix_convolution),

    // DATA
    .MODULO_IN(modulo_in_matrix_convolution),
    .SIZE_I_IN(size_i_in_matrix_convolution),
    .SIZE_J_IN(size_j_in_matrix_convolution),
    .LENGTH_IN(length_in_matrix_convolution),
    .DATA_A_IN(data_a_in_matrix_convolution),
    .DATA_B_IN(data_b_in_matrix_convolution),
    .DATA_OUT(data_out_matrix_convolution)
  );

  // VECTOR LOGISTIC
  ntm_vector_logistic_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  vector_logistic_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_logistic),
    .READY(ready_vector_logistic),

    .DATA_IN_ENABLE(data_in_enable_vector_logistic),
    .DATA_OUT_ENABLE(data_out_enable_vector_logistic),

    // DATA
    .MODULO_IN(modulo_in_vector_logistic),
    .SIZE_IN(size_in_vector_logistic),
    .DATA_IN(data_in_vector_logistic),
    .DATA_OUT(data_out_vector_logistic)
  );

endmodule
