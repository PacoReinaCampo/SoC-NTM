onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /ntm_algebra_pkg/MONITOR_TEST
add wave -noupdate /ntm_algebra_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM MATRIX INVERSE TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/CLK
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/RST
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/START
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/SIZE_A_I_IN
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/SIZE_A_J_IN
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/SIZE_B_I_IN
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/SIZE_B_J_IN
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/DATA_A_IN_I_ENABLE
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/DATA_A_IN_J_ENABLE
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/DATA_A_IN
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/DATA_B_IN_I_ENABLE
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/DATA_B_IN_J_ENABLE
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/DATA_B_IN
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/DATA_I_ENABLE
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/DATA_J_ENABLE
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/READY
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/DATA_OUT_I_ENABLE
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/DATA_OUT_J_ENABLE
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/DATA_OUT

add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/inverse_ctrl_fsm_int

add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/index_i_loop
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/index_j_loop
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/index_k_loop

add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/data_a_in_i_inverse_int
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/data_a_in_j_inverse_int
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/data_b_in_i_inverse_int
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/data_b_in_j_inverse_int

add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/start_scalar_adder
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/operation_scalar_adder
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/data_a_in_scalar_adder
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/data_b_in_scalar_adder
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/ready_scalar_adder
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/data_out_scalar_adder
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/overflow_out_scalar_adder

add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/start_scalar_multiplier
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/data_a_in_scalar_multiplier
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/data_b_in_scalar_multiplier
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/ready_scalar_multiplier
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/data_out_scalar_multiplier
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_inverse_test/matrix_inverse/overflow_out_scalar_multiplier

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