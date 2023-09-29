#*************************
# VERIFICATION
#*************************

do variables.do

mkdir wlf

##################################################################################################
# TEST SOURCES ###################################################################################
##################################################################################################

##################################################################################################
# MODEL_STANDARD_FNN_TEST 
##################################################################################################

alias model_standard_fnn_validation_compilation {
  echo "TEST: MODEL_STANDARD_FNN_TEST"

  vcom -2008 -reportprogress 300 -work work $validation_path/controller/FNN/standard/model_standard_fnn_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $validation_path/controller/FNN/standard/model_standard_fnn_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $validation_path/controller/FNN/standard/model_standard_fnn_testbench.vhd

  vsim -g /model_standard_fnn_testbench/ENABLE_MODEL_STANDARD_FNN_TEST=true -t ps +notimingchecks -L unisim work.model_standard_fnn_testbench

  #MACROS
  add log -r sim:/model_standard_fnn_testbench/*

  force -freeze sim:/model_standard_fnn_pkg/STIMULUS_MODEL_STANDARD_FNN_TEST true 0
  force -freeze sim:/model_standard_fnn_pkg/STIMULUS_MODEL_STANDARD_FNN_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_standard_fnn_test.wlf
}

##################################################################################################

alias v01 {
  model_standard_fnn_validation_compilation
}

echo "****************************************"
echo "v01 . ACCELERATOR-STANDARD-FNN-TEST"
echo "****************************************"
