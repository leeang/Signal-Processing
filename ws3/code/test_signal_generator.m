clear;
close all;

fs = 24E3;          % sampling frequency
f0 = [200 1000];    % test signal frequencies
N_x = fs;           % test signal length

vector = (0:N_x-1) / N_x;

x_martrix = zeros(length(f0), N_x);

for index=1:length(f0)
    x_martrix(index,:) = sin(2 * pi * f0(index) * vector);
end
clear index;

x = sum(x_martrix, 1);

plot(vector, x);
title('test signal $x[n]$ in time domain', 'Interpreter', 'latex');
xlabel('Time (s)');
ylabel('Magnitude (Linear Scale)');
xlim([0 0.015]);

[frequency_range, X] = single_side_FFT(x, fs);

figure;
stem(frequency_range, X, 'marker', 'none');
title('test signal $x[n]$ in frequency domain', 'Interpreter', 'latex');
xlabel('Frequency (Hz)');
ylabel('Magnitude (Linear Scale)');
xlim([0 2000]);

x = repmat(x, 1, 30);   % Repeat copies of array
% sound(x, fs);
