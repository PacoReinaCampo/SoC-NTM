#*************************
# VERIFICATION COMPILATION
#*************************

# MODELSIM 10.4d

do ./variables.do

##################################################################################################
# TEST SOURCES ###################################################################################
##################################################################################################

##################################################################################################
# NTM_SCALAR_ADDER_TEST 
##################################################################################################

alias ntm_scalar_adder_verification_compilation {
  echo "TEST: NTM_SCALAR_ADDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/float/ntm_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/float/ntm_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/float/ntm_float_testbench.vhd

  vsim -g /ntm_float_testbench/ENABLE_NTM_SCALAR_ADDER_TEST=true -t ps +notimingchecks -L unisim work.ntm_float_testbench

  #MACROS
  add log -r sim:/ntm_float_testbench/*

  #WAVES
  view -title ntm_scalar_adder wave
  do $simulation_path/mpsoc/math/float/msim/waves/ntm_scalar_adder.do

  force -freeze sim:/ntm_float_pkg/STIMULUS_NTM_SCALAR_ADDER_TEST true 0
  force -freeze sim:/ntm_float_pkg/STIMULUS_NTM_SCALAR_ADDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_scalar_adder_test.wlf
}

##################################################################################################
# NTM_SCALAR_MULTIPLIER_TEST 
##################################################################################################

alias ntm_scalar_multiplier_verification_compilation {
  echo "TEST: NTM_SCALAR_MULTIPLIER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/float/ntm_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/float/ntm_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/float/ntm_float_testbench.vhd

  vsim -g /ntm_float_testbench/ENABLE_NTM_SCALAR_MULTIPLIER_TEST=true -t ps +notimingchecks -L unisim work.ntm_float_testbench

  #MACROS
  add log -r sim:/ntm_float_testbench/*

  #WAVES
  view -title ntm_scalar_multiplier wave
  do $simulation_path/mpsoc/math/float/msim/waves/ntm_scalar_multiplier.do

  force -freeze sim:/ntm_float_pkg/STIMULUS_NTM_SCALAR_MULTIPLIER_TEST true 0
  force -freeze sim:/ntm_float_pkg/STIMULUS_NTM_SCALAR_MULTIPLIER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_scalar_multiplier_test.wlf
}

##################################################################################################
##################################################################################################


  vcom -2008 -reportprogress 300 -work work $verification_path/math/float/ntm_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/float/ntm_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/float/ntm_float_testbench.vhd


  #MACROS
  add log -r sim:/ntm_float_testbench/*

  #WAVES


  onbreak {resume}
  run -all

}

##################################################################################################
# NTM_SCALAR_DIVIDER_TEST 
##################################################################################################

alias ntm_scalar_divider_verification_compilation {
  echo "TEST: NTM_SCALAR_DIVIDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/float/ntm_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/float/ntm_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/float/ntm_float_testbench.vhd

  vsim -g /ntm_float_testbench/ENABLE_NTM_SCALAR_DIVIDER_TEST=true -t ps +notimingchecks -L unisim work.ntm_float_testbench

  #MACROS
  add log -r sim:/ntm_float_testbench/*

  #WAVES
  view -title ntm_scalar_divider wave
  do $simulation_path/mpsoc/math/float/msim/waves/ntm_scalar_divider.do

  force -freeze sim:/ntm_float_pkg/STIMULUS_NTM_SCALAR_DIVIDER_TEST true 0
  force -freeze sim:/ntm_float_pkg/STIMULUS_NTM_SCALAR_DIVIDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_scalar_divider_test.wlf
}

##################################################################################################
##################################################################################################


  vcom -2008 -reportprogress 300 -work work $verification_path/math/float/ntm_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/float/ntm_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/float/ntm_float_testbench.vhd


  #MACROS
  add log -r sim:/ntm_float_testbench/*

  #WAVES


  onbreak {resume}
  run -all

}

##################################################################################################
# NTM_VECTOR_ADDER_TEST 
##################################################################################################

alias ntm_vector_adder_verification_compilation {
  echo "TEST: NTM_VECTOR_ADDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/float/ntm_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/float/ntm_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/float/ntm_float_testbench.vhd

  vsim -g /ntm_float_testbench/ENABLE_NTM_VECTOR_ADDER_TEST=true -t ps +notimingchecks -L unisim work.ntm_float_testbench

  #MACROS
  add log -r sim:/ntm_float_testbench/*

  #WAVES
  view -title ntm_vector_adder wave
  do $simulation_path/mpsoc/math/float/msim/waves/ntm_vector_adder.do

  force -freeze sim:/ntm_float_pkg/STIMULUS_NTM_VECTOR_ADDER_TEST true 0
  force -freeze sim:/ntm_float_pkg/STIMULUS_NTM_VECTOR_ADDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_adder_test.wlf
}

##################################################################################################
# NTM_VECTOR_MULTIPLIER_TEST 
##################################################################################################

alias ntm_vector_multiplier_verification_compilation {
  echo "TEST: NTM_VECTOR_MULTIPLIER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/float/ntm_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/float/ntm_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/float/ntm_float_testbench.vhd

  vsim -g /ntm_float_testbench/ENABLE_NTM_VECTOR_MULTIPLIER_TEST=true -t ps +notimingchecks -L unisim work.ntm_float_testbench

  #MACROS
  add log -r sim:/ntm_float_testbench/*

  #WAVES
  view -title ntm_vector_multiplier wave
  do $simulation_path/mpsoc/math/float/msim/waves/ntm_vector_multiplier.do

  force -freeze sim:/ntm_float_pkg/STIMULUS_NTM_VECTOR_MULTIPLIER_TEST true 0
  force -freeze sim:/ntm_float_pkg/STIMULUS_NTM_VECTOR_MULTIPLIER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_multiplier_test.wlf
}

##################################################################################################
##################################################################################################


  vcom -2008 -reportprogress 300 -work work $verification_path/math/float/ntm_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/float/ntm_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/float/ntm_float_testbench.vhd


  #MACROS
  add log -r sim:/ntm_float_testbench/*

  #WAVES


  onbreak {resume}
  run -all

}

##################################################################################################
# NTM_VECTOR_DIVIDER_TEST 
##################################################################################################

alias ntm_vector_divider_verification_compilation {
  echo "TEST: NTM_VECTOR_DIVIDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/float/ntm_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/float/ntm_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/float/ntm_float_testbench.vhd

  vsim -g /ntm_float_testbench/ENABLE_NTM_VECTOR_DIVIDER_TEST=true -t ps +notimingchecks -L unisim work.ntm_float_testbench

  #MACROS
  add log -r sim:/ntm_float_testbench/*

  #WAVES
  view -title ntm_vector_divider wave
  do $simulation_path/mpsoc/math/float/msim/waves/ntm_vector_divider.do

  force -freeze sim:/ntm_float_pkg/STIMULUS_NTM_VECTOR_DIVIDER_TEST true 0
  force -freeze sim:/ntm_float_pkg/STIMULUS_NTM_VECTOR_DIVIDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_divider_test.wlf
}

##################################################################################################
##################################################################################################


  vcom -2008 -reportprogress 300 -work work $verification_path/math/float/ntm_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/float/ntm_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/float/ntm_float_testbench.vhd


  #MACROS
  add log -r sim:/ntm_float_testbench/*

  #WAVES


  onbreak {resume}
  run -all

}

##################################################################################################

alias v01 {
  ntm_scalar_adder_verification_compilation 
}

alias v02 {
  ntm_scalar_multiplier_verification_compilation 
}

alias v03 {
}

alias v04 {
  ntm_scalar_divider_verification_compilation 
}

alias v05 {
}

alias v06 {
  ntm_vector_adder_verification_compilation 
}

alias v07 {
  ntm_vector_multiplier_verification_compilation 
}

alias v08 {
}

alias v09 {
  ntm_vector_divider_verification_compilation 
}

alias v10 {
}

echo "************************************************************"
echo "v01 . NTM-SCALAR-ADDER-TEST"
echo "v02 . NTM-SCALAR-MULTIPLIER-TEST"
echo "v04 . NTM-SCALAR-DIVIDER-TEST"
echo "v06 . NTM-VECTOR-ADDER-TEST"
echo "v07 . NTM-VECTOR-MULTIPLIER-TEST"
echo "v09 . NTM-VECTOR-DIVIDER-TEST"
echo "************************************************************"