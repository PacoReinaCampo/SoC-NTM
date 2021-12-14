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

module ntm_scalar_adder #(
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

    input OPERATION,

    // DATA
    input [DATA_SIZE-1:0] MODULO_IN,
    input [DATA_SIZE-1:0] DATA_A_IN,
    input [DATA_SIZE-1:0] DATA_B_IN,
    output reg [DATA_SIZE-1:0] DATA_OUT
  );

  ///////////////////////////////////////////////////////////////////////
  // Types
  ///////////////////////////////////////////////////////////////////////

  parameter STARTER_STATE = 0;
  parameter ENDER_STATE = 1;

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
  reg adder_ctrl_fsm_int;

  // Internal Signals
  reg [DATA_SIZE:0] adder_int;

  ///////////////////////////////////////////////////////////////////////
  // Body
  ///////////////////////////////////////////////////////////////////////

  // DATA_OUT = DATA_A_IN ± DATA_B_IN = M_A_IN · 2^(E_A_IN) ± M_B_IN · 2^(E_B_IN)

  // CONTROL
  always @(posedge CLK or posedge RST) begin
    if(RST == 1'b0) begin
      // Data Outputs
      DATA_OUT <= ZERO_DATA;

      // Control Outputs
      READY <= 1'b0;

      // Assignations
      adder_int <= ZERO_DATA;
    end else begin
      case(adder_ctrl_fsm_int)
        STARTER_STATE : begin  // STEP 0
          // Control Outputs
          READY <= 1'b0;

          if(START == 1'b1) begin
            // Assignations
            if(OPERATION == 1'b1) begin
              if(DATA_A_IN > DATA_B_IN) begin
                adder_int <= ({1'b0,DATA_A_IN} - {1'b0,DATA_B_IN});
              end
              else begin
                adder_int <= ({1'b0,DATA_B_IN} - {1'b0,DATA_A_IN});
              end
            end
            else begin
              adder_int <= ({1'b0,DATA_A_IN} + ({1'b0,DATA_B_IN}));
            end

            // FSM Control
            adder_ctrl_fsm_int <= ENDER_STATE;
          end
        end
        ENDER_STATE : begin  // STEP 1
          if(MODULO_IN > ZERO_DATA) begin
            if(DATA_A_IN > DATA_B_IN) begin
              if(adder_int == {1'b0,MODULO_IN}) begin
                // Data Outputs
                DATA_OUT <= ZERO_DATA;

                // Control Outputs
                READY <= 1'b1;
                // FSM Control
                adder_ctrl_fsm_int <= STARTER_STATE;
              end
              else if(adder_int < {1'b0,MODULO_IN}) begin
                // Data Outputs
                DATA_OUT <= adder_int[DATA_SIZE-1:0];

                // Control Outputs
                READY <= 1'b1;

                // FSM Control
                adder_ctrl_fsm_int <= STARTER_STATE;
              end
              else begin
                // Assignations
                adder_int <= (adder_int - {1'b0,MODULO_IN});
              end
            end
            else if(DATA_A_IN == DATA_B_IN) begin
              if(OPERATION == 1'b1) begin
                // Data Outputs
                DATA_OUT <= ZERO_DATA;

                // Control Outputs
                READY <= 1'b1;

                // FSM Control
                adder_ctrl_fsm_int <= STARTER_STATE;
              end
              else begin
                if(adder_int == {1'b0,MODULO_IN}) begin
                  // Data Outputs
                  DATA_OUT <= ZERO_DATA;

                  // Control Outputs
                  READY <= 1'b1;

                  // FSM Control
                  adder_ctrl_fsm_int <= STARTER_STATE;
                end
                else if(adder_int < {1'b0,MODULO_IN}) begin
                  // Data Outputs
                  DATA_OUT <= adder_int[DATA_SIZE-1:0];

                  // Control Outputs
                  READY <= 1'b1;

                  // FSM Control
                  adder_ctrl_fsm_int <= STARTER_STATE;
                end
                else begin
                  // Assignations
                  adder_int <= (adder_int - {1'b0,MODULO_IN});
                end
              end
            end
            else if(DATA_A_IN < DATA_B_IN) begin
              if(OPERATION == 1'b1) begin
                if(adder_int == {1'b0,MODULO_IN}) begin
                  // Data Outputs
                  DATA_OUT <= ZERO_DATA;

                  // Control Outputs
                  READY <= 1'b1;

                  // FSM Control
                  adder_ctrl_fsm_int <= STARTER_STATE;
                end
                else if(adder_int < {1'b0,MODULO_IN}) begin
                  // Data Outputs
                  DATA_OUT <= (MODULO_IN - adder_int[DATA_SIZE-1:0]);

                  // Control Outputs
                  READY <= 1'b1;

                  // FSM Control
                  adder_ctrl_fsm_int <= STARTER_STATE;
                end
                else begin
                  // Assignations
                  adder_int <= (adder_int - {1'b0,MODULO_IN});
                end
              end
              else begin
                if(adder_int == {1'b0,MODULO_IN}) begin
                  // Data Outputs
                  DATA_OUT <= ZERO_DATA;

                  // Control Outputs
                  READY <= 1'b1;

                  // FSM Control
                  adder_ctrl_fsm_int <= STARTER_STATE;
                end
                else if(adder_int < {1'b0,MODULO_IN}) begin
                  // Data Outputs
                  DATA_OUT <= adder_int[DATA_SIZE-1:0];

                  // Control Outputs
                  READY <= 1'b1;

                  // FSM Control
                  adder_ctrl_fsm_int <= STARTER_STATE;
                end
                else begin
                  // Assignations
                  adder_int <= (adder_int - {1'b0,MODULO_IN});
                end
              end
            end
          end
          else if(MODULO_IN == ZERO_DATA) begin
            // Data Outputs
            DATA_OUT <= adder_int[DATA_SIZE-1:0];

            // Control Outputs
            READY <= 1'b1;

            // FSM Control
            adder_ctrl_fsm_int <= STARTER_STATE;
          end
        end
        default : begin
          // FSM Control
          adder_ctrl_fsm_int <= STARTER_STATE;
        end
      endcase
    end
  end

endmodule