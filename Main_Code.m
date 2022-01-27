clear all;
close all;
clc;
low_freq = 100; high_freq = 500;

down_factor = 100;
[x,fs,t, y2, w, N] = input_audio(low_freq, high_freq,down_factor);

[nqr] = source(y2,w,fs,x,N);

[quantized, symbol, symbols_rowVector, quantized_unique] = quantize(x,t);

[encoded_data, final_codebook, long_bitstream] = encode(quantized, symbol, symbols_rowVector);


roll_off_factors=[0 0.3 0.6 0.99];
[encoded_final_rc1, t2, Tb] = pulseshaping(long_bitstream, roll_off_factors);

[decode] = receiveddecode(encoded_final_rc1,t2, Tb);
 
f_aud = fs;
[final_sig] = tablelookup(decode, final_codebook, quantized_unique, t, f_aud);
