#*******************
# DESIGN COMPILATION
#*******************

do variables.do

vlib work

##################################################################################################
# accelerator_scalar_integer_adder_design_compilation
##################################################################################################

alias accelerator_scalar_integer_adder_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/scalar/accelerator_scalar_integer_adder.sv
}

##################################################################################################
# accelerator_scalar_integer_multiplier_design_compilation
##################################################################################################

alias accelerator_scalar_integer_multiplier_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/scalar/accelerator_scalar_integer_multiplier.sv
}

##################################################################################################
# accelerator_scalar_integer_divider_design_compilation
##################################################################################################

alias accelerator_scalar_integer_divider_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/scalar/accelerator_scalar_integer_divider.sv
}

##################################################################################################
# accelerator_vector_integer_adder_design_compilation
##################################################################################################

alias accelerator_vector_integer_adder_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/scalar/accelerator_scalar_integer_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/vector/accelerator_vector_integer_adder.sv
}

##################################################################################################
# accelerator_vector_integer_multiplier_design_compilation
##################################################################################################

alias accelerator_vector_integer_multiplier_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/scalar/accelerator_scalar_integer_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/vector/accelerator_vector_integer_multiplier.sv
}

##################################################################################################
# accelerator_vector_integer_divider_design_compilation
##################################################################################################

alias accelerator_vector_integer_divider_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/scalar/accelerator_scalar_integer_divider.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/vector/accelerator_vector_integer_divider.sv
}

##################################################################################################
# accelerator_matrix_integer_adder_design_compilation
##################################################################################################

alias accelerator_matrix_integer_adder_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/scalar/accelerator_scalar_integer_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/matrix/accelerator_matrix_integer_adder.sv
}

##################################################################################################
# accelerator_matrix_integer_multiplier_design_compilation
##################################################################################################

alias accelerator_matrix_integer_multiplier_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/scalar/accelerator_scalar_integer_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/matrix/accelerator_matrix_integer_multiplier.sv
}

##################################################################################################
# accelerator_matrix_integer_divider_design_compilation
##################################################################################################

alias accelerator_matrix_integer_divider_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/scalar/accelerator_scalar_integer_divider.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/matrix/accelerator_matrix_integer_divider.sv
}

##################################################################################################
# accelerator_tensor_integer_adder_design_compilation
##################################################################################################

alias accelerator_tensor_integer_adder_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/scalar/accelerator_scalar_integer_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/tensor/accelerator_tensor_integer_adder.sv
}

##################################################################################################
# accelerator_tensor_integer_multiplier_design_compilation
##################################################################################################

alias accelerator_tensor_integer_multiplier_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/scalar/accelerator_scalar_integer_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/tensor/accelerator_tensor_integer_multiplier.sv
}

##################################################################################################
# accelerator_tensor_integer_divider_design_compilation
##################################################################################################

alias accelerator_tensor_integer_divider_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/scalar/accelerator_scalar_integer_divider.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/tensor/accelerator_tensor_integer_divider.sv
}

##################################################################################################

alias d01 {
  accelerator_scalar_integer_adder_design_compilation
}

alias d02 {
  accelerator_scalar_integer_multiplier_design_compilation
}

alias d03 {
  accelerator_scalar_integer_divider_design_compilation
}

alias d04 {
  accelerator_vector_integer_adder_design_compilation
}

alias d05 {
  accelerator_vector_integer_multiplier_design_compilation
}

alias d06 {
  accelerator_vector_integer_divider_design_compilation
}

alias d07 {
  accelerator_matrix_integer_adder_design_compilation
}

alias d08 {
  accelerator_matrix_integer_multiplier_design_compilation
}

alias d09 {
  accelerator_matrix_integer_divider_design_compilation
}

alias d10 {
  accelerator_tensor_integer_adder_design_compilation
}

alias d11 {
  accelerator_tensor_integer_multiplier_design_compilation
}

alias d12 {
  accelerator_tensor_integer_divider_design_compilation
}

echo "****************************************"
echo "d01 . ACCELERATOR-SCALAR-ADDER-TEST"
echo "d02 . ACCELERATOR-SCALAR-MULTIPLIER-TEST"
echo "d03 . ACCELERATOR-SCALAR-DIVIDER-TEST"
echo "d04 . ACCELERATOR-VECTOR-ADDER-TEST"
echo "d05 . ACCELERATOR-VECTOR-MULTIPLIER-TEST"
echo "d06 . ACCELERATOR-VECTOR-DIVIDER-TEST"
echo "d07 . ACCELERATOR-MATRIX-ADDER-TEST"
echo "d08 . ACCELERATOR-MATRIX-MULTIPLIER-TEST"
echo "d09 . ACCELERATOR-MATRIX-DIVIDER-TEST"
echo "d10 . ACCELERATOR-TENSOR-ADDER-TEST"
echo "d11 . ACCELERATOR-TENSOR-MULTIPLIER-TEST"
echo "d12 . ACCELERATOR-TENSOR-DIVIDER-TEST"
echo "****************************************"
