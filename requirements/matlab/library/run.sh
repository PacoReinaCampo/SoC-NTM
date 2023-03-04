###################################################################################
##                                            __ _      _     _                  ##
##                                           / _(_)    | |   | |                 ##
##                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |                 ##
##               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |                 ##
##              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |                 ##
##               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|                 ##
##                  | |                                                          ##
##                  |_|                                                          ##
##                                                                               ##
##                                                                               ##
##              QueenField                                                       ##
##              Multi-Processor System on Chip                                   ##
##                                                                               ##
###################################################################################

###################################################################################
##                                                                               ##
## Copyright (c) 2022-2025 by the author(s)                                      ##
##                                                                               ##
## Permission is hereby granted, free of charge, to any person obtaining a copy  ##
## of this software and associated documentation files (the "Software"), to deal ##
## in the Software without restriction, including without limitation the rights  ##
## to use, copy, modify, merge, publish, distribute, sublicense, and/or sell     ##
## copies of the Software, and to permit persons to whom the Software is         ##
## furnished to do so, subject to the following conditions:                      ##
##                                                                               ##
## The above copyright notice and this permission notice shall be included in    ##
## all copies or substantial portions of the Software.                           ##
##                                                                               ##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    ##
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,      ##
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE   ##
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER        ##
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, ##
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN     ##
## THE SOFTWARE.                                                                 ##
##                                                                               ##
## ============================================================================= ##
## Author(s):                                                                    ##
##   Paco Reina Campo <pacoreinacampo@queenfield.tech>                           ##
##                                                                               ##
###################################################################################

cd arithmetic/matrix; octave ntm_matrix_adder.tb.m; cd ../..
cd arithmetic/matrix; octave ntm_matrix_divider.tb.m; cd ../..
cd arithmetic/matrix; octave ntm_matrix_multiplier.tb.m; cd ../..
cd arithmetic/scalar; octave ntm_scalar_adder.tb.m; cd ../..
cd arithmetic/scalar; octave ntm_scalar_divider.tb.m; cd ../..
cd arithmetic/scalar; octave ntm_scalar_multiplier.tb.m; cd ../..
cd arithmetic/tensor; octave ntm_tensor_adder.tb.m; cd ../..
cd arithmetic/tensor; octave ntm_tensor_divider.tb.m; cd ../..
cd arithmetic/tensor; octave ntm_tensor_multiplier.tb.m; cd ../..
cd arithmetic/vector; octave ntm_vector_adder.tb.m; cd ../..
cd arithmetic/vector; octave ntm_vector_divider.tb.m; cd ../..
cd arithmetic/vector; octave ntm_vector_multiplier.tb.m; cd ../..

cd controller/FNN/convolutional; octave ntm_controller.tb.m; cd ../../..
cd controller/FNN/standard; octave ntm_controller.tb.m; cd ../../..
cd controller/LSTM/convolutional; octave ntm_activation_gate_vector.tb.m; cd ../../..
cd controller/LSTM/convolutional; octave ntm_controller.tb.m; cd ../../..
cd controller/LSTM/convolutional; octave ntm_forget_gate_vector.tb.m; cd ../../..
cd controller/LSTM/convolutional; octave ntm_hidden_gate_vector.tb.m; cd ../../..
cd controller/LSTM/convolutional; octave ntm_input_gate_vector.tb.m; cd ../../..
cd controller/LSTM/convolutional; octave ntm_output_gate_vector.tb.m; cd ../../..
cd controller/LSTM/convolutional; octave ntm_state_gate_vector.tb.m; cd ../../..
cd controller/LSTM/standard; octave ntm_activation_gate_vector.tb.m; cd ../../..
cd controller/LSTM/standard; octave ntm_controller.tb.m; cd ../../..
cd controller/LSTM/standard; octave ntm_forget_gate_vector.tb.m; cd ../../..
cd controller/LSTM/standard; octave ntm_hidden_gate_vector.tb.m; cd ../../..
cd controller/LSTM/standard; octave ntm_input_gate_vector.tb.m; cd ../../..
cd controller/LSTM/standard; octave ntm_output_gate_vector.tb.m; cd ../../..
cd controller/LSTM/standard; octave ntm_state_gate_vector.tb.m; cd ../../..
cd controller/transformer/components; octave ntm_masked_multi_head_attention.tb.m; cd ../../..
cd controller/transformer/components; octave ntm_masked_scaled_dot_product_attention.tb.m; cd ../../..
cd controller/transformer/components; octave ntm_multi_head_attention.tb.m; cd ../../..
cd controller/transformer/components; octave ntm_scaled_dot_product_attention.tb.m; cd ../../..
cd controller/transformer/fnn; octave ntm_fnn.tb.m; cd ../../..
cd controller/transformer/functions; octave ntm_layer_norm.tb.m; cd ../../..
cd controller/transformer/functions; octave ntm_positional_encoding.tb.m; cd ../../..
cd controller/transformer/inputs; octave ntm_inputs_vector.tb.m; cd ../../..
cd controller/transformer/inputs; octave ntm_keys_vector.tb.m; cd ../../..
cd controller/transformer/inputs; octave ntm_queries_vector.tb.m; cd ../../..
cd controller/transformer/inputs; octave ntm_values_vector.tb.m; cd ../../..
cd controller/transformer/lstm; octave ntm_activation_gate_vector.tb.m; cd ../../..
cd controller/transformer/lstm; octave ntm_forget_gate_vector.tb.m; cd ../../..
cd controller/transformer/lstm; octave ntm_hidden_gate_vector.tb.m; cd ../../..
cd controller/transformer/lstm; octave ntm_input_gate_vector.tb.m; cd ../../..
cd controller/transformer/lstm; octave ntm_lstm.tb.m; cd ../../..
cd controller/transformer/lstm; octave ntm_output_gate_vector.tb.m; cd ../../..
cd controller/transformer/lstm; octave ntm_state_gate_vector.tb.m; cd ../../..
cd controller/transformer/top; octave ntm_controller.tb.m; cd ../../..
cd controller/transformer/top; octave ntm_decoder.tb.m; cd ../../..
cd controller/transformer/top; octave ntm_encoder.tb.m; cd ../../..

#cd dnc/memory; octave dnc_addressing.tb.m; cd ../..
#cd dnc/memory; octave dnc_allocation_weighting.tb.m; cd ../..
#cd dnc/memory; octave dnc_backward_weighting.tb.m; cd ../..
#cd dnc/memory; octave dnc_forward_weighting.tb.m; cd ../..
#cd dnc/memory; octave dnc_matrix_content_based_addressing.tb.m; cd ../..
#cd dnc/memory; octave dnc_memory_matrix.tb.m; cd ../..
#cd dnc/memory; octave dnc_memory_retention_vector.tb.m; cd ../..
#cd dnc/memory; octave dnc_precedence_weighting.tb.m; cd ../..
#cd dnc/memory; octave dnc_read_content_weighting.tb.m; cd ../..
#cd dnc/memory; octave dnc_read_vectors.tb.m; cd ../..
#cd dnc/memory; octave dnc_read_weighting.tb.m; cd ../..
#cd dnc/memory; octave dnc_sort_vector.tb.m; cd ../..
#cd dnc/memory; octave dnc_temporal_link_matrix.tb.m; cd ../..
#cd dnc/memory; octave dnc_usage_vector.tb.m; cd ../..
#cd dnc/memory; octave dnc_vector_content_based_addressing.tb.m; cd ../..
#cd dnc/memory; octave dnc_write_content_weighting.tb.m; cd ../..
#cd dnc/memory; octave dnc_write_weighting.tb.m; cd ../..
#cd dnc/top; octave dnc_interface_matrix.tb.m; cd ../..
#cd dnc/top; octave dnc_interface_top.tb.m; cd ../..
#cd dnc/top; octave dnc_interface_vector.tb.m; cd ../..
#cd dnc/top; octave dnc_output_vector.tb.m; cd ../..
#cd dnc/top; octave dnc_top.tb.m; cd ../..
#cd dnc/trained; octave dnc_trained_top.tb.m; cd ../..

cd math/algebra/matrix; octave ntm_matrix_convolution.tb.m; cd ../../..
cd math/algebra/matrix; octave ntm_matrix_inverse.tb.m; cd ../../..
cd math/algebra/matrix; octave ntm_matrix_multiplication.tb.m; cd ../../..
cd math/algebra/matrix; octave ntm_matrix_product.tb.m; cd ../../..
cd math/algebra/matrix; octave ntm_matrix_summation.tb.m; cd ../../..
cd math/algebra/matrix; octave ntm_matrix_transpose.tb.m; cd ../../..
cd math/algebra/matrix; octave ntm_matrix_vector_convolution.tb.m; cd ../../..
cd math/algebra/matrix; octave ntm_matrix_vector_product.tb.m; cd ../../..
cd math/algebra/matrix; octave ntm_transpose_vector_product.tb.m; cd ../../..
cd math/algebra/scalar; octave ntm_scalar_multiplication.tb.m; cd ../../..
cd math/algebra/scalar; octave ntm_scalar_summation.tb.m; cd ../../..
cd math/algebra/tensor; octave ntm_tensor_convolution.tb.m; cd ../../..
cd math/algebra/tensor; octave ntm_tensor_inverse.tb.m; cd ../../..
cd math/algebra/tensor; octave ntm_tensor_matrix_convolution.tb.m; cd ../../..
cd math/algebra/tensor; octave ntm_tensor_matrix_product.tb.m; cd ../../..
cd math/algebra/tensor; octave ntm_tensor_multiplication.tb.m; cd ../../..
cd math/algebra/tensor; octave ntm_tensor_product.tb.m; cd ../../..
cd math/algebra/tensor; octave ntm_tensor_summation.tb.m; cd ../../..
cd math/algebra/tensor; octave ntm_tensor_transpose.tb.m; cd ../../..
cd math/algebra/vector; octave ntm_dot_product.tb.m; cd ../../..
cd math/algebra/vector; octave ntm_vector_convolution.tb.m; cd ../../..
cd math/algebra/vector; octave ntm_vector_cosine_similarity.tb.m; cd ../../..
cd math/algebra/vector; octave ntm_vector_module.tb.m; cd ../../..
cd math/algebra/vector; octave ntm_vector_multiplication.tb.m; cd ../../..
cd math/algebra/vector; octave ntm_vector_summation.tb.m; cd ../../..
cd math/calculus/matrix; octave ntm_matrix_differentiation.tb.m; cd ../../..
cd math/calculus/matrix; octave ntm_matrix_integration.tb.m; cd ../../..
cd math/calculus/matrix; octave ntm_matrix_softmax.tb.m; cd ../../..
cd math/calculus/tensor; octave ntm_tensor_differentiation.tb.m; cd ../../..
cd math/calculus/tensor; octave ntm_tensor_integration.tb.m; cd ../../..
cd math/calculus/tensor; octave ntm_tensor_softmax.tb.m; cd ../../..
cd math/calculus/vector; octave ntm_vector_differentiation.tb.m; cd ../../..
cd math/calculus/vector; octave ntm_vector_integration.tb.m; cd ../../..
cd math/calculus/vector; octave ntm_vector_softmax.tb.m; cd ../../..
cd math/function/matrix; octave ntm_matrix_logistic_function.tb.m; cd ../../..
cd math/function/matrix; octave ntm_matrix_oneplus_function.tb.m; cd ../../..
cd math/function/scalar; octave ntm_scalar_logistic_function.tb.m; cd ../../..
cd math/function/scalar; octave ntm_scalar_oneplus_function.tb.m; cd ../../..
cd math/function/vector; octave ntm_vector_logistic_function.tb.m; cd ../../..
cd math/function/vector; octave ntm_vector_oneplus_function.tb.m; cd ../../..
cd math/statitics/matrix; octave ntm_matrix_deviation.tb.m; cd ../../..
cd math/statitics/matrix; octave ntm_matrix_mean.tb.m; cd ../../..
cd math/statitics/scalar; octave ntm_scalar_deviation.tb.m; cd ../../..
cd math/statitics/scalar; octave ntm_scalar_mean.tb.m; cd ../../..
cd math/statitics/vector; octave ntm_vector_deviation.tb.m; cd ../../..
cd math/statitics/vector; octave ntm_vector_mean.tb.m; cd ../../..

#cd ntm/memory; octave ntm_addressing.tb.m; cd ../..
#cd ntm/memory; octave ntm_matrix_content_based_addressing.tb.m; cd ../..
#cd ntm/memory; octave ntm_vector_content_based_addressing.tb.m; cd ../..
#cd ntm/read_heads; octave ntm_reading.tb.m; cd ../..
#cd ntm/top; octave ntm_interface_matrix.tb.m; cd ../..
#cd ntm/top; octave ntm_interface_top.tb.m; cd ../..
#cd ntm/top; octave ntm_interface_vector.tb.m; cd ../..
#cd ntm/top; octave ntm_output_vector.tb.m; cd ../..
#cd ntm/top; octave ntm_top.tb.m; cd ../..
#cd ntm/trained; octave ntm_trained_top.tb.m; cd ../..
#cd ntm/write_heads; octave ntm_erasing.tb.m; cd ../..
#cd ntm/write_heads; octave ntm_writing.tb.m; cd ../..

#cd state/feedback; octave ntm_state_matrix_feedforward.tb.m; cd ../..
#cd state/feedback; octave ntm_state_matrix_input.tb.m; cd ../..
#cd state/feedback; octave ntm_state_matrix_output.tb.m; cd ../..
#cd state/feedback; octave ntm_state_matrix_state.tb.m; cd ../..
#cd state/outputs; octave ntm_state_vector_output.tb.m; cd ../..
#cd state/outputs; octave ntm_state_vector_state.tb.m; cd ../..
#cd state/top; octave ntm_state_top.tb.m; cd ../..

#cd trainer/differentiation; octave ntm_matrix_controller_differentiation.tb.m; cd ../..
#cd trainer/differentiation; octave ntm_vector_controller_differentiation.tb.m; cd ../..
#cd trainer/FNN; octave ntm_fnn_b_trainer.tb.m; cd ../..
#cd trainer/FNN; octave ntm_fnn_d_trainer.tb.m; cd ../..
#cd trainer/FNN; octave ntm_fnn_k_trainer.tb.m; cd ../..
#cd trainer/FNN; octave ntm_fnn_trainer.tb.m; cd ../..
#cd trainer/FNN; octave ntm_fnn_u_trainer.tb.m; cd ../..
#cd trainer/FNN; octave ntm_fnn_v_trainer.tb.m; cd ../..
#cd trainer/FNN; octave ntm_fnn_w_trainer.tb.m; cd ../..
#cd trainer/LSTM/activation; octave ntm_lstm_activation_b_trainer.tb.m; cd ../../..
#cd trainer/LSTM/activation; octave ntm_lstm_activation_d_trainer.tb.m; cd ../../..
#cd trainer/LSTM/activation; octave ntm_lstm_activation_k_trainer.tb.m; cd ../../..
#cd trainer/LSTM/activation; octave ntm_lstm_activation_trainer.tb.m; cd ../../..
#cd trainer/LSTM/activation; octave ntm_lstm_activation_u_trainer.tb.m; cd ../../..
#cd trainer/LSTM/activation; octave ntm_lstm_activation_v_trainer.tb.m; cd ../../..
#cd trainer/LSTM/activation; octave ntm_lstm_activation_w_trainer.tb.m; cd ../../..
#cd trainer/LSTM/forget; octave ntm_lstm_forget_b_trainer.tb.m; cd ../../..
#cd trainer/LSTM/forget; octave ntm_lstm_forget_d_trainer.tb.m; cd ../../..
#cd trainer/LSTM/forget; octave ntm_lstm_forget_k_trainer.tb.m; cd ../../..
#cd trainer/LSTM/forget; octave ntm_lstm_forget_trainer.tb.m; cd ../../..
#cd trainer/LSTM/forget; octave ntm_lstm_forget_u_trainer.tb.m; cd ../../..
#cd trainer/LSTM/forget; octave ntm_lstm_forget_v_trainer.tb.m; cd ../../..
#cd trainer/LSTM/forget; octave ntm_lstm_forget_w_trainer.tb.m; cd ../../..
#cd trainer/LSTM/input; octave ntm_lstm_input_b_trainer.tb.m; cd ../../..
#cd trainer/LSTM/input; octave ntm_lstm_input_d_trainer.tb.m; cd ../../..
#cd trainer/LSTM/input; octave ntm_lstm_input_k_trainer.tb.m; cd ../../..
#cd trainer/LSTM/input; octave ntm_lstm_input_trainer.tb.m; cd ../../..
#cd trainer/LSTM/input; octave ntm_lstm_input_u_trainer.tb.m; cd ../../..
#cd trainer/LSTM/input; octave ntm_lstm_input_v_trainer.tb.m; cd ../../..
#cd trainer/LSTM/input; octave ntm_lstm_input_w_trainer.tb.m; cd ../../..
#cd trainer/LSTM/output; octave ntm_lstm_output_b_trainer.tb.m; cd ../../..
#cd trainer/LSTM/output; octave ntm_lstm_output_d_trainer.tb.m; cd ../../..
#cd trainer/LSTM/output; octave ntm_lstm_output_k_trainer.tb.m; cd ../../..
#cd trainer/LSTM/output; octave ntm_lstm_output_trainer.tb.m; cd ../../..
#cd trainer/LSTM/output; octave ntm_lstm_output_u_trainer.tb.m; cd ../../..
#cd trainer/LSTM/output; octave ntm_lstm_output_v_trainer.tb.m; cd ../../..
#cd trainer/LSTM/output; octave ntm_lstm_output_w_trainer.tb.m; cd ../../..
