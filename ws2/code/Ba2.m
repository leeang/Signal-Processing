clear;

[x, fs] = audioread('speech.wav');
timestamp = clock;
sound(x, fs);
disp('Playing original signal');

D = 1760;
alpha = 0.75;

num = zeros(1, D+1);
num(1) = 1;
num(D+1) = alpha;

den = 1;

figure;
impz(num, den, 2000);
title('Impulse Response of H_1(z^D) (\alpha=0.75)');

outputA2 = filter(num, den, x);

% wait for the sound to finish
time = length(x)/fs - etime(clock, timestamp);
if (time > 0)
    pause(time);
end

sound(outputA2, fs);
disp('Playing signal generated in a) (ii)');
