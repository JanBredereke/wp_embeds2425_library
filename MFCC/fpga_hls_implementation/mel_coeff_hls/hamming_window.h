// Author: Moses Dimmel
#ifndef HAMMING_WINDOW_H
#define HAMMING_WINDOW_H

#include <ap_fixed.h>
typedef ap_fixed<32,16> fixed_t;

// TODO: save hamming_window lut in bram
//#pragma HLS BIND_STORAGE variable=hamming_window type=RAM_2P impl=BRAM
extern const fixed_t hamming_window[512];

#endif // HAMMING_WINDOW_H
