@echo off
call ../../../../../../../settings64_ghdl.bat

ghdl -a --std=08 ../../../../../../../model/vhdl/pkg/model_arithmetic_pkg.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/pkg/model_math_pkg.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/scalar/model_scalar_float_adder.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/scalar/model_scalar_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/scalar/model_scalar_float_divider.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/vector/model_vector_float_adder.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/vector/model_vector_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/vector/model_vector_float_divider.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/matrix/model_matrix_float_adder.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/matrix/model_matrix_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/matrix/model_matrix_float_divider.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/math/series/scalar/model_scalar_cosh_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/series/scalar/model_scalar_exponentiator_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/series/scalar/model_scalar_logarithm_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/series/scalar/model_scalar_power_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/series/scalar/model_scalar_sinh_function.vhdd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/series/scalar/model_scalar_sqrt_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/series/scalar/model_scalar_tanh_function.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/math/series/vector/model_vector_cosh_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/series/vector/model_vector_exponentiator_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/series/vector/model_vector_logarithm_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/series/vector/model_vector_power_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/series/vector/model_vector_sinh_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/series/vector/model_vector_sqrt_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/series/vector/model_vector_tanh_function.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/math/series/matrix/model_matrix_cosh_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/series/matrix/model_matrix_exponentiator_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/series/matrix/model_matrix_logarithm_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/series/matrix/model_matrix_power_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/series/matrix/model_matrix_sinh_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/series/matrix/model_matrix_sqrt_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/series/matrix/model_matrix_tanh_function.vhd

ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/math/series/model_series_pkg.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/math/series/model_series_stimulus.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/math/series/model_series_testbench.vhd
ghdl -m --std=08 model_series_testbench
ghdl -r --std=08 model_series_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > model_series_testbench.tree
pause
