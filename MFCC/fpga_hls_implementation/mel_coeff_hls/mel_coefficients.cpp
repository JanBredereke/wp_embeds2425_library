// Author: Moses Dimmel
#include <hls_math.h>
#include "mel_coefficients.h"
#include "mel_filterbank_lut.h"
#include "hamming_window.h"

#define FFT_SIZE 512
#define MEL_BANDS 20


void dct(fixed_t mel_energy[MEL_BANDS], fixed_t mfcc[MEL_BANDS], axis_fft_stream &fft_out_axis, axis_fft_stream &fft_in_axis) {
	int DOUBLE_MEL_BANDS = 2 * MEL_BANDS;

	// TODO: configure fft scaling
	int factor = 8;

	// send input to fft ip block
	for (int i = 0; i < MEL_BANDS; i++) {
		#pragma HLS UNROLL

		while (fft_in_axis.full());
		axis_fft_t in_sample;

		in_sample.data.range(63, 32) = 0;
		in_sample.data.range(31, 0) = mel_energy[i];
		in_sample.keep = 0xF;
		fft_in_axis.write(in_sample);
	}
	for (int i = MEL_BANDS-1 ; i >= 0; i--) {
		#pragma HLS UNROLL

		while (fft_in_axis.full());
		axis_fft_t in_sample;

		in_sample.data.range(63, 32) = 0;
		in_sample.data.range(31, 0) = mel_energy[i];
		in_sample.keep = 0xF;
		in_sample.last = (i == 0);
		fft_in_axis.write(in_sample);
	}

	// read ouput of fft ip block
	for (int i = 0; i < DOUBLE_MEL_BANDS; i++) {
		#pragma HLS UNROLL

		while (fft_out_axis.empty());
		fixed_t real;
		axis_fft_t out_sample;

		// get real part
		out_sample = fft_out_axis.read();
		real.range(31, 0) = out_sample.data.range(31, 0);

		// undo scaling from fft ip block output
		real = real * factor;

		// add to output array
		if (i < MEL_BANDS) {
			mfcc[i] = real;
		}
	}
}

// Aufruf des FFT IP Blocks
void fft_transform(fixed_t windowed_audio[FFT_SIZE], fixed_t fft_magnitude[FFT_SIZE], axis_fft_stream &fft_out_axis, axis_fft_stream &fft_in_axis) {
	// TODO: Configure scaling of fft output
	int factor = 8;

	for (int i = 0; i < FFT_SIZE; i++) {
		#pragma HLS UNROLL

		while (fft_in_axis.full());
		axis_fft_t in_sample;

		in_sample.data.range(63, 32) = 0;
		in_sample.data.range(31, 0) = windowed_audio;
		in_sample.keep = 0xF;
		in_sample.last = (i == FFT_SIZE-1);
		fft_in_axis.write(in_sample);
	}


	for (int i = 0; i < FFT_SIZE; i++) {
		#pragma HLS UNROLL

		while (fft_out_axis.empty());
		fixed_t real, imag;
		axis_fft_t out_sample;

		out_sample = fft_out_axis.read();
		real.range(31, 0) = out_sample.data.range(31, 0);
		imag.range(31, 0) = out_sample.data.range(63, 32);

		// undo scaling from fft ip block output
		real = real * factor;
		imag = imag * factor;

		// calculate magnitude
		fft_magnitude[i] = hls::sqrt(real * real + imag * imag);
	}
}

// Mel-Cepstral-Koeffizienten-Berechnung
void mel_cepstral_coefficient_calculation(axis_stream &audio_in_axis, axis_stream &mfcc_out_axis, axis_fft_stream &fft_out_axis, axis_fft_stream &fft_in_axis) {
    #pragma HLS INTERFACE axis port=audio_in_axis
    #pragma HLS INTERFACE axis port=mfcc_out_axis
	#pragma HLS INTERFACE axis port=fft_out_axis
	#pragma HLS INTERFACE axis port=fft_in_axis
    #pragma HLS PIPELINE

	fixed_t windowed_audio[FFT_SIZE];
	fixed_t fft_real[FFT_SIZE];
	fixed_t fft_imag[FFT_SIZE] = {0};
	fixed_t fft_magnitude[FFT_SIZE];
	fixed_t mel_energy[MEL_BANDS];
	fixed_t mfcc[MEL_BANDS];

	// Input und Hamming-Fensterung
	axis_t in_sample;
	for (int i = 0; i < FFT_SIZE; i++) {
		#pragma HLS UNROLL factor=4
		while (audio_in_axis.empty());

		in_sample = audio_in_axis.read();

		if (in_sample.keep == 0xF) {
			continue;
		}

		windowed_audio[i] = in_sample.data * hamming_window[i];

		if (in_sample.last) {
			break;
		}
	}

	// FFT-Berechnung
	fft_transform(windowed_audio, fft_magnitude, fft_out_axis, fft_in_axis);

	// Mel-Filterbank anwenden
	for (int m = 0; m < MEL_BANDS; m++) {
		#pragma HLS UNROLL
		mel_energy[m] = 0.0;

		for (int k = 0; k < FFT_SIZE; k++) {
			mel_energy[m] += fft_magnitude[k] * mel_filterbank_lut[m][k];
		}

		// Logarithmus-Approximation
		mel_energy[m] = hls::log(hls::abs(mel_energy[m]) + fixed_t(1e-6));
	}

	// DCT für MFCCs
	dct(mel_energy, mfcc, fft_out_axis, fft_in_axis);

	// MFCC-Werte ausgeben
	axis_t out_sample;
	for (int i = 0; i < MEL_BANDS; i++) {
		#pragma HLS UNROLL
		while (mfcc_out_axis.full());

		out_sample.data = mfcc[i];
		out_sample.keep = 0xF;
		out_sample.last = (i == MEL_BANDS-1);
		mfcc_out_axis.write(out_sample);
	}
}
