clear;
close all;

a = 0.12;
Omega_1 = 0.25 * pi;
Omega_2 = 1.9 * pi;
F_1 = 1.2;
F_2 = 4.8;

sample = 0:255;
N = length(sample);

T_1 = 1 / F_1;
T_2 = 1 / F_2;

t_1 = T_1 * sample;
x_1 = exp(-a * t_1) .* cos(Omega_1 * t_1) + 0.1 * sin(Omega_2 * t_1);

t_2 = T_2 * sample;
x_2 = exp(-a * t_2) .* cos(Omega_1 * t_2) + 0.1 * sin(Omega_2 * t_2);

X_1 = fft(x_1);
X_1 = fftshift(X_1);
X_1 = X_1(N/2+1:N);
X_1 = abs(X_1);
f = (N/2:N-1) * F_1 / N - F_1 / 2;
plot(f, X_1);
xlabel('Frequency (Hz)');
ylabel('FFT(x[n])');
title('FFT(x[n]) F_1 = 1.2Hz');

% peaks
pos = find(diff(sign(diff(X_1)))<0) + 1;
for index=pos
	text(f(index) + 0.02 * max(f), X_1(index), ['f = ' num2str(f(index)) ' Hz']);
end
hold on;
plot(f(pos), X_1(pos), 'x');

X_2 = fft(x_2);
X_2 = fftshift(X_2);
X_2 = X_2(N/2+1:N);
X_2 = abs(X_2);
f = (N/2:N-1) * F_2 / N - F_2 / 2;
figure;
plot(f, X_2);
xlabel('Frequency (Hz)');
ylabel('FFT(x[n])');
title('FFT(x[n]) F_2 = 4.8Hz');

% peaks
pos = find(diff(sign(diff(X_2)))<0) + 1;
for index=pos
	text(f(index) + 0.02 * max(f), X_2(index), ['f = ' num2str(f(index)) ' Hz']);
end
hold on;
plot(f(pos), X_2(pos), 'x');
