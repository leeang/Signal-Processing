clear;
close all;

a = 0.12;
Omega_1 = 0.25 * pi;
Omega_2 = 1.9 * pi;
F_1 = 1.2;
F_2 = 4.8;

sample = 0:255;

T_1 = 1 / F_1;
T_2 = 1 / F_2;

t_1 = T_1 * sample;
x_1 = exp(-a * t_1) .* cos(Omega_1 * t_1) + 0.1 * sin(Omega_2 * t_1);

t_2 = T_2 * sample;
x_2 = exp(-a * t_2) .* cos(Omega_1 * t_2) + 0.1 * sin(Omega_2 * t_2);

plot(t_1, x_1);
hold on;
plot(t_2, x_2);
xlabel('Time (s)');
ylabel('x[n]');
title('x[n]');
legend('F_1 = 1.2 Hz', 'F_2 = 4.8 Hz');
axis([0 60 -0.8 1.2]);
set (gcf, 'Position', [500 500 1000 420]);
