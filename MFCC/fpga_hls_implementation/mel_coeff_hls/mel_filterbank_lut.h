// Author: Moses Dimmel
//#ifndef MEL_FILTERBANK_LUT_H
//#define MEL_FILTERBANK_LUT_H
#pragma once

#include <ap_fixed.h>
typedef ap_fixed<32,16> fixed_t;


// TODO: store mel_filterbank lut in bram
//#pragma HLS BIND_STORAGE variable=mel_filterbank_lut type=RAM_2P impl=BRAM
extern const fixed_t mel_filterbank_lut[20][512];

//#endif // MEL_FILTERBANK_LUT_H
