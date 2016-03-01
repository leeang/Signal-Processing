%% Question a
clear;
close all;
t = 0:0.01:30;
Omega_1 = 0.25 * pi;

a = 0.12;
x_c = exp(-a * t) .* cos(Omega_1 * t);
figure;
plot(t, x_c);

a = 0.3;
x_c = exp(-a * t) .* cos(Omega_1 * t);
hold on;
plot(t, x_c);

a = 0.5;
x_c = exp(-a * t) .* cos(Omega_1 * t);
hold on;
plot(t, x_c);

xlabel('t (s)');
ylabel('x_c(t)');
title('x_c(t) in time domain for \Omega_1=0.25\pi and various a');
legend('a=0.12', 'a=0.3', 'a=0.5');

clear;
Omega = -3:0.01:3;
Omega_1 = 0.25 * pi;

a = 0.12;
X_c = (a + 1j * Omega) ./ ( (a + 1j * Omega).^2 + Omega_1^2 );
X_c = abs(X_c);
figure;
plot(Omega, X_c);

a = 0.3;
X_c = (a + 1j * Omega) ./ ( (a + 1j * Omega).^2 + Omega_1^2 );
X_c = abs(X_c);
hold on;
plot(Omega, X_c);

a = 0.5;
X_c = (a + 1j * Omega) ./ ( (a + 1j * Omega).^2 + Omega_1^2 );
X_c = abs(X_c);
hold on;
plot(Omega, X_c);

xlabel('\Omega (rad/s)');
ylabel('X_c(\Omega)');
title('X_c(\Omega) in frequency domain for \Omega_1=0.25\pi and various a');
legend('a=0.12', 'a=0.3', 'a=0.5');

clear;
t = 0:0.01:30;
a = 0.12;

Omega_1 = 0.1 * pi;
x_c = exp(-a * t) .* cos(Omega_1 * t);
figure;
plot(t, x_c);

Omega_1 = 0.25 * pi;
x_c = exp(-a * t) .* cos(Omega_1 * t);
hold on;
plot(t, x_c);

Omega_1 = 0.6 * pi;
x_c = exp(-a * t) .* cos(Omega_1 * t);
hold on;
plot(t, x_c);

xlabel('t (s)');
ylabel('x_c(t)');
title('x_c(t) in time domain for a=0.12 and various \Omega_1');
legend('\Omega_1=0.1\pi', '\Omega_1=0.25\pi', '\Omega_1=0.6\pi');

clear;
Omega = -3:0.01:3;
a = 0.12;

Omega_1 = 0.1 * pi;
X_c = (a + 1j * Omega) ./ ( (a + 1j * Omega).^2 + Omega_1^2 );
X_c = abs(X_c);
figure;
plot(Omega, X_c);

Omega_1 = 0.25 * pi;
X_c = (a + 1j * Omega) ./ ( (a + 1j * Omega).^2 + Omega_1^2 );
X_c = abs(X_c);
hold on;
plot(Omega, X_c);

Omega_1 = 0.6 * pi;
X_c = (a + 1j * Omega) ./ ( (a + 1j * Omega).^2 + Omega_1^2 );
X_c = abs(X_c);
hold on;
plot(Omega, X_c);

xlabel('\Omega (rad/s)');
ylabel('X_c(\Omega)');
title('X_c(\Omega) in frequency domain for a=0.12 and various \Omega_1');
legend('\Omega_1=0.1\pi', '\Omega_1=0.25\pi', '\Omega_1=0.6\pi');
