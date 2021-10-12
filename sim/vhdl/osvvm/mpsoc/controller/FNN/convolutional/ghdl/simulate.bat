@echo off
call ../../../../../../../../settings64_ghdl.bat

ghdl -a --std=08 ../../../../../../../../rtl/vhdl/pkg/ntm_math_pkg.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/pkg/ntm_fnn_controller_pkg.vhd

ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/arithmetic/scalar/ntm_scalar_mod.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/arithmetic/scalar/ntm_scalar_adder.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/arithmetic/scalar/ntm_scalar_multiplier.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/arithmetic/scalar/ntm_scalar_inverter.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/arithmetic/scalar/ntm_scalar_divider.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/arithmetic/scalar/ntm_scalar_exponentiator.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/arithmetic/scalar/ntm_scalar_root.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/arithmetic/scalar/ntm_scalar_logarithm.vhd

ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/arithmetic/vector/ntm_vector_mod.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/arithmetic/vector/ntm_vector_adder.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/arithmetic/vector/ntm_vector_multiplier.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/arithmetic/vector/ntm_vector_inverter.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/arithmetic/vector/ntm_vector_divider.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/arithmetic/vector/ntm_vector_exponentiator.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/arithmetic/vector/ntm_vector_root.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/arithmetic/vector/ntm_vector_logarithm.vhd

ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/arithmetic/matrix/ntm_matrix_mod.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/arithmetic/matrix/ntm_matrix_adder.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/arithmetic/matrix/ntm_matrix_multiplier.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/arithmetic/matrix/ntm_matrix_inverter.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/arithmetic/matrix/ntm_matrix_divider.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/arithmetic/matrix/ntm_matrix_exponentiator.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/arithmetic/matrix/ntm_matrix_root.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/arithmetic/matrix/ntm_matrix_logarithm.vhd

ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/algebra/ntm_matrix_determinant.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/algebra/ntm_matrix_inversion.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/algebra/ntm_matrix_product.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/algebra/ntm_matrix_rank.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/algebra/ntm_matrix_transpose.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/algebra/ntm_scalar_product.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/algebra/ntm_vector_product.vhd

ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/function/convolution/scalar/ntm_scalar_convolution_function.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/function/cosine/scalar/ntm_scalar_cosine_similarity_function.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/function/multiplication/scalar/ntm_scalar_multiplication_function.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/function/sigmoid/scalar/hyperbolic/ntm_scalar_cosh_function.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/function/sigmoid/scalar/hyperbolic/ntm_scalar_sinh_function.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/function/sigmoid/scalar/hyperbolic/ntm_scalar_tanh_function.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/function/sigmoid/scalar/logistic/ntm_scalar_logistic_function.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/function/sigmoid/scalar/logistic/ntm_scalar_softmax_function.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/function/sigmoid/scalar/oneplus/ntm_scalar_oneplus_function.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/function/summation/scalar/ntm_scalar_summation_function.vhd

ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/function/convolution/vector/ntm_vector_convolution_function.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/function/cosine/vector/ntm_vector_cosine_similarity_function.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/function/multiplication/vector/ntm_vector_multiplication_function.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/function/sigmoid/vector/hyperbolic/ntm_vector_cosh_function.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/function/sigmoid/vector/hyperbolic/ntm_vector_sinh_function.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/function/sigmoid/vector/hyperbolic/ntm_vector_tanh_function.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/function/sigmoid/vector/logistic/ntm_vector_logistic_function.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/function/sigmoid/vector/logistic/ntm_vector_softmax_function.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/function/sigmoid/vector/oneplus/ntm_vector_oneplus_function.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/function/summation/vector/ntm_vector_summation_function.vhd

ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/function/convolution/matrix/ntm_matrix_convolution_function.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/function/cosine/matrix/ntm_matrix_cosine_similarity_function.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/function/multiplication/matrix/ntm_matrix_multiplication_function.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/function/sigmoid/matrix/hyperbolic/ntm_matrix_cosh_function.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/function/sigmoid/matrix/hyperbolic/ntm_matrix_sinh_function.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/function/sigmoid/matrix/hyperbolic/ntm_matrix_tanh_function.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/function/sigmoid/matrix/logistic/ntm_matrix_logistic_function.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/function/sigmoid/matrix/logistic/ntm_matrix_softmax_function.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/function/sigmoid/matrix/oneplus/ntm_matrix_oneplus_function.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/math/function/summation/matrix/ntm_matrix_summation_function.vhd

ghdl -a --std=08 ../../../../../../../../rtl/vhdl/controller/FNN/convolutional/ntm_controller.vhd
ghdl -a --std=08 ../../../../../../../../rtl/vhdl/controller/FNN/standard/ntm_trainer.vhd

ghdl -a --std=08 ../../../../../../../../bench/vhdl/osvvm/controller/FNN/convolutional/ntm_convolutional_fnn_testbench.vhd

ghdl -m --std=08 ntm_convolutional_fnn_testbench
ghdl -r --std=08 ntm_convolutional_fnn_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > ntm_convolutional_fnn_testbench.tree
pause
