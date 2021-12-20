onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /ntm_modular_pkg/MONITOR_TEST
add wave -noupdate /ntm_modular_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM TENSOR EXPONENTIATOR TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/CLK
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/RST
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/START
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/MODULO_IN
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/SIZE_I_IN
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/SIZE_J_IN
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/SIZE_K_IN
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/DATA_A_IN_I_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/DATA_A_IN_J_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/DATA_A_IN_K_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/DATA_A_IN
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/DATA_B_IN_I_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/DATA_B_IN_J_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/DATA_B_IN_K_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/DATA_B_IN
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/READY
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/DATA_OUT_I_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/index_i_loop
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/DATA_OUT_J_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/index_j_loop
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/DATA_OUT_K_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/index_k_loop
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/DATA_OUT

add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/exponentiator_ctrl_fsm_int

add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/start_matrix_modular_exponentiator
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/modulo_in_matrix_modular_exponentiator
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/size_i_in_matrix_modular_exponentiator
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/size_j_in_matrix_modular_exponentiator
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/data_a_in_i_modular_exponentiator_int
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/data_a_in_j_modular_exponentiator_int
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/data_a_in_k_modular_exponentiator_int
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/data_a_in_i_enable_matrix_modular_exponentiator
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/data_a_in_j_enable_matrix_modular_exponentiator
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/data_a_in_matrix_modular_exponentiator
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/data_b_in_i_modular_exponentiator_int
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/data_b_in_j_modular_exponentiator_int
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/data_b_in_k_modular_exponentiator_int
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/data_b_in_i_enable_matrix_modular_exponentiator
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/data_b_in_j_enable_matrix_modular_exponentiator
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/data_b_in_matrix_modular_exponentiator
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/ready_matrix_modular_exponentiator
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/data_out_i_enable_matrix_modular_exponentiator
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/data_out_j_enable_matrix_modular_exponentiator
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_exponentiator_test/tensor_modular_exponentiator/data_out_matrix_modular_exponentiator

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