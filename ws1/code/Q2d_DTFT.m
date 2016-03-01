clear;
close all;

a = 0.12;
Omega_1 = 0.25 * pi;
T = 1 / 4.8;

Omega = -pi:0.005:pi;

num = [1 -exp(-a*T)*cos(Omega_1*T) 0];
den = [1 -2*exp(-a*T)*cos(Omega_1*T) exp(-2*a*T)];
h = freqz(num, den, Omega);

plot(Omega, abs(h));

title('X_1(e^{j\omega})');
xlabel('\omega (rad/sample)');
ylabel('X_1(e^{j\omega})');
