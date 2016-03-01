clear;
close all;

% Reverberator 1
D1 = 50;
D2 = 40;
D3 = 32;

alpha1 = 0.7;
alpha2 = 0.665;
alpha3 = 0.63175;

[num, den] = Bd_function([D1 D2 D3], [alpha1 alpha2 alpha3]);

[h,t] = impz(num, den, 1000);
figure;
stem(t, h, 'filled', 'LineStyle', ':');
xlabel('n (samples)');
ylabel('Amplitude');
title('Reverberator 1 impulse response');

% Reverberator 2
D1 = 50;
D2 = 17;
D3 = 6;

alpha1 = 0.7;
alpha2 = 0.77;
alpha3 = 0.847;

[num, den] = Bd_function([D1 D2 D3], [alpha1 alpha2 alpha3]);

[h,t] = impz(num, den, 1000);
figure;
stem(t, h, 'filled', 'LineStyle', ':');
xlabel('n (samples)');
ylabel('Amplitude');
title('Reverberator 2 impulse response');
