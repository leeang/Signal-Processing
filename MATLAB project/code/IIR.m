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


%% BlockA 2nd order notch filter

notch_BW = 5E-3 * pi;
% notch filter bandwidth

notch_omega_0 = 2 * pi * notch_F_0 / F_s;

cosine = cos(notch_BW);
notch_alpha = 1/cosine - sqrt(1/cosine^2 - 1);
clear cosine;

notch_beta = cos(notch_omega_0);

fprintf('Sinusoid frequency: F_0 = %.1f Hz\n', notch_F_0);
fprintf('Sinusoid frequency: omega_0 = %f * pi rad/sample\n', notch_omega_0/pi);
fprintf('Notch filter: alpha = %f\tbeta = %f\n', notch_alpha, notch_beta);

numBlockA = ((1+notch_alpha) / 2) * [1 -2*notch_beta 1];
denBlockA = [1 -notch_beta*(1+notch_alpha) notch_alpha];

[hBlockA, wBlockA] = freqz(numBlockA, denBlockA, 1E2);

figure;
subplot(2, 1, 1);
plot(wBlockA/pi, abs(hBlockA));
title('Block A amplitude response');
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Magnitude (Linear Scale)');
grid on;

subplot(2, 1, 2);
plot(wBlockA/pi, rad2deg(phase(hBlockA)));
title('Block A phase response');
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Phase (Degrees)');
grid on;

[~, index] = min(abs(wBlockA(:) - signal_bw * 2 * pi / F_s));
ripple1 = abs(hBlockA(index));

[~, index] = min(abs(wBlockA(:) - r2_lower_bound * 2 * pi / F_s));
ripple2 = abs(hBlockA(index));

clear wBlockA hBlockA;


%% BlockA output

r = filter(numBlockA, denBlockA, rs);

[frequency_range, R] = single_side_FFT(r, F_s);

figure;
stem(frequency_range, R, 'marker', 'none');
title('r[n] in frequency domain');
xlabel('Frequency (Hz)');
ylabel('Magnitude (Linear Scale)');
clear R;


%% BlockD Lowpass filter

Rp = 0.99 / ripple1;        % Passband ripple
Rp = -20 * log10(Rp);       % Passband ripple in decibels
Rs = 0.001;                 % stopband attenuation
Rs = -20 * log10(Rs);       % stopband attenuation in decibels

Wp = signal_bw;             % passband edge frequency (Hz)
Wp = 2 * Wp / F_s;          % normalized passband edge frequency (*pi)

Ws = Wp + 0.05;             % normalized stopband edge frequency (*pi)

[nBlockD, ~] = cheb1ord(Wp, Ws, Rp, Rs);
[numBlockD, denBlockD] = cheby1(nBlockD, Rp, Wp, 'low');

[hBlockD, wBlockD] = freqz(numBlockD, denBlockD);

figure;
subplot(2, 1, 1);
plot(wBlockD/pi, abs(hBlockD));
title('Block D amplitude response');
xlabel('Normalized Frequency (\times\pi rad/sample)');
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

[hH1, wH1] = freqz(conv(numBlockA, numBlockD), conv(denBlockA, denBlockD));

figure;
subplot(2, 1, 1);
plot(wH1/pi, abs(hH1));
title('H_1(z) amplitude response');
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Magnitude (Linear Scale)');
grid on;

subplot(2, 1, 2);
plot(wH1/pi, abs(hH1));
title('H_1(z) amplitude response (zoomed)');
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Magnitude (Linear Scale)');
grid on;
axis([0 1 0.95 1]);
hold on;
plot([0.25 0.25], [0.95 1], '--');
legend('H_1(z) response', 'r_1[n] bandwidth');
clear wH1 hH1;


%% BlockD output

s1 = filter(numBlockD, denBlockD, r);
clear numBlockD denBlockD;

[frequency_range, S1] = single_side_FFT(s1, F_s);

figure;
stem(frequency_range, S1, 'marker', 'none');
title('s_1[n] in frequency domain');
xlabel('Frequency (Hz)');
ylabel('Magnitude (Linear Scale)');
clear S1;


%% BlockB Highpass filter

Wp = r2_lower_bound * 2 / F_s;  % Passband corner frequency (* pi)
Ws = Wp - 0.05;                 % Stopband corner frequency (* pi)
Rp = 0.99 / ripple2;            % Passband ripple
Rp = -20 * log10(Rp);           % Passband ripple in decibels
Rs = 0.001;                     % Stopband attenuation
Rs = -20 * log10(Rs);           % Stopband attenuation in decibels

[nBlockB, Wn] = buttord(Wp, Ws, Rp, Rs);
[numBlockB, denBlockB] = butter(nBlockB, Wn, 'high');
clear Wn;

[hBlockB, wBlockB] = freqz(numBlockB, denBlockB);

figure;
subplot(2, 1, 1);
plot(wBlockB/pi, abs(hBlockB));
title('Block B amplitude response');
xlabel('Normalized Frequency (\times\pi rad/sample)');
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

[hH2, wH2] = freqz(conv(numBlockA, numBlockB), conv(denBlockA, denBlockB));
clear numBlockA denBlockA;

figure;
subplot(2, 1, 1);
plot(wH2/pi, abs(hH2));
title('H_2(z) amplitude response');
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Magnitude (Linear Scale)');
grid on;

subplot(2, 1, 2);
plot(wH2/pi, abs(hH2));
title('H_2(z) amplitude response (zoomed)');
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Magnitude (Linear Scale)');
grid on;
axis([0 1 0.95 1]);
hold on;
plot([0.5 0.5], [0.95 1], '--');
legend('H_2(z) response', 'DSB-SC lower bound');
clear wH2 hH2;


%% BlockB output

s2_tilde = filter(numBlockB, denBlockB, r);
clear numBlockB denBlockB;

[frequency_range, S2_tilde] = single_side_FFT(s2_tilde, F_s);

figure;
stem(frequency_range, S2_tilde, 'marker', 'none');
title('$\tilde{s}_2[n]$ in frequency domain', 'Interpreter', 'latex');
xlabel('Frequency (Hz)');
ylabel('Magnitude (Linear Scale)');

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

Rp = 0.99;              % peak-to-peak passband ripple
Rp = -20 * log10(Rp);   % decibels of peak-to-peak passband ripple
Rs = 0.001;             % stopband attenuation
Rs = -20 * log10(Rs);   % decibels of stopband attenuation down from the peak passband value

Wp = signal_bw;         % passband edge frequency (Hz)
Wp = 2 * Wp / F_s;      % normalized passband edge frequency (*pi)

Ws = Wp + 0.01;         % normalized stopband edge frequency (*pi)

[nBlockC, ~] = ellipord(Wp, Ws, Rp, Rs);
[numBlockC, denBlockC] = ellip(nBlockC, Rp, Rs, Wp, 'low');
clear Rp Rs Wp Ws;

[hBlockC, wBlockC] = freqz(numBlockC, denBlockC);

figure;
subplot(2, 1, 1);
plot(wBlockC/pi, abs(hBlockC));
title('Block C amplitude response');
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Magnitude (Linear Scale)');
grid on;

subplot(2, 1, 2);
plot(wBlockC/pi, abs(hBlockC));
title('Block C amplitude response (zoomed)');
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Magnitude (Linear Scale)');
grid on;
axis([0 1 0.95 1]);
hold on;
plot([0.25 0.25], [0.95 1], '--', 'linewidth', 1.5);
legend('amplitude response', 'original signal bandwidth');
clear wBlockC hBlockC;


%% BlockC output

s2 = filter(numBlockC, denBlockC, y);
clear numBlockC denBlockC;

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
