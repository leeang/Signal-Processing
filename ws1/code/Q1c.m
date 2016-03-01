clear;
close all;

a = 0.12;
Omega_1 = 0.25 * pi;
T = 1 / 4.8;

Omega = -pi:0.005:pi;

X_c = (a + 1j * Omega) ./ ( (a + 1j * Omega).^2 + Omega_1^2 );
X_c = abs(X_c);

figure;
plot(Omega, X_c, 'LineWidth', 2);

num = [1 -exp(-a*T)*cos(Omega_1*T) 0];
den = [1 -2*exp(-a*T)*cos(Omega_1*T) exp(-2*a*T)];
h = freqz(num, den, Omega);

hold on;
plot(Omega/T, T*abs(h), 'x');

title('X_c(j\Omega) and X_c(e^{j\omega})');
xlabel('\Omega and \omega/T (rad/s)');
ylabel('X_c(j\Omega) and X_c(e^{j\omega})');
legend('X_c(j\Omega)', 'X_c(e^{j\omega})');
