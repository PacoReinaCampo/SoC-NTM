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

module dnc_top #(
  parameter DATA_SIZE=512
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

    input K_IN_I_ENABLE,  // for i in 0 to R-1 (read heads flow)
    input K_IN_L_ENABLE,  // for l in 0 to L-1
    input K_IN_K_ENABLE,  // for k in 0 to W-1

    input U_IN_L_ENABLE,  // for l in 0 to L-1
    input U_IN_P_ENABLE,  // for p in 0 to L-1

    input B_IN_ENABLE,  // for l in 0 to L-1

    input X_IN_ENABLE,  // for x in 0 to X-1
    output reg Y_OUT_ENABLE,  // for y in 0 to Y-1

    // DATA
    input [DATA_SIZE-1:0] SIZE_X_IN,
    input [DATA_SIZE-1:0] SIZE_Y_IN,
    input [DATA_SIZE-1:0] SIZE_N_IN,
    input [DATA_SIZE-1:0] SIZE_W_IN,
    input [DATA_SIZE-1:0] SIZE_L_IN,
    input [DATA_SIZE-1:0] SIZE_R_IN,

    input [DATA_SIZE-1:0] W_IN,
    input [DATA_SIZE-1:0] K_IN,
    input [DATA_SIZE-1:0] U_IN,
    input [DATA_SIZE-1:0] B_IN,

    input [DATA_SIZE-1:0] X_IN,
    output reg [DATA_SIZE-1:0] Y_OUT
  );

  ///////////////////////////////////////////////////////////////////////
  // Types
  ///////////////////////////////////////////////////////////////////////

  parameter [2:0] STARTER_STATE = 0;
  parameter [2:0] CONTROLLER_STATE = 1;
  parameter [2:0] READ_HEADS_STATE = 2;
  parameter [2:0] WRITE_HEADS_STATE = 3;
  parameter [2:0] MEMORY_I_STATE = 4;
  parameter [2:0] MEMORY_J_STATE = 5;

  parameter [2:0] STARTER_CONTROLLER_STATE = 0;
  parameter [2:0] CONTROLLER_BODY_STATE = 1;
  parameter [2:0] OUTPUT_VECTOR_STATE = 2;

  parameter [3:0] STARTER_READ_HEADS_STATE = 0;
  parameter [3:0] FREE_GATES_STATE = 1;
  parameter [3:0] READ_KEYS_STATE = 2;
  parameter [3:0] READ_MODES_STATE = 3;
  parameter [3:0] READ_STRENGTHS_STATE = 4;
  parameter [3:0] READ_INTERFACE_VECTOR_STATE = 5;

  parameter [3:0] STARTER_WRITE_HEADS_STATE = 0;
  parameter [3:0] ALLOCATION_GATE_STATE = 1;
  parameter [3:0] ERASE_VECTOR_STATE = 2;
  parameter [3:0] WRITE_GATE_STATE = 3;
  parameter [3:0] WRITE_KEY_STATE = 4;
  parameter [3:0] WRITE_STRENGTH_STATE = 5;
  parameter [3:0] WRITE_VECTOR_STATE = 6;
  parameter [3:0] WRITE_INTERFACE_VECTOR_STATE = 7;

  ///////////////////////////////////////////////////////////////////////
  // Constants
  ///////////////////////////////////////////////////////////////////////

  parameter ZERO = 0;
  parameter ONE = 1;
  parameter FULL = 1;

  ///////////////////////////////////////////////////////////////////////
  // Signals
  ///////////////////////////////////////////////////////////////////////

  // Finite State Machine
  reg [2:0] top_ctrl_fsm_int;

  reg [2:0] controller_ctrl_fsm_int;
  reg [3:0] read_heads_ctrl_fsm_int;
  reg [3:0] write_heads_ctrl_fsm_int;

  // Control Internal
  reg [DATA_SIZE-1:0] index_i_loop;
  reg [DATA_SIZE-1:0] index_j_loop;

  ///////////////////////////////////////////////////////////////////////
  // CONTROLLER
  ///////////////////////////////////////////////////////////////////////

  // CONTROLLER
  // CONTROL
  wire start_controller;
  wire ready_controller;

  wire w_in_l_enable_controller;
  wire w_in_x_enable_controller;

  wire k_in_i_enable_controller;
  wire k_in_l_enable_controller;
  wire k_in_k_enable_controller;

  wire u_in_l_enable_controller;
  wire u_in_p_enable_controller;

  wire b_in_enable_controller;

  wire x_in_enable_controller;

  wire x_out_enable_controller;

  wire r_in_i_enable_controller;
  wire r_in_k_enable_controller;

  wire r_out_i_enable_controller;
  wire r_out_k_enable_controller;

  wire h_in_enable_controller;

  wire w_out_l_enable_controller;
  wire w_out_x_enable_controller;

  wire k_out_i_enable_controller;
  wire k_out_l_enable_controller;
  wire k_out_k_enable_controller;

  wire u_out_l_enable_controller;
  wire u_out_p_enable_controller;

  wire b_out_enable_controller;

  wire h_out_enable_controller;

  // DATA
  wire [DATA_SIZE-1:0] size_x_in_controller;
  wire [DATA_SIZE-1:0] size_w_in_controller;
  wire [DATA_SIZE-1:0] size_l_in_controller;
  wire [DATA_SIZE-1:0] size_r_in_controller;

  wire [DATA_SIZE-1:0] w_in_controller;
  wire [DATA_SIZE-1:0] k_in_controller;
  wire [DATA_SIZE-1:0] u_in_controller;
  wire [DATA_SIZE-1:0] b_in_controller;

  wire [DATA_SIZE-1:0] x_in_controller;
  wire [DATA_SIZE-1:0] r_in_controller;
  wire [DATA_SIZE-1:0] h_in_controller;

  wire [DATA_SIZE-1:0] w_out_controller;
  wire [DATA_SIZE-1:0] k_out_controller;
  wire [DATA_SIZE-1:0] u_out_controller;
  wire [DATA_SIZE-1:0] b_out_controller;

  wire [DATA_SIZE-1:0] h_out_controller;

  // OUTPUT VECTOR
  // CONTROL
  wire start_output_vector;
  wire ready_output_vector;

  wire k_in_i_enable_output_vector;
  wire k_in_y_enable_output_vector;
  wire k_in_k_enable_output_vector;

  wire k_out_i_enable_output_vector;
  wire k_out_y_enable_output_vector;
  wire k_out_k_enable_output_vector;

  wire r_in_i_enable_output_vector;
  wire r_in_k_enable_output_vector;

  wire r_out_i_enable_output_vector;
  wire r_out_k_enable_output_vector;

  wire u_in_y_enable_output_vector;
  wire u_in_l_enable_output_vector;

  wire u_out_y_enable_output_vector;
  wire u_out_l_enable_output_vector;

  wire h_in_enable_output_vector;

  wire h_out_enable_output_vector;

  wire y_out_enable_output_vector;

  // DATA
  wire [DATA_SIZE-1:0] size_y_in_output_vector;
  wire [DATA_SIZE-1:0] size_l_in_output_vector;
  wire [DATA_SIZE-1:0] size_w_in_output_vector;
  wire [DATA_SIZE-1:0] size_r_in_output_vector;

  wire [DATA_SIZE-1:0] k_in_output_vector;
  wire [DATA_SIZE-1:0] r_in_output_vector;

  wire [DATA_SIZE-1:0] u_in_output_vector;
  wire [DATA_SIZE-1:0] h_in_output_vector;

  wire [DATA_SIZE-1:0] y_out_output_vector;

  ///////////////////////////////////////////////////////////////////////
  // READ HEADS
  ///////////////////////////////////////////////////////////////////////

  // FREE GATES
  // CONTROL
  wire start_free_gates;
  wire ready_free_gates;

  wire f_in_enable_free_gates;
  wire f_out_enable_free_gates;

  // DATA
  wire [DATA_SIZE-1:0] size_r_in_free_gates;
  wire [DATA_SIZE-1:0] f_in_free_gates;
  wire [DATA_SIZE-1:0] f_out_free_gates;

  // READ KEYS
  // CONTROL
  wire k_in_i_enable_read_keys;
  wire k_in_k_enable_read_keys;
  wire k_out_i_enable_read_keys;
  wire k_out_k_enable_read_keys;

  wire start_read_keys;
  wire ready_read_keys;

  // DATA
  wire [DATA_SIZE-1:0] size_r_in_read_keys;
  wire [DATA_SIZE-1:0] size_w_in_read_keys;
  wire [DATA_SIZE-1:0] k_in_read_keys;
  wire [DATA_SIZE-1:0] k_out_read_keys;

  // READ MODES
  // CONTROL
  wire start_read_modes;
  wire ready_read_modes;

  wire pi_in_i_enable_read_modes;
  wire pi_in_p_enable_read_modes;
  wire pi_out_i_enable_read_modes;
  wire pi_out_p_enable_read_modes;

  // DATA
  wire [DATA_SIZE-1:0] size_r_in_read_modes;
  wire [DATA_SIZE-1:0] pi_in_read_modes;
  wire [DATA_SIZE-1:0] pi_out_read_modes;

  // READ STRENGTHS
  // CONTROL
  wire beta_in_enable_read_strengths;
  wire beta_out_enable_read_strengths;

  wire start_read_strengths;
  wire ready_read_strengths;

  // DATA
  wire [DATA_SIZE-1:0] size_r_in_read_strengths;
  wire [DATA_SIZE-1:0] beta_in_read_strengths;
  wire [DATA_SIZE-1:0] beta_out_read_strengths;

  // READ INTERFACE VECTOR
  // CONTROL
  wire start_read_interface_vector;
  wire ready_read_interface_vector;

  // Read Key
  wire wk_in_i_enable_read_interface_vector;
  wire wk_in_l_enable_read_interface_vector;
  wire wk_in_k_enable_read_interface_vector;
  wire k_out_i_enable_read_interface_vector;
  wire k_out_k_enable_read_interface_vector;

  // Read Strength
  wire wbeta_in_i_enable_read_interface_vector;
  wire wbeta_in_l_enable_read_interface_vector;
  wire beta_out_enable_read_interface_vector;

  // Free Gate
  wire wf_in_i_enable_read_interface_vector;
  wire wf_in_l_enable_read_interface_vector;
  wire f_out_enable_read_interface_vector;

  // Read Mode
  wire wpi_in_i_enable_read_interface_vector;
  wire wpi_in_l_enable_read_interface_vector;
  wire pi_out_enable_read_interface_vector;

  // Hidden State
  wire h_in_enable_read_interface_vector;

  // DATA
  wire [DATA_SIZE-1:0] size_w_in_read_interface_vector;
  wire [DATA_SIZE-1:0] size_l_in_read_interface_vector;
  wire [DATA_SIZE-1:0] size_r_in_read_interface_vector;
  wire [DATA_SIZE-1:0] wk_in_read_interface_vector;
  wire [DATA_SIZE-1:0] wbeta_in_read_interface_vector;
  wire [DATA_SIZE-1:0] wf_in_read_interface_vector;
  wire [DATA_SIZE-1:0] wpi_in_read_interface_vector;
  wire [DATA_SIZE-1:0] h_in_read_interface_vector;
  wire [DATA_SIZE-1:0] k_out_read_interface_vector;
  wire [DATA_SIZE-1:0] beta_out_read_interface_vector;
  wire [DATA_SIZE-1:0] f_out_read_interface_vector;
  wire [DATA_SIZE-1:0] pi_out_read_interface_vector;

  ///////////////////////////////////////////////////////////////////////
  // WRITE HEADS
  ///////////////////////////////////////////////////////////////////////

  // ALLOCATION GATE
  // CONTROL
  wire start_allocation_gate;
  wire ready_allocation_gate;

  // DATA
  wire [DATA_SIZE-1:0] ga_in_allocation_gate;
  wire [DATA_SIZE-1:0] ga_out_allocation_gate;

  // ERASE VECTOR
  // CONTROL
  wire start_erase_vector;
  wire ready_erase_vector;

  wire e_in_enable_erase_vector;
  wire e_out_enable_erase_vector;

  // DATA
  wire [DATA_SIZE-1:0] size_w_in_erase_vector;
  wire [DATA_SIZE-1:0] e_in_erase_vector;
  wire [DATA_SIZE-1:0] e_out_erase_vector;

  // WRITE GATE
  // CONTROL
  wire start_write_gate;
  wire ready_write_gate;

  // DATA
  wire [DATA_SIZE-1:0] gw_in_write_gate;
  wire [DATA_SIZE-1:0] gw_out_write_gate;

  // WRITE KEY
  // CONTROL
  wire start_write_key;
  wire ready_write_key;

  wire k_in_enable_write_key;
  wire k_out_enable_write_key;

  // DATA
  wire [DATA_SIZE-1:0] size_w_in_write_key;
  wire [DATA_SIZE-1:0] k_in_write_key;
  wire [DATA_SIZE-1:0] k_out_write_key;

  // WRITE STRENGHT
  // CONTROL
  wire start_write_strength;
  wire ready_write_strength;

  // DATA
  wire [DATA_SIZE-1:0] beta_in_write_strength;
  wire [DATA_SIZE-1:0] beta_out_write_strength;

  // WRITE VECTOR
  // CONTROL
  wire start_write_vector;
  wire ready_write_vector;

  wire v_in_enable_write_vector;
  wire v_out_enable_write_vector;

  // DATA
  wire [DATA_SIZE-1:0] size_w_in_write_vector;
  wire [DATA_SIZE-1:0] v_in_write_vector;
  wire [DATA_SIZE-1:0] v_out_write_vector;

  // WRITE INTERFACE VECTOR
  // CONTROL
  wire start_write_interface_vector;
  wire ready_write_interface_vector;

  // Write Key
  wire wk_in_l_enable_write_interface_vector;
  wire wk_in_k_enable_write_interface_vector;
  wire k_out_enable_write_interface_vector;

  // Write Strength
  wire wbeta_in_enable_write_interface_vector;

  // Erase Vector
  wire we_in_l_enable_write_interface_vector;
  wire we_in_k_enable_write_interface_vector;
  wire e_out_enable_write_interface_vector;

  // Write Vector
  wire wv_in_l_enable_write_interface_vector;
  wire wv_in_k_enable_write_interface_vector;
  wire v_out_enable_write_interface_vector;

  // Allocation Gate
  wire wga_in_enable_write_interface_vector;

  // Write Gate
  wire wgw_in_enable_write_interface_vector;

  // Hidden State
  wire h_in_enable_write_interface_vector;

  // DATA
  wire [DATA_SIZE-1:0] size_w_in_write_interface_vector;
  wire [DATA_SIZE-1:0] size_l_in_write_interface_vector;
  wire [DATA_SIZE-1:0] size_r_in_write_interface_vector;
  wire [DATA_SIZE-1:0] wk_in_write_interface_vector;
  wire [DATA_SIZE-1:0] wbeta_in_write_interface_vector;
  wire [DATA_SIZE-1:0] we_in_write_interface_vector;
  wire [DATA_SIZE-1:0] wv_in_write_interface_vector;
  wire [DATA_SIZE-1:0] wga_in_write_interface_vector;
  wire [DATA_SIZE-1:0] wgw_in_write_interface_vector;
  wire [DATA_SIZE-1:0] h_in_write_interface_vector;
  wire [DATA_SIZE-1:0] k_out_write_interface_vector;
  wire [DATA_SIZE-1:0] beta_out_write_interface_vector;
  wire [DATA_SIZE-1:0] e_out_write_interface_vector;
  wire [DATA_SIZE-1:0] v_out_write_interface_vector;
  wire [DATA_SIZE-1:0] ga_out_write_interface_vector;
  wire [DATA_SIZE-1:0] gw_out_write_interface_vector;

  ///////////////////////////////////////////////////////////////////////
  // MEMORY
  ///////////////////////////////////////////////////////////////////////

  // ADDRESSING
  // CONTROL
  wire start_addressing;
  wire ready_addressing;

  wire k_read_in_i_enable_addressing;
  wire k_read_in_k_enable_addressing;
  wire beta_read_in_enable_addressing;
  wire f_read_in_enable_addressing;
  wire pi_read_in_enable_addressing;
  wire k_write_in_k_enable_addressing;
  wire e_write_in_k_enable_addressing;
  wire v_write_in_k_enable_addressing;
  wire r_out_i_enable_addressing;
  wire r_out_k_enable_addressing;

  // DATA
  wire [DATA_SIZE-1:0] size_r_in_addressing;
  wire [DATA_SIZE-1:0] size_w_in_addressing;
  wire [DATA_SIZE-1:0] k_read_in_addressing;
  wire [DATA_SIZE-1:0] beta_read_in_addressing;
  wire [DATA_SIZE-1:0] f_read_in_addressing;
  wire [DATA_SIZE-1:0] pi_read_in_addressing;
  wire [DATA_SIZE-1:0] k_write_in_addressing;
  wire [DATA_SIZE-1:0] beta_write_in_addressing;
  wire [DATA_SIZE-1:0] e_write_in_addressing;
  wire [DATA_SIZE-1:0] v_write_in_addressing;
  wire [DATA_SIZE-1:0] ga_write_in_addressing;
  wire [DATA_SIZE-1:0] gw_write_in_addressing;
  wire [DATA_SIZE-1:0] r_out_addressing;

  ///////////////////////////////////////////////////////////////////////
  // Body
  ///////////////////////////////////////////////////////////////////////

  // CONTROL
  always @(posedge CLK or posedge RST) begin
    if(RST == 1'b0) begin
      // Data Outputs
      Y_OUT <= ZERO;

      // Control Outputs
      READY <= 1'b0;
    end
    else begin
      case(top_ctrl_fsm_int)
        STARTER_STATE : begin  // STEP 0
          // Control Outputs
          READY <= 1'b0;

          if(START == 1'b1) begin
            // FSM Control
            top_ctrl_fsm_int <= CONTROLLER_STATE;
          end
        end

        CONTROLLER_STATE : begin  // STEP 1
        
          case(controller_ctrl_fsm_int)
            STARTER_CONTROLLER_STATE : begin  // STEP 0
            end

            CONTROLLER_BODY_STATE : begin  // STEP 1
            end

            OUTPUT_VECTOR_STATE : begin  // STEP 2
            end
            default : begin
              // FSM Control
              controller_ctrl_fsm_int <= STARTER_CONTROLLER_STATE;
            end
          endcase
        end

        READ_HEADS_STATE : begin  // STEP 2
        
          case(read_heads_ctrl_fsm_int)
            STARTER_READ_HEADS_STATE : begin  // STEP 0
            end

            FREE_GATES_STATE : begin  // STEP 1
            end

            READ_KEYS_STATE : begin  // STEP 2
            end

            READ_MODES_STATE : begin  // STEP 3
            end

            READ_STRENGTHS_STATE : begin  // STEP 4
            end

            READ_INTERFACE_VECTOR_STATE : begin  // STEP 5
            end
            default : begin
              // FSM Control
              read_heads_ctrl_fsm_int <= STARTER_READ_HEADS_STATE;
            end
          endcase
        end

        WRITE_HEADS_STATE : begin  // STEP 3
        
          case(write_heads_ctrl_fsm_int)
            STARTER_WRITE_HEADS_STATE : begin  // STEP 0
            end

            ALLOCATION_GATE_STATE : begin  // STEP 1
            end

            ERASE_VECTOR_STATE : begin  // STEP 2
            end

            WRITE_GATE_STATE : begin  // STEP 3
            end

            WRITE_KEY_STATE : begin  // STEP 4
            end

            WRITE_STRENGTH_STATE : begin  // STEP 5
            end

            WRITE_VECTOR_STATE : begin  // STEP 5
            end

            WRITE_INTERFACE_VECTOR_STATE : begin  // STEP 5
            end
            default : begin
              // FSM Control
              write_heads_ctrl_fsm_int <= STARTER_WRITE_HEADS_STATE;
            end
          endcase
        end

        MEMORY_I_STATE : begin  // STEP 4
        
          if (index_i_loop == SIZE_R_IN - ONE) begin
            // FSM Control
            top_ctrl_fsm_int <= STARTER_STATE;
          end
        end

        MEMORY_J_STATE : begin  // STEP 5
        
          if (index_j_loop == SIZE_R_IN - ONE) begin
            // FSM Control
            top_ctrl_fsm_int <= STARTER_STATE;
          end
        end
        default : begin
          // FSM Control
          top_ctrl_fsm_int <= STARTER_STATE;
        end
      endcase
    end
  end

  ///////////////////////////////////////////////////////////////////////
  // CONTROLLER
  ///////////////////////////////////////////////////////////////////////

  // CONTROLLER
  ntm_controller #(
    .DATA_SIZE(DATA_SIZE)
  )
  ntm_controller_i(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_controller),
    .READY(ready_controller),

    .W_IN_L_ENABLE(w_in_l_enable_controller),
    .W_IN_X_ENABLE(w_in_x_enable_controller),

    .K_IN_I_ENABLE(k_in_i_enable_controller),
    .K_IN_L_ENABLE(k_in_l_enable_controller),
    .K_IN_K_ENABLE(k_in_k_enable_controller),

    .U_IN_L_ENABLE(u_in_l_enable_controller),
    .U_IN_P_ENABLE(u_in_p_enable_controller),

    .B_IN_ENABLE(b_in_enable_controller),

    .X_IN_ENABLE(x_in_enable_controller),

    .X_OUT_ENABLE(x_out_enable_controller),

    .R_IN_I_ENABLE(r_in_i_enable_controller),
    .R_IN_K_ENABLE(r_in_k_enable_controller),

    .R_OUT_I_ENABLE(r_out_i_enable_controller),
    .R_OUT_K_ENABLE(r_out_k_enable_controller),

    .H_IN_ENABLE(h_in_enable_controller),

    .W_OUT_L_ENABLE(w_out_l_enable_controller),
    .W_OUT_X_ENABLE(w_out_x_enable_controller),

    .K_OUT_I_ENABLE(k_out_i_enable_controller),
    .K_OUT_L_ENABLE(k_out_l_enable_controller),
    .K_OUT_K_ENABLE(k_out_k_enable_controller),

    .U_OUT_L_ENABLE(u_out_l_enable_controller),
    .U_OUT_P_ENABLE(u_out_p_enable_controller),

    .B_OUT_ENABLE(b_out_enable_controller),

    .H_OUT_ENABLE(h_out_enable_controller),

    // DATA
    .SIZE_X_IN(size_x_in_controller),
    .SIZE_W_IN(size_w_in_controller),
    .SIZE_L_IN(size_l_in_controller),
    .SIZE_R_IN(size_r_in_controller),
    
    .W_IN(w_in_controller),
    .K_IN(k_in_controller),
    .U_IN(u_in_controller),
    .B_IN(b_in_controller),
    
    .X_IN(x_in_controller),
    .R_IN(r_in_controller),
    .H_IN(h_in_controller),
    
    .W_OUT(w_out_controller),
    .K_OUT(k_out_controller),
    .U_OUT(u_out_controller),
    .B_OUT(b_out_controller),
    
    .H_OUT(h_out_controller)
  );

  // OUTPUT VECTOR
  dnc_output_vector #(
    .DATA_SIZE(DATA_SIZE)
  )
  output_vector_i(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_output_vector),
    .READY(ready_output_vector),

    .K_IN_I_ENABLE(k_in_i_enable_output_vector),
    .K_IN_Y_ENABLE(k_in_y_enable_output_vector),
    .K_IN_K_ENABLE(k_in_k_enable_output_vector),

    .K_OUT_I_ENABLE(k_out_i_enable_output_vector),
    .K_OUT_Y_ENABLE(k_out_y_enable_output_vector),
    .K_OUT_K_ENABLE(k_out_k_enable_output_vector),

    .R_IN_I_ENABLE(r_in_i_enable_output_vector),
    .R_IN_K_ENABLE(r_in_k_enable_output_vector),

    .R_OUT_I_ENABLE(r_out_i_enable_output_vector),
    .R_OUT_K_ENABLE(r_out_k_enable_output_vector),

    .U_IN_Y_ENABLE(u_in_y_enable_output_vector),
    .U_IN_L_ENABLE(u_in_l_enable_output_vector),

    .U_OUT_Y_ENABLE(u_out_y_enable_output_vector),
    .U_OUT_L_ENABLE(u_out_l_enable_output_vector),

    .H_IN_ENABLE(h_in_enable_output_vector),

    .H_OUT_ENABLE(h_out_enable_output_vector),

    .Y_OUT_ENABLE(y_out_enable_output_vector),

    // DATA
    .SIZE_Y_IN(size_y_in_output_vector),
    .SIZE_L_IN(size_l_in_output_vector),
    .SIZE_W_IN(size_w_in_output_vector),
    .SIZE_R_IN(size_r_in_output_vector),

    .K_IN(k_in_output_vector),
    .R_IN(r_in_output_vector),

    .U_IN(u_in_output_vector),
    .H_IN(h_in_output_vector),

    .Y_OUT(y_out_output_vector)
  );

  ///////////////////////////////////////////////////////////////////////
  // READ HEADS
  ///////////////////////////////////////////////////////////////////////

  // FREE GATES
  dnc_free_gates #(
    .DATA_SIZE(DATA_SIZE)
  )
  free_gates(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_free_gates),
    .READY(ready_free_gates),

    .F_IN_ENABLE(f_in_enable_free_gates),
    .F_OUT_ENABLE(f_out_enable_free_gates),

    // DATA
    .SIZE_R_IN(size_r_in_free_gates),
    .F_IN(f_in_free_gates),
    .F_OUT(f_out_free_gates)
  );

  // READ KEYS
  dnc_read_keys #(
    .DATA_SIZE(DATA_SIZE)
  )
  read_keys(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_read_keys),
    .READY(ready_read_keys),

    .K_IN_I_ENABLE(k_in_i_enable_read_keys),
    .K_IN_K_ENABLE(k_in_k_enable_read_keys),
    .K_OUT_I_ENABLE(k_out_i_enable_read_keys),
    .K_OUT_K_ENABLE(k_out_k_enable_read_keys),

    // DATA
    .SIZE_R_IN(size_r_in_read_keys),
    .SIZE_W_IN(size_w_in_read_keys),
    .K_IN(k_in_read_keys),
    .K_OUT(k_out_read_keys)
  );

  // READ MODES
  dnc_read_modes #(
    .DATA_SIZE(DATA_SIZE)
  )
  read_modes(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_read_modes),
    .READY(ready_read_modes),

    .PI_IN_I_ENABLE(pi_in_i_enable_read_modes),
    .PI_IN_P_ENABLE(pi_in_p_enable_read_modes),
    .PI_OUT_I_ENABLE(pi_out_i_enable_read_modes),
    .PI_OUT_P_ENABLE(pi_out_p_enable_read_modes),

    // DATA
    .SIZE_R_IN(size_r_in_free_gates),
    .PI_IN(pi_in_read_modes),
    .PI_OUT(pi_out_read_modes)
  );

  // READ STRENGTHS
  dnc_read_strengths #(
    .DATA_SIZE(DATA_SIZE)
  )
  read_strengths(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_read_strengths),
    .READY(ready_read_strengths),

    .BETA_IN_ENABLE(beta_in_enable_read_strengths),
    .BETA_OUT_ENABLE(beta_out_enable_read_strengths),

    // DATA
    .SIZE_R_IN(size_r_in_free_gates),
    .BETA_IN(beta_in_read_strengths),
    .BETA_OUT(beta_out_read_strengths)
  );

  // READ INTERFACE VECTOR
  dnc_read_interface_vector #(
    .DATA_SIZE(DATA_SIZE)
  )
  read_interface_vector(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_read_interface_vector),
    .READY(ready_read_interface_vector),

    // Read Key
    .WK_IN_I_ENABLE(wk_in_i_enable_read_interface_vector),
    .WK_IN_L_ENABLE(wk_in_l_enable_read_interface_vector),
    .WK_IN_K_ENABLE(wk_in_k_enable_read_interface_vector),
    .K_OUT_I_ENABLE(k_out_i_enable_read_interface_vector),
    .K_OUT_K_ENABLE(k_out_k_enable_read_interface_vector),

    // Read Strength
    .WBETA_IN_I_ENABLE(wbeta_in_i_enable_read_interface_vector),
    .WBETA_IN_L_ENABLE(wbeta_in_l_enable_read_interface_vector),
    .BETA_OUT_ENABLE(beta_out_enable_read_interface_vector),

    // Free Gate
    .WF_IN_I_ENABLE(wf_in_i_enable_read_interface_vector),
    .WF_IN_L_ENABLE(wf_in_l_enable_read_interface_vector),
    .F_OUT_ENABLE(f_out_enable_read_interface_vector),

    // Read Mode
    .WPI_IN_I_ENABLE(wpi_in_i_enable_read_interface_vector),
    .WPI_IN_L_ENABLE(wpi_in_l_enable_read_interface_vector),
    .PI_OUT_ENABLE(pi_out_enable_read_interface_vector),

    // Hidden State
    .H_IN_ENABLE(h_in_enable_read_interface_vector),

    // DATA
    .SIZE_W_IN(size_w_in_read_interface_vector),
    .SIZE_L_IN(size_l_in_read_interface_vector),
    .SIZE_R_IN(size_r_in_read_interface_vector),
    .WK_IN(wk_in_read_interface_vector),
    .WBETA_IN(wbeta_in_read_interface_vector),
    .WF_IN(wf_in_read_interface_vector),
    .WPI_IN(wpi_in_read_interface_vector),
    .H_IN(h_in_read_interface_vector),
    .K_OUT(k_out_read_interface_vector),
    .BETA_OUT(beta_out_read_interface_vector),
    .F_OUT(f_out_read_interface_vector),
    .PI_OUT(pi_out_read_interface_vector)
  );

  ///////////////////////////////////////////////////////////////////////
  // WRITE HEADS
  ///////////////////////////////////////////////////////////////////////

  // ALLOCATION GATE
  dnc_allocation_gate #(
    .DATA_SIZE(DATA_SIZE)
  )
  allocation_gate(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_allocation_gate),
    .READY(ready_allocation_gate),

    // DATA
    .GA_IN(ga_in_allocation_gate),
    .GA_OUT(ga_out_allocation_gate)
  );

  // ERASE VECTOR
  dnc_erase_vector #(
    .DATA_SIZE(DATA_SIZE)
  )
  erase_vector(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_erase_vector),
    .READY(ready_erase_vector),

    .E_IN_ENABLE(e_in_enable_erase_vector),
    .E_OUT_ENABLE(e_out_enable_erase_vector),

    // DATA
    .SIZE_W_IN(size_w_in_erase_vector),
    .E_IN(e_in_erase_vector),
    .E_OUT(e_out_erase_vector)
  );

  // WRITE GATE
  dnc_write_gate #(
    .DATA_SIZE(DATA_SIZE)
  )
  write_gate(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_write_gate),
    .READY(ready_write_gate),

    // DATA
    .GW_IN(gw_in_write_gate),
    .GW_OUT(gw_out_write_gate)
  );

  // WRITE KEY
  dnc_write_key #(
    .DATA_SIZE(DATA_SIZE)
  )
  write_key(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_write_key),
    .READY(ready_write_key),

    .K_IN_ENABLE(k_in_enable_write_key),
    .K_OUT_ENABLE(k_out_enable_write_key),

    // DATA
    .SIZE_W_IN(size_w_in_write_key),
    .K_IN(k_in_write_key),
    .K_OUT(k_out_write_key)
  );

  // WRITE STRENGTH
  dnc_write_strength #(
    .DATA_SIZE(DATA_SIZE)
  )
  write_strength(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_write_strength),
    .READY(ready_write_strength),

    // DATA
    .BETA_IN(beta_in_write_strength),
    .BETA_OUT(beta_out_write_strength)
  );

  // WRITE VECTOR
  dnc_write_vector #(
    .DATA_SIZE(DATA_SIZE)
  )
  write_vector(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_write_vector),
    .READY(ready_write_vector),

    .V_IN_ENABLE(v_in_enable_write_vector),
    .V_OUT_ENABLE(v_out_enable_write_vector),

    // DATA
    .SIZE_W_IN(size_w_in_write_vector),
    .V_IN(v_in_write_vector),
    .V_OUT(v_out_write_vector)
  );

  // WRITE INTERFACE VECTOR
  dnc_write_interface_vector #(
    .DATA_SIZE(DATA_SIZE)
  )
  write_interface_vector(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_write_interface_vector),
    .READY(ready_write_interface_vector),

    // Write Key
    .WK_IN_L_ENABLE(wk_in_l_enable_write_interface_vector),
    .WK_IN_K_ENABLE(wk_in_k_enable_write_interface_vector),
    .K_OUT_ENABLE(k_out_enable_write_interface_vector),

    // Write Strength
    .WBETA_IN_ENABLE(wbeta_in_enable_write_interface_vector),

    // Erase Vector
    .WE_IN_L_ENABLE(we_in_l_enable_write_interface_vector),
    .WE_IN_K_ENABLE(we_in_k_enable_write_interface_vector),
    .E_OUT_ENABLE(e_out_enable_write_interface_vector),

    // Write Vector
    .WV_IN_L_ENABLE(wv_in_l_enable_write_interface_vector),
    .WV_IN_K_ENABLE(wv_in_k_enable_write_interface_vector),
    .V_OUT_ENABLE(v_out_enable_write_interface_vector),

    // Allocation Gate
    .WGA_IN_ENABLE(wga_in_enable_write_interface_vector),

    // Write Gate
    .WGW_IN_ENABLE(wgw_in_enable_write_interface_vector),

    // Hidden State
    .H_IN_ENABLE(h_in_enable_write_interface_vector),

    // DATA
    .SIZE_W_IN(size_w_in_write_interface_vector),
    .SIZE_L_IN(size_l_in_write_interface_vector),
    .SIZE_R_IN(size_r_in_write_interface_vector),
    .WK_IN(wk_in_write_interface_vector),
    .WBETA_IN(wbeta_in_write_interface_vector),
    .WE_IN(we_in_write_interface_vector),
    .WV_IN(wv_in_write_interface_vector),
    .WGA_IN(wga_in_write_interface_vector),
    .WGW_IN(wgw_in_write_interface_vector),
    .H_IN(h_in_write_interface_vector),
    .K_OUT(k_out_write_interface_vector),
    .BETA_OUT(beta_out_write_interface_vector),
    .E_OUT(e_out_write_interface_vector),
    .V_OUT(v_out_write_interface_vector),
    .GA_OUT(ga_out_write_interface_vector),
    .GW_OUT(gw_out_write_interface_vector)
  );

  ///////////////////////////////////////////////////////////////////////
  // MEMORY
  ///////////////////////////////////////////////////////////////////////

  // ADDRESSING
  dnc_addressing #(
    .DATA_SIZE(DATA_SIZE)
  )
  addressing(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_addressing),
    .READY(ready_addressing),

    .K_READ_IN_I_ENABLE(k_read_in_i_enable_addressing),
    .K_READ_IN_K_ENABLE(k_read_in_k_enable_addressing),
    .BETA_READ_IN_ENABLE(beta_read_in_enable_addressing),
    .F_READ_IN_ENABLE(f_read_in_enable_addressing),
    .PI_READ_IN_ENABLE(pi_read_in_enable_addressing),
    .K_WRITE_IN_K_ENABLE(k_write_in_k_enable_addressing),
    .E_WRITE_IN_K_ENABLE(e_write_in_k_enable_addressing),
    .V_WRITE_IN_K_ENABLE(v_write_in_k_enable_addressing),
    .R_OUT_I_ENABLE(r_out_i_enable_addressing),
    .R_OUT_K_ENABLE(r_out_k_enable_addressing),

    // DATA
    .SIZE_R_IN(size_r_in_addressing),
    .SIZE_W_IN(size_w_in_addressing),
    .K_READ_IN(k_read_in_addressing),
    .BETA_READ_IN(beta_read_in_addressing),
    .F_READ_IN(f_read_in_addressing),
    .PI_READ_IN(pi_read_in_addressing),
    .K_WRITE_IN(k_write_in_addressing),
    .BETA_WRITE_IN(beta_write_in_addressing),
    .E_WRITE_IN(e_write_in_addressing),
    .V_WRITE_IN(v_write_in_addressing),
    .GA_WRITE_IN(ga_write_in_addressing),
    .GW_WRITE_IN(gw_write_in_addressing),
    .R_OUT(r_out_addressing)
  );

endmodule
