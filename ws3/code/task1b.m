clear;
close all;

N = 16;
n = 0:N-1;

input = complex(randn(1, N), randn(1, N));

output = ifft(input);
outputA = iffta(input);
outputB = ifftb(input);

magnitude0 = abs(output);
magnitudeA = abs(outputA);
magnitudeB = abs(outputB);

phase0 = angle(output);
phaseA = angle(outputA);
phaseB = angle(outputB);

subplot(2, 3, 1);
stem(n, magnitude0, 'marker', 'x');
title('\texttt{|ifft(X)|}', 'Interpreter', 'latex');
ylabel('(linear scale)');
grid on;

subplot(2, 3, 2);
stem(n, magnitudeA, 'marker', 'x');
title('\texttt{|iffta(X)|}', 'Interpreter', 'latex');
ylabel('(linear scale)');
grid on;

subplot(2, 3, 3);
stem(n, magnitudeB, 'marker', 'x');
title('\texttt{|ifftb(X)|}', 'Interpreter', 'latex');
ylabel('(linear scale)');
grid on;

subplot(2, 3, 4);
stem(n, phase0, 'marker', 'x');
title('\angle \texttt{ifft(X)}', 'Interpreter', 'latex');
ylabel('(rad)');
grid on;

subplot(2, 3, 5);
stem(n, phaseA, 'marker', 'x');
title('\angle \texttt{iffta(X)}', 'Interpreter', 'latex');
ylabel('(rad)');
grid on;

subplot(2, 3, 6);
stem(n, phaseB, 'marker', 'x');
title('\angle \texttt{ifftb(X)}', 'Interpreter', 'latex');
ylabel('(rad)');
grid on;

set (gcf, 'Position', [200 200 1000 420]);
