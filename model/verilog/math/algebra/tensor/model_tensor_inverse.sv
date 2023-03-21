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

module model_tensor_inverse #(
  parameter DATA_SIZE    = 64,
  parameter CONTROL_SIZE = 64
) (
  // GLOBAL
  input CLK,
  input RST,

  // CONTROL
  input      START,
  output reg READY,

  input DATA_A_IN_ENABLE,
  input DATA_B_IN_ENABLE,

  output reg DATA_OUT_ENABLE,

  // DATA
  input      [DATA_SIZE-1:0] LENGTH_IN,
  input      [DATA_SIZE-1:0] DATA_A_IN,
  input      [DATA_SIZE-1:0] DATA_B_IN,
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

  // SCALAR MULTIPLIER
  // CONTROL
  wire                 start_scalar_float_multiplier;
  wire                 ready_scalar_float_multiplier;

  // DATA
  wire [DATA_SIZE-1:0] data_a_in_scalar_float_multiplier;
  wire [DATA_SIZE-1:0] data_b_in_scalar_float_multiplier;
  wire [DATA_SIZE-1:0] data_out_scalar_float_multiplier;

  // SCALAR DIVIDER
  // CONTROL
  wire                 start_scalar_float_divider;
  wire                 ready_scalar_float_divider;

  // DATA
  wire [DATA_SIZE-1:0] data_a_in_scalar_float_divider;
  wire [DATA_SIZE-1:0] data_b_in_scalar_float_divider;
  wire [DATA_SIZE-1:0] data_out_scalar_float_divider;

  // SCALAR PRODUCT
  // CONTROL
  wire                 start_scalar_product;
  wire                 ready_scalar_product;

  wire                 data_a_in_enable_scalar_product;
  wire                 data_b_in_enable_scalar_product;
  wire                 data_out_enable_scalar_product;

  // DATA
  wire [DATA_SIZE-1:0] length_in_scalar_product;
  wire [DATA_SIZE-1:0] data_a_in_scalar_product;
  wire [DATA_SIZE-1:0] data_b_in_scalar_product;
  wire [DATA_SIZE-1:0] data_out_scalar_product;

  ///////////////////////////////////////////////////////////////////////
  // Body
  ///////////////////////////////////////////////////////////////////////

  // SCALAR MULTIPLIER
  model_scalar_float_multiplier #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) scalar_float_multiplier (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_float_multiplier),
    .READY(ready_scalar_float_adder),

    // DATA
    .DATA_A_IN(data_a_in_scalar_float_multiplier),
    .DATA_B_IN(data_b_in_scalar_float_multiplier),
    .DATA_OUT (data_out_scalar_float_multiplier)
  );

  // SCALAR DIVIDER
  model_scalar_float_divider #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) scalar_float_divider (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_float_divider),
    .READY(ready_scalar_float_divider),

    // DATA
    .DATA_A_IN(data_a_in_scalar_float_divider),
    .DATA_B_IN(data_b_in_scalar_float_divider),
    .DATA_OUT (data_out_scalar_float_divider)
  );

  // SCALAR PRODUCT
  model_scalar_product #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) scalar_product (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_product),
    .READY(ready_scalar_product),

    .DATA_A_IN_ENABLE(data_a_in_enable_scalar_product),
    .DATA_B_IN_ENABLE(data_b_in_enable_scalar_product),
    .DATA_OUT_ENABLE (data_out_enable_scalar_product),

    // DATA
    .LENGTH_IN(length_in_scalar_product),
    .DATA_A_IN(data_a_in_scalar_product),
    .DATA_B_IN(data_b_in_scalar_product),
    .DATA_OUT (data_out_scalar_product)
  );

endmodule
