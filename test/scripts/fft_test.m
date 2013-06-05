%Data for 1D FFT to test all FFT methods against

%FFT Length
n = 128;
l = 4*pi;
x = 0:l/(n-1):l;
y = sin(x);

output = fft(y);

real_vals = real(output);
imag_vals = imag(output);

json = struct('real',real_vals,'imag',imag_vals);

savejson('',json,'FileName','fft_test.data','FloatFormat','%.15e')
