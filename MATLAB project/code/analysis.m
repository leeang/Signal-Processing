clear;
close all;

F_s = 32.768E3;
% sampling frequency

load('projsignal1');
N = 25E3;
rs = rs(1:N);
% the first 25000 data points

[frequency_range, Rs] = single_side_FFT(rs, F_s);

stem(frequency_range, Rs, 'marker', 'none');
title('FFT analysis of r_s[n]');
xlabel('Frequency (Hz)');
ylabel('Magnitude (Linear Scale)');

figure;
stem(frequency_range, 20*log10(Rs), 'marker', 'none');
title('FFT analysis of r_s[n]');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');

fprintf('Sinusoid frequency: F_0 = %.1f Hz\n', frequency_range(Rs==max(Rs)));
