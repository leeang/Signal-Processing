clear;
close all;

a = 0.12;
Omega_1 = 0.25 * pi;
Omega_2 = 1.9 * pi;
F_1 = 1.2;
F_2 = 4.8;

sample = 0:255;

T_1 = 1 / F_1;
T_2 = 1 / F_2;

t_1 = T_1 * sample;
x_1 = exp(-a * t_1) .* cos(Omega_1 * t_1) + 0.1 * sin(Omega_2 * t_1);

t_2 = T_2 * sample;
x_2 = exp(-a * t_2) .* cos(Omega_1 * t_2) + 0.1 * sin(Omega_2 * t_2);

omega = 0:0.01:pi;
L = length(omega);

X_1 = zeros(1, L);
X_2 = zeros(1, L);
for index = 1:L
	X_1(index) = x_1 * exp(-1j * omega(index) * sample');
	X_2(index) = x_2 * exp(-1j * omega(index) * sample');
end

frequency = omega /2 /pi;
plot(frequency * F_1, abs(X_1));
xlabel('Frequency (Hz)');
title('x[n] DTFT F_1 = 1.2Hz');

figure;
plot(frequency * F_2, abs(X_2));
xlabel('Frequency (Hz)');
title('x[n] DTFT F_2 = 4.8Hz');
