onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /accelerator_algebra_pkg/MONITOR_TEST
add wave -noupdate /accelerator_algebra_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM TENSOR MATRIX CONVOLUTION TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/CLK
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/RST
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/START
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/SIZE_A_I_IN
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/SIZE_A_J_IN
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/SIZE_A_K_IN
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/SIZE_B_I_IN
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/SIZE_B_J_IN
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/DATA_A_IN_I_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/DATA_A_IN_J_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/DATA_A_IN_K_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/DATA_A_IN
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/DATA_B_IN_I_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/DATA_B_IN_J_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/DATA_B_IN
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/DATA_I_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/DATA_J_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/DATA_K_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/READY
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/DATA_OUT_I_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/DATA_OUT_J_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/DATA_OUT

add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/convolution_ctrl_fsm_int

add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/index_i_loop
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/index_j_loop
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/index_k_loop
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/index_m_loop
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/index_n_loop
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/index_p_loop

add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/data_a_in_i_convolution_int
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/data_a_in_j_convolution_int
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/data_a_in_k_convolution_int
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/data_b_in_i_convolution_int
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/data_b_in_j_convolution_int

add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/start_scalar_float_adder
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/operation_scalar_float_adder
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/data_a_in_scalar_float_adder
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/data_b_in_scalar_float_adder
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/ready_scalar_float_adder
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/data_out_scalar_float_adder
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/overflow_out_scalar_float_adder

add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/start_scalar_float_multiplier
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/data_a_in_scalar_float_multiplier
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/data_b_in_scalar_float_multiplier
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/ready_scalar_float_multiplier
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/data_out_scalar_float_multiplier
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_matrix_convolution_test/tensor_matrix_convolution/overflow_out_scalar_float_multiplier

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1042309203 ps} 0} {{Cursor 2} {7446987402 ps} 0}
configure wave -namecolwidth 305
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {1134027470 ps} {1150214364 ps}