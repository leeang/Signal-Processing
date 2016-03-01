clear;
close all;
load('lowpass_filter_numerator');

%% test signal

fs = 24E3;          % sampling frequency
f0 = [200 1000];    % test signal frequencies
N_x = 360;          % test signal length

time_vector = (0:N_x-1) / fs;

x_martrix = zeros(length(f0), N_x);

for index=1:length(f0)
    x_martrix(index,:) = sin(2 * pi * f0(index) * time_vector);
end
clear index;

x = sum(x_martrix, 1);

%% filter

output = filter(numerator, 1, x);

plot(time_vector, x);
hold on;
plot(time_vector, output);
xlabel('Time (s)');
ylabel('Magnitude (linear scale)');
legend('input', 'output');
grid on;

len = length(output);

for i = 1:len
    fprintf('%f\t', output(i));
end
fprintf('\n');
