clear;
close all;

N = 2048;
F_s = 4.8;

t = 0:1/F_s:1/F_s*(N-1);

F = 0.25 * pi / 2 / pi;
x = exp(-0.12 * t) .* cos(2 * pi * F * t);

X = fft(x);
X = fftshift(X);

X = X(N/2+1:N);
X = abs(X);
f = (N/2:N-1) * F_s / N - F_s / 2;
plot(f, X);
title('FFT(x_1[n])');
xlabel('Frequency (Hz)');
ylabel('FFT(x_1[n])');

% peaks
pos = find(diff(sign(diff(X)))<0) + 1;
for index=pos
	text(f(index) + 0.02 * max(f), X(index), ['f = ' num2str(f(index)) ' Hz']);
end
hold on;
plot(f(pos), X(pos), 'x');
