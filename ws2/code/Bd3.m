clear;

[x, fs] = audioread('speech.wav');
timestamp = clock;
sound(x, fs);

D1 = 50E-3;	% 50ms
D2 = 40E-3;	% 40ms
D3 = 32E-3;	% 32ms

D = [D1 D2 D3];
D = D * fs;

for i=1:3
    fprintf('D%d = %d ', i, D(i));
    D(i) = max(primes( D(i)*2 - max(primes(D(i))) ));
    % round the delays in samples to the nearest prime number
    fprintf('~= %d\n', D(i));
end

alpha1 = 0.7;
alpha2 = 0.665;
alpha3 = 0.63175;

[num, den] = Bd_function(D, [alpha1 alpha2 alpha3]);

[h,t] = impz(num, den, 8E3);
figure;
stem(t, h, 'filled', 'LineStyle', ':');
xlabel('n (samples)');
ylabel('Amplitude');
title('Speech Reverberator Impulse Response');

output = filter(num, den, x);

% wait for the sound to finish
time = length(x)/fs - etime(clock, timestamp);
if (time > 0)
    pause(time);
end

sound(output, fs);
