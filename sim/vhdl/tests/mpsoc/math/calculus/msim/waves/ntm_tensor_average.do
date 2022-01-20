onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /ntm_calculus_pkg/MONITOR_TEST
add wave -noupdate /ntm_calculus_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM TENSOR AVERAGE TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/CLK
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/RST
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/START
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/SIZE_A_I_IN
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/SIZE_A_J_IN
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/SIZE_A_K_IN
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/SIZE_B_I_IN
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/SIZE_B_J_IN
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/SIZE_B_K_IN
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/DATA_A_IN_I_ENABLE
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/DATA_A_IN_J_ENABLE
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/DATA_A_IN_K_ENABLE
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/DATA_A_IN
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/DATA_B_IN_I_ENABLE
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/DATA_B_IN_J_ENABLE
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/DATA_B_IN_K_ENABLE
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/DATA_B_IN
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/DATA_I_ENABLE
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/DATA_J_ENABLE
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/DATA_K_ENABLE
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/READY
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/DATA_OUT_I_ENABLE
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/DATA_OUT_J_ENABLE
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/DATA_OUT_K_ENABLE
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/DATA_OUT

add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/average_ctrl_fsm_int

add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/index_i_loop
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/index_j_loop
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/index_k_loop
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/index_m_loop

add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/data_a_in_i_average_int
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/data_a_in_j_average_int
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/data_a_in_k_average_int
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/data_b_in_i_average_int
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/data_b_in_j_average_int
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/data_b_in_k_average_int

add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/start_scalar_adder
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/operation_scalar_adder
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/data_a_in_scalar_adder
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/data_b_in_scalar_adder
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/ready_scalar_adder
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/data_out_scalar_adder
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/overflow_out_scalar_adder

add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/start_scalar_multiplier
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/data_a_in_scalar_multiplier
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/data_b_in_scalar_multiplier
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/ready_scalar_multiplier
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/data_out_scalar_multiplier
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_average_test/tensor_average/overflow_out_scalar_multiplier

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