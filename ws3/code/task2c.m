clear;
close all;

N = 16;
symmetry_axis = N/2;
n = 0:N-1;

x = randn(1, N);
X = fft(x);

output1 = ifft(X);
output2 = ifftcs(X);

figure;
subplot(2,1,1);
stem(n, abs(X), 'marker', 'x');
title('$|X[k]|$', 'Interpreter', 'latex');
xlabel('k');
ylabel('(linear scale)');
hold on;
plot([symmetry_axis symmetry_axis], [0 max(abs(X))], '-.');
subplot(2,1,2);
stem(n, rad2deg(angle(X)), 'marker', 'x');
title('$\angle X[k]$', 'Interpreter', 'latex');
xlabel('k');
ylabel('(degrees)');

figure;
subplot(2,1,1);
stem(n, output1, 'marker', 'x');
title('\texttt{ifft(X)} result', 'Interpreter', 'latex');
xlabel('k');
ylabel('Magnitude (linear scale)');
subplot(2,1,2);
stem(n, output2, 'marker', 'x');
title('\texttt{ifftcs(X)} result', 'Interpreter', 'latex');
xlabel('k');
ylabel('Magnitude (linear scale)');
