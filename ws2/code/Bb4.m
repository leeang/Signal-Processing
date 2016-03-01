clear;

[x, fs] = audioread('speech.wav');
timestamp = clock;
sound(x, fs);

D = 1760;
alpha = 1.05;

den = zeros(1, D+1);
den(1) = 1;
den(D+1) = alpha;

num = 1;

figure;
impz(num, den, 1E5);
title('Impulse Response of H_2(z^D) (\alpha=1.05)');

output = filter(num, den, x);

% wait for the sound to finish
time = length(x)/fs - etime(clock, timestamp);
if (time > 0)
    pause(time);
end

sound(output, fs);
