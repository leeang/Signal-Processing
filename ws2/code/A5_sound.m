clear;

load('testsignal');
t1 = clock;
sound(y);
% at the default sample rate of 8192 hertz

bw = 30;
F_s = 8192;
f_0 = 550;

[alpha, beta] = A5_function(bw, F_s, f_0);

fprintf('alpha=%f\n', alpha);
fprintf('beta=%f\n', beta);

num = ((1+alpha) / 2) * [1 -2*beta 1];
den = [1 -beta*(1+alpha) alpha];
output = filter(num, den, y);

% wait for the sound to finish
time = length(y)/F_s - etime(clock, t1);
if (time > 0)
    pause(time);
end

sound(output);
