clear;

[x, fs] = audioread('speech.wav');
t1 = clock;
sound(x, fs);

D = 1760;
alpha = 0.75;

num = zeros(1, D+1);
num(1) = -alpha;
num(D+1) = 1;

den = zeros(1, D+1);
den(1) = 1;
den(D+1) = -alpha;

figure;
impz(num, den, 30000);
title('Impulse Response of H_3(z^D) (\alpha=0.75)');

output = filter(num, den, x);

% wait for the sound to finish
time = length(x)/fs - etime(clock, t1);
if (time > 0)
    pause(time);
end

sound(output, fs);
