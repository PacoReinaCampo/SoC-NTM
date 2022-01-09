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

module ntm_scalar_softmax_function #(
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

    input DATA_IN_ENABLE,
    output reg DATA_OUT_ENABLE,

    // DATA
    input [DATA_SIZE-1:0] LENGTH_IN,
    input [DATA_SIZE-1:0] DATA_IN,
    output reg [DATA_SIZE-1:0] DATA_OUT
  );

  ///////////////////////////////////////////////////////////////////////
  // Types
  ///////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////////////
  // Constants
  ///////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////////////
  // Signals
  ///////////////////////////////////////////////////////////////////////

  // SCALAR ADDER
  // CONTROL
  wire start_scalar_adder;
  wire ready_scalar_adder;

  wire operation_scalar_adder;

  // DATA
  wire [DATA_SIZE-1:0] data_a_in_scalar_adder;
  wire [DATA_SIZE-1:0] data_b_in_scalar_adder;
  wire [DATA_SIZE-1:0] data_out_scalar_adder;

  // SCALAR DIVIDER
  // CONTROL
  wire start_scalar_divider;
  wire ready_scalar_divider;

  // DATA
  wire [DATA_SIZE-1:0] data_a_in_scalar_divider;
  wire [DATA_SIZE-1:0] data_b_in_scalar_divider;
  wire [DATA_SIZE-1:0] data_out_scalar_divider;

  // SCALAR EXPONENTIATOR
  // CONTROL
  wire start_scalar_exponentiator_function;
  wire ready_scalar_exponentiator_function;

  // DATA
  wire [DATA_SIZE-1:0] data_in_scalar_exponentiator_function;
  wire [DATA_SIZE-1:0] data_out_scalar_exponentiator_function;

  ///////////////////////////////////////////////////////////////////////
  // Body
  ///////////////////////////////////////////////////////////////////////

  // SCALAR ADDER
  ntm_scalar_adder #(
    .DATA_SIZE(DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  )
  scalar_adder(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_adder),
    .READY(ready_scalar_adder),

    .OPERATION(operation_scalar_adder),

    // DATA
    .DATA_A_IN(data_a_in_scalar_adder),
    .DATA_B_IN(data_b_in_scalar_adder),
    .DATA_OUT(data_out_scalar_adder)
  );

  // SCALAR DIVIDER
  ntm_scalar_divider #(
    .DATA_SIZE(DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  )
  scalar_divider(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_divider),
    .READY(ready_scalar_divider),

    // DATA
    .DATA_A_IN(data_a_in_scalar_divider),
    .DATA_B_IN(data_b_in_scalar_divider),
    .DATA_OUT(data_out_scalar_divider)
  );

  // SCALAR EXPONENTIATOR
  ntm_scalar_exponentiator_function #(
    .DATA_SIZE(DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  )
  scalar_exponentiator_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_exponentiator_function),
    .READY(ready_scalar_exponentiator_function),

    // DATA
    .DATA_IN(data_in_scalar_exponentiator_function),
    .DATA_OUT(data_out_scalar_exponentiator_function)
  );

endmodule
