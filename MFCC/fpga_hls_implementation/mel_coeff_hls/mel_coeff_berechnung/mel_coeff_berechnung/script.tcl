############################################################
## This file is generated automatically by Vitis HLS.
## Please DO NOT edit it.
## Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
## Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
############################################################
open_project mel_coeff_berechnung
set_top mel_filterbank
add_files hamming_window.cpp
add_files hamming_window.h
add_files mel_coefficients.cpp
add_files mel_coefficients.h
add_files mel_filterbank_lut.cpp
add_files mel_filterbank_lut.h
add_files -tb test_mel.cpp -cflags "-Wno-unknown-pragmas"
open_solution "mel_coeff_berechnung" -flow_target vivado
set_part {xc7z020-clg400-1}
create_clock -period 10 -name default
#source "./mel_coeff_berechnung/mel_coeff_berechnung/directives.tcl"
csim_design -clean
csynth_design
cosim_design
export_design -format ip_catalog
