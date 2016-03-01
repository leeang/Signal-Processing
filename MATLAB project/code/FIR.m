clear;
close all;

notch_F_0 = 7372.8;     % sinusoid noise frequency
F_s = 32.768E3;         % sampling frequency
F_c = 12.288E3;         % carrier frequency

signal_bw = 4096;
r2_lower_bound = F_c - signal_bw;

load('projsignal1');

rs = rs(1:25E3);
% the first 25000 data points

N = length(rs);


%% BlockA notch filter

notch_BW = 1;
% notch filter bandwidth (Hz)

f = [notch_F_0-500 notch_F_0-notch_BW/2 notch_F_0+notch_BW/2 notch_F_0+500];
a = [1 0 1];
dev = [5E-3 1E-3 5E-3];

[nBlockA, fo, ao, w] = firpmord(f, a, dev, F_s);
numBlockA = firpm(nBlockA, fo, ao, w);

[hBlockA, wBlockA] = freqz(numBlockA, 1, 2^10);

figure;
subplot(2, 1, 1);
plot(wBlockA/pi, abs(hBlockA));
title('Block A amplitude response');
ylabel('Magnitude (Linear Scale)');
grid on;

subplot(2, 1, 2);
plot(wBlockA/pi, rad2deg(phase(hBlockA)));
title('Block A phase response');
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Phase (Degrees)');
grid on;

clear wBlockA hBlockA;


%% BlockA output

r = filter(numBlockA, 1, rs);

[frequency_range, R] = single_side_FFT(r, F_s);

figure;
stem(frequency_range, R, 'marker', 'none');
title('r[n] in frequency domain');
xlabel('Frequency (Hz)');
ylabel('Magnitude (Linear Scale)');
clear R;


%% BlockD Lowpass filter

f = [signal_bw signal_bw+500];
a = [1 0];
dev = [5E-3 0.01];

[nBlockD, fo, ao, w] = firpmord(f, a, dev, F_s);
numBlockD = firpm(nBlockD, fo, ao, w);

[hBlockD, wBlockD] = freqz(numBlockD, 1);

figure;
subplot(2, 1, 1);
plot(wBlockD/pi, abs(hBlockD));
title('Block D amplitude response');
ylabel('Magnitude (Linear Scale)');
grid on;

subplot(2, 1, 2);
plot(wBlockD/pi, rad2deg(phase(hBlockD)));
title('Block D phase response');
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Phase (Degrees)');
grid on;
clear wBlockD hBlockD;


%% H1(z)

[hH1, wH1] = freqz(conv(numBlockA, numBlockD), 1);

figure;
subplot(3, 1, 1);
plot(wH1/pi, abs(hH1));
title('H_1(z) amplitude response');
ylabel('Magnitude (Linear Scale)');
grid on;

subplot(3, 1, 2);
plot(wH1/pi, abs(hH1));
title('H_1(z) amplitude response (zoomed)');
ylabel('Magnitude (Linear Scale)');
grid on;
axis([0 1 0.98 1.02]);
hold on;
plot([0.25 0.25], [0.95 1.05], '--');
legend('H_1(z) response', 'r_1[n] bandwidth');

subplot(3, 1, 3);
plot(wH1/pi, rad2deg(phase(hH1)));
title('H_1(z) phase response');
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Phase (Degrees)');
grid on;

clear wH1 hH1;


%% BlockD output

s1 = filter(numBlockD, 1, r);
clear numBlockD;

[frequency_range, S1] = single_side_FFT(s1, F_s);

figure;
stem(frequency_range, S1, 'marker', 'none');
title('s_1[n] in frequency domain');
xlabel('Frequency (Hz)');
ylabel('Magnitude (Linear Scale)');
clear S1;


%% BlockB Highpass filter

f = [r2_lower_bound-500 r2_lower_bound];
a = [0 1];
dev = [0.01 5E-3];

[nBlockB, fo, ao, w] = firpmord(f, a, dev, F_s);
numBlockB = firpm(nBlockB, fo, ao, w);

[hBlockB, wBlockB] = freqz(numBlockB, 1);

figure;
subplot(2, 1, 1);
plot(wBlockB/pi, abs(hBlockB));
title('Block B amplitude response');
ylabel('Magnitude (Linear Scale)');
grid on;

subplot(2, 1, 2);
plot(wBlockB/pi, rad2deg(phase(hBlockB)));
title('Block B phase response');
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Phase (Degrees)');
grid on;
clear wBlockB hBlockB;


%% H2(z) cascading BlockA and BlockB

[hH2, wH2] = freqz(conv(numBlockA, numBlockB), 1);
clear numBlockA;

figure;
subplot(3, 1, 1);
plot(wH2/pi, abs(hH2));
title('H_2(z) amplitude response');
ylabel('Magnitude (Linear Scale)');
grid on;

subplot(3, 1, 2);
plot(wH2/pi, abs(hH2));
title('H_2(z) amplitude response (zoomed)');
ylabel('Magnitude (Linear Scale)');
grid on;
axis([0 1 0.98 1.02]);
hold on;
plot([0.5 0.5], [0.95 1.05], '--');
legend('H_2(z) response', 'DSB-SC lower bound', 'Location', 'northwest');

subplot(3, 1, 3);
plot(wH2/pi, rad2deg(phase(hH2)));
title('H_2(z) phase response');
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Phase (Degrees)');
grid on;

clear wH2 hH2;


%% BlockB output

s2_tilde = filter(numBlockB, 1, r);
clear numBlockB;

[frequency_range, S2_tilde] = single_side_FFT(s2_tilde, F_s);

figure;
stem(frequency_range, S2_tilde, 'marker', 'none');
title('$\tilde{s}_2[n]$ in frequency domain', 'Interpreter', 'latex');
xlabel('Frequency (Hz)');
ylabel('Magnitude (Linear Scale)');

% [~, index] = max(S2_tilde);
index = 9450;
text(frequency_range(index) + 0.02 * max(frequency_range), S2_tilde(index), ['$f$ = ' num2str(frequency_range(index)) ' Hz'], 'Interpreter', 'latex');
text(frequency_range(index) + 0.02 * max(frequency_range), S2_tilde(index) * 0.95, ['$\tilde{s}_2[n]$ = ' num2str(S2_tilde(index))], 'Interpreter', 'latex');
hold on;
plot(frequency_range(index), S2_tilde(index), 'x');

plot([r2_lower_bound r2_lower_bound], [min(S2_tilde) max(S2_tilde)], '--');
legend('amplitude', 'indicator', 'DSB-SC lower bound', 'Location', 'northwest');

clear S2_tilde;


%% BlockC Demodulator

phi = find_phi(s2_tilde);
fprintf('Demodulation carrier signal: phi = %f * pi\n', phi/pi);

t = 1/F_s * (0:N-1)';
v_c = cos(2 * pi * F_c * t + phi);
y = s2_tilde .* v_c;
clear t v_c;

[frequency_range, Y] = single_side_FFT(y, F_s);

figure;
stem(frequency_range, Y, 'marker', 'none');
title('$\tilde{s}_2[n] \cdot v_c[n]$ in frequency domain', 'Interpreter', 'latex');
xlabel('Frequency (Hz)');
ylabel('Magnitude (Linear Scale)');

hold on;
plot([signal_bw signal_bw], [min(Y) max(Y)], '--');
legend('amplitude', 'original signal bandwidth');

clear Y;


%% BlockC Lowpass filter

f = [signal_bw signal_bw+500];
a = [1 0];
dev = [5E-3 5E-3];

[nBlockC, fo, ao, w] = firpmord(f, a, dev, F_s);
numBlockC = firpm(nBlockC, fo, ao, w);
clear fo ao w;

[hBlockC, wBlockC] = freqz(numBlockC, 1);

figure;
subplot(3, 1, 1);
plot(wBlockC/pi, abs(hBlockC));
title('Block C amplitude response');
ylabel('Magnitude (Linear Scale)');
grid on;

subplot(3, 1, 2);
plot(wBlockC/pi, abs(hBlockC));
title('Block C amplitude response (zoomed)');
ylabel('Magnitude (Linear Scale)');
grid on;
axis([0 1 0.98 1.02]);
hold on;
plot([0.25 0.25], [0.95 1.05], '--', 'linewidth', 1.5);
legend('amplitude response', 'original signal bandwidth');

subplot(3, 1, 3);
plot(wBlockC/pi, rad2deg(phase(hBlockC)));
title('Block C phase response');
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Phase (Degrees)');
grid on;

clear wBlockC hBlockC;


%% BlockC output

s2 = filter(numBlockC, 1, y);
clear numBlockC;

[frequency_range, S2] = single_side_FFT(s2, F_s);

figure;
stem(frequency_range, S2, 'marker', 'none');
title('s_2[n] in frequency domain');
xlabel('Frequency (Hz)');
ylabel('Magnitude (Linear Scale)');

hold on;
plot([signal_bw signal_bw], [min(S2) max(S2)], '--');
legend('amplitude', 'original signal bandwidth');

clear S2;
