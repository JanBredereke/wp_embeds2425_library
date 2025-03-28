// Author: Moses Dimmel
#ifndef MEL_FILTERBANK_LUT_H
#define MEL_FILTERBANK_LUT_H

#include <ap_fixed.h>
#include <ap_axi_sdata.h>
#include <hls_stream.h>

#define MEL_BANDS 20
#define FFT_SIZE 512
#define SAMPLE_RATE 48000

typedef ap_fixed<32, 16> fixed_t;

// AXI Stream Datentyp

typedef ap_axis<32,2,5,6> axis_t;
typedef ap_axis<64,2,5,6> axis_fft_t;

typedef hls::stream<axis_t> axis_stream;
typedef hls::stream<axis_fft_t> axis_fft_stream;

extern void dct_approx(fixed_t* , fixed_t*);
extern void mel_cepstral_coefficient_calculation(axis_stream&, axis_stream&);

#endif // MEL_FILTERBANK_LUT_H
