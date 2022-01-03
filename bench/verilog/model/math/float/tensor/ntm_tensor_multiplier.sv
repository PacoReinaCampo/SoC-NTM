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

module ntm_matrix_multiplier #(
  parameter DATA_SIZE=128,
  parameter CONTROL_SIZE=64
)
  (
    // GLOBAL
    input CLK,
    input RST,

    // CONTROL
    input START,
    output reg READY,

    input DATA_A_IN_I_ENABLE,
    input DATA_A_IN_J_ENABLE,
    input DATA_A_IN_K_ENABLE,
    input DATA_B_IN_I_ENABLE,
    input DATA_B_IN_J_ENABLE,
    input DATA_B_IN_K_ENABLE,

    output reg DATA_OUT_I_ENABLE,
    output reg DATA_OUT_J_ENABLE,
    output reg DATA_OUT_K_ENABLE,

    // DATA
    input [DATA_SIZE-1:0] SIZE_A_I_IN,
    input [DATA_SIZE-1:0] SIZE_A_J_IN,
    input [DATA_SIZE-1:0] SIZE_A_K_IN,
    input [DATA_SIZE-1:0] SIZE_B_I_IN,
    input [DATA_SIZE-1:0] SIZE_B_J_IN,
    input [DATA_SIZE-1:0] SIZE_B_K_IN,
    input [DATA_SIZE-1:0] DATA_A_IN,
    input [DATA_SIZE-1:0] DATA_B_IN,

    output reg [DATA_SIZE-1:0] DATA_OUT
  );

  ///////////////////////////////////////////////////////////////////////
  // Types
  ///////////////////////////////////////////////////////////////////////

  parameter [1:0] STARTER_STATE = 0;
  parameter [1:0] INPUT_I_STATE = 1;
  parameter [1:0] INPUT_J_STATE = 2;
  parameter [1:0] ENDER_STATE = 3;

  ///////////////////////////////////////////////////////////////////////
  // Constants
  ///////////////////////////////////////////////////////////////////////

  parameter ZERO_CONTROL  = 0;
  parameter ONE_CONTROL   = 1;
  parameter TWO_CONTROL   = 2;
  parameter THREE_CONTROL = 3;

  parameter ZERO_DATA  = 0;
  parameter ONE_DATA   = 1;
  parameter TWO_DATA   = 2;
  parameter THREE_DATA = 3;

  parameter FULL  = 1;
  parameter EMPTY = 0;

  parameter EULER = 0;

  ///////////////////////////////////////////////////////////////////////
  // Signals
  ///////////////////////////////////////////////////////////////////////

  // Finite State Machine
  reg [1:0] multiplier_ctrl_fsm_int;

  // Internal Signals
  reg [CONTROL_SIZE-1:0] index_i_loop;
  reg [CONTROL_SIZE-1:0] index_j_loop;

  reg data_a_in_i_multiplier_int;
  reg data_a_in_j_multiplier_int;
  reg data_b_in_i_multiplier_int;
  reg data_b_in_j_multiplier_int;

  // MULTIPLIER
  // CONTROL
  reg start_vector_multiplier;
  wire ready_vector_multiplier;
  reg data_a_in_enable_vector_multiplier;
  reg data_b_in_enable_vector_multiplier;
  wire data_out_enable_vector_multiplier;

  // DATA
  reg [DATA_SIZE-1:0] size_in_vector_multiplier;
  reg [DATA_SIZE-1:0] data_a_in_vector_multiplier;
  reg [DATA_SIZE-1:0] data_b_in_vector_multiplier;
  wire [DATA_SIZE-1:0] data_out_vector_multiplier;

  ///////////////////////////////////////////////////////////////////////
  // Body
  ///////////////////////////////////////////////////////////////////////

  // DATA_OUT = DATA_A_IN · DATA_B_IN = M_A_IN · M_B_IN · 2^(E_A_IN + E_B_IN)

  // CONTROL
  always @(posedge CLK or posedge RST) begin
    if(RST == 1'b0) begin
      // Data Outputs
      DATA_OUT <= ZERO_DATA;

      // Control Outputs
      READY <= 1'b0;

      // Assignations
      index_i_loop <= ZERO_DATA;
      index_j_loop <= ZERO_DATA;

      data_a_in_i_multiplier_int <= 1'b0;
      data_a_in_j_multiplier_int <= 1'b0;
      data_b_in_i_multiplier_int <= 1'b0;
      data_b_in_j_multiplier_int <= 1'b0;
    end
	else begin
      case(multiplier_ctrl_fsm_int)
        STARTER_STATE : begin  // STEP 0
          // Control Outputs
          READY <= 1'b0;

          if(START == 1'b1) begin
            // Assignations
            index_i_loop <= ZERO_DATA;
            index_j_loop <= ZERO_DATA;

            // FSM Control
            multiplier_ctrl_fsm_int <= INPUT_I_STATE;
          end
        end
        INPUT_I_STATE : begin  // STEP 1
          if(DATA_A_IN_I_ENABLE == 1'b1) begin
            // Data Inputs
            data_a_in_vector_multiplier <= DATA_A_IN;

            // Control Internal
            data_a_in_enable_vector_multiplier <= 1'b1;
            data_a_in_i_multiplier_int <= 1'b1;
          end
          else begin
            // Control Internal
            data_a_in_enable_vector_multiplier <= 1'b0;
          end
          if(DATA_B_IN_I_ENABLE == 1'b1) begin
            // Data Inputs
            data_b_in_vector_multiplier <= DATA_B_IN;

            // Control Internal
            data_b_in_enable_vector_multiplier <= 1'b1;
            data_b_in_i_multiplier_int <= 1'b1;
          end
          else begin
            // Control Internal
            data_b_in_enable_vector_multiplier <= 1'b0;
          end
          if(data_a_in_i_multiplier_int == 1'b1 && data_b_in_i_multiplier_int == 1'b1) begin
            if(index_i_loop == ZERO_DATA) begin
              // Control Internal
              start_vector_multiplier <= 1'b1;
            end
            // Data Inputs

            // FSM Control
            multiplier_ctrl_fsm_int <= ENDER_STATE;
          end
          // Control Outputs
          DATA_OUT_I_ENABLE <= 1'b0;
          DATA_OUT_J_ENABLE <= 1'b0;
        end
        INPUT_J_STATE : begin  // STEP 2
          if(DATA_A_IN_J_ENABLE == 1'b1) begin
            // Data Inputs
            data_a_in_vector_multiplier <= DATA_A_IN;

            // Control Internal
            data_a_in_enable_vector_multiplier <= 1'b1;
            data_a_in_j_multiplier_int <= 1'b1;
          end
          else begin
            // Control Internal
            data_a_in_enable_vector_multiplier <= 1'b0;
          end
          if(DATA_B_IN_J_ENABLE == 1'b1) begin
            // Data Inputs
            data_b_in_vector_multiplier <= DATA_B_IN;

            // Control Internal
            data_b_in_enable_vector_multiplier <= 1'b1;
            data_b_in_j_multiplier_int <= 1'b1;
          end
          else begin
            // Control Internal
            data_b_in_enable_vector_multiplier <= 1'b0;
          end
          if((data_a_in_j_multiplier_int == 1'b1 && data_b_in_j_multiplier_int == 1'b1)) begin
            if(index_j_loop == ZERO_DATA) begin
              // Control Internal
              start_vector_multiplier <= 1'b1;
            end
            // Data Inputs
            size_in_vector_multiplier <= SIZE_J_IN;

            // FSM Control
            multiplier_ctrl_fsm_int <= ENDER_STATE;
          end
          // Control Outputs
          DATA_OUT_J_ENABLE <= 1'b0;
        end
        ENDER_STATE : begin  // STEP 3
          if((ready_vector_multiplier == 1'b1)) begin
            if((index_i_loop == (SIZE_I_IN - ONE_CONTROL)) && (index_j_loop == (SIZE_J_IN - ONE_CONTROL))) begin
              // Control Outputs
              READY <= 1'b1;
              DATA_OUT_J_ENABLE <= 1'b1;

              // FSM Control
              multiplier_ctrl_fsm_int <= STARTER_STATE;
            end
            else if((index_i_loop < (SIZE_I_IN - ONE_CONTROL)) && (index_j_loop == (SIZE_J_IN - ONE_CONTROL))) begin
              // Control Internal
              index_i_loop <= (index_i_loop + ONE_CONTROL);
              index_j_loop <= ZERO_DATA;

              // Control Outputs
              DATA_OUT_I_ENABLE <= 1'b1;
              DATA_OUT_J_ENABLE <= 1'b1;

              // FSM Control
              multiplier_ctrl_fsm_int <= INPUT_I_STATE;
            end
            else if((index_i_loop < (SIZE_I_IN - ONE_CONTROL)) && (index_j_loop < (SIZE_J_IN - ONE_CONTROL))) begin
              // Control Internal
              index_j_loop <= (index_j_loop + ONE_CONTROL);

              // Control Outputs
              DATA_OUT_J_ENABLE <= 1'b1;

              // FSM Control
              multiplier_ctrl_fsm_int <= INPUT_J_STATE;
            end
            // Data Outputs
            DATA_OUT <= data_out_vector_multiplier;
          end
          else begin
            // Control Internal
            start_vector_multiplier <= 1'b0;

            data_a_in_i_multiplier_int <= 1'b0;
            data_a_in_j_multiplier_int <= 1'b0;
            data_b_in_i_multiplier_int <= 1'b0;
            data_b_in_j_multiplier_int <= 1'b0;
          end
        end
        default : begin
          // FSM Control
          multiplier_ctrl_fsm_int <= STARTER_STATE;
        end
      endcase
    end
  end

  // MULTIPLIER
  ntm_vector_multiplier #(
    .DATA_SIZE(DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  )
  vector_multiplier(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_multiplier),
    .READY(ready_vector_multiplier),

    .DATA_A_IN_ENABLE(data_a_in_enable_vector_multiplier),
    .DATA_B_IN_ENABLE(data_b_in_enable_vector_multiplier),
    .DATA_OUT_ENABLE(data_out_enable_vector_multiplier),

    // DATA
    .SIZE_IN(size_in_vector_multiplier),
    .DATA_A_IN(data_a_in_vector_multiplier),
    .DATA_B_IN(data_b_in_vector_multiplier),
    .DATA_OUT(data_out_vector_multiplier)
  );

endmodule
