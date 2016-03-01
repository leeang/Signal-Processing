clear;
close all;

D = 8;
alpha = 0.75;

num = zeros(1, D+1);
num(1) = -alpha;
num(D+1) = 1;

den = zeros(1, D+1);
den(1) = 1;
den(D+1) = -alpha;

figure;
impz(num, den, 60);
title('Impulse response of H(z^8) (\alpha = 0.75)');

figure;
freqz(num, den, 'whole');
title('Response on the interval [0, 2\pi] (\alpha = 0.75)');
