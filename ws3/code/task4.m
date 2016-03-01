clear;
close all;

fs = 24E3;              % sampling frequency
f_pass = 220;           % passband frequency in Hz
f_stop = 880;           % stopband frequency in Hz

N = 2^9;                % block length

a = [1 0];
dev = [0.05 0.05];

%% FIR filter design
[n_order, fo, ao, w] = firpmord([f_pass f_stop], a, dev, fs);
n_order = n_order + 7;  % increment the filter order until all specifications are satisfied

numerator = firpm(n_order, fo, ao, w);
clear a dev fo ao w;
M = num2str(length(numerator));

[h_FIR, w_FIR] = freqz(numerator, 1, 2^12);

figure;
subplot(2, 1, 1);
plot(w_FIR/pi, abs(h_FIR));
title(['Magnitude response  ' num2str(n_order) 'th-order  M = ' M]);
ylabel('Magnitude (Linear Scale)');
grid on;

subplot(2, 1, 2);
plot(w_FIR/pi, rad2deg(phase(h_FIR)));
title(['Phase response  ' num2str(n_order) 'th-order  M = ' M]);
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Phase (degrees)');
grid on;

figure;
subplot(2, 1, 1);
plot(w_FIR/pi, abs(h_FIR));
title('Magnitude response (zoomed)');
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Magnitude (Linear Scale)');
axis([0 0.1 0.85 1.1]);

hold on;
plot([f_pass*2/fs f_pass*2/fs], [0.5 1.5], '--');
legend('magnitude', 'passband');

subplot(2, 1, 2);
plot(w_FIR/pi, abs(h_FIR));
title('Magnitude response (zoomed)');
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Magnitude (Linear Scale)');
axis([0 1 -0.01 0.05]);
grid on;
clear h_FIR w_FIR;

hold on;
plot([f_stop*2/fs f_stop*2/fs], [-0.5 0.5], '--', 'linewidth', 1.5);
legend('magnitude', 'stopband');

%% generate test signal

f0 = (1:9)*200;     % test signal frequencies
N_x = fs;           % test signal length

vector = (0:N_x-1) / fs;

x_martrix = zeros(length(f0), N_x);

for index=1:length(f0)
    x_martrix(index,:) = sin(2 * pi * f0(index) * vector);
end
clear index;

x = sum(x_martrix);

%% FIR filter implementation and test

y_filter  = filter(numerator, 1, x);
y_fftfilt  = fftfilt(numerator, x);
y_overlapaddreal = overlapaddreal(numerator, x, N);

[~, X] = single_side_FFT(x, fs);
[~, Y_filter] = single_side_FFT(y_filter, fs);
[~, Y_ffftfilt] = single_side_FFT(y_fftfilt, fs);
[frequency_range, Y_overlapaddreal] = single_side_FFT(y_overlapaddreal, fs);

figure;
plot(vector, x);
title('test signal $x[n]$ in time domain', 'Interpreter', 'latex');
xlabel('Time (s)');
ylabel('Magnitude (Linear Scale)');
xlim([0 0.015]);

figure;
stem(frequency_range, X, 'marker', 'none');
title('test signal $x[n]$ in frequency domain', 'Interpreter', 'latex');
xlabel('Frequency (Hz)');
ylabel('Magnitude (Linear Scale)');
xlim([0 2000]);

figure;
subplot(2, 1, 1);
stem(frequency_range, X, 'marker', 'none');
title('test signal $x[n]$ in frequency domain', 'Interpreter', 'latex');
xlabel('Frequency (Hz)');
ylabel('Magnitude (Linear Scale)');
xlim([0 2000]);

subplot(2, 1, 2);
stem(frequency_range, Y_filter, 'marker', 'none');
title('$y[n]$ computed by \texttt{filter()} in frequency domain', 'Interpreter', 'latex');
xlabel('Frequency (Hz)');
ylabel('Magnitude (Linear Scale)');
hold on;
plot([f_stop f_stop], [0 0.5], '--');
legend('magnitude', 'stopband');
xlim([0 2000]);

figure;
subplot(2, 1, 1);
stem(frequency_range, Y_ffftfilt, 'marker', 'none');
title('$y[n]$ computed by \texttt{fftfilt()} in frequency domain', 'Interpreter', 'latex');
xlabel('Frequency (Hz)');
ylabel('Magnitude (Linear Scale)');
hold on;
plot([f_stop f_stop], [0 0.5], '--');
legend('magnitude', 'stopband');
xlim([0 2000]);

subplot(2, 1, 2);
stem(frequency_range, Y_overlapaddreal, 'marker', 'none');
title('$y[n]$ computed by \texttt{overlapaddreal()} in frequency domain', 'Interpreter', 'latex');
xlabel('Frequency (Hz)');
ylabel('Magnitude (Linear Scale)');
hold on;
plot([f_stop f_stop], [0 0.5], '--');
legend('magnitude', 'stopband');
xlim([0 2000]);

% Display warning message if results are inconsistent
if any(abs(y_filter - y_fftfilt) > eps('single'))
    warning('filter() result and fftfilt() result are inconsistent.');
end

if any(abs(y_filter - y_overlapaddreal) > eps('single'))
    warning('filter() result and overlapaddreal() result are inconsistent.');
end
