clear;
close all;

D = 8;
alpha = 0.75;

num = zeros(1, D+1);
num(1) = 1;
num(D+1) = alpha;

den = 1;

figure;
zplane(num, den);
title('Zeros of H(z^8) \alpha = 0.75');

figure;
impz(num, den, 20);
title('Impulse response of H(z^8) (\alpha = 0.75)');

figure;
freqz(num, den, 'whole');
title('Response on the interval [0, 2\pi] (\alpha = 0.75)');
