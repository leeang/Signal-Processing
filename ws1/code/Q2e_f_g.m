clear;
close all;

a = 0.12;
Omega_1 = 0.25 * pi;
Omega_2 = 1.9 * pi;
F_s = 4.8;
F_s_12Hz = 1.2;
alpha_1st = 0.597991;
alpha_2nd = 0.470126;

sample = 0:255;
N = length(sample);

t = 1 / F_s * sample;
x_2 = 0.1 * sin(Omega_2 * t);
x = exp(-a * t) .* cos(Omega_1 * t) + x_2;

t_12Hz = 1 / F_s_12Hz * sample;
x_12Hz = exp(-a * t_12Hz) .* cos(Omega_1 * t_12Hz) + 0.1 * sin(Omega_2 * t_12Hz);

y_1st = zeros(1, N);
y_2nd_intermediate = zeros(1, N);
y_2nd = zeros(1, N);
y_2_1st = zeros(1, N);
y_2_2nd_intermediate = zeros(1, N);
y_2_2nd = zeros(1, N);

y_1st(1) = (1 - alpha_1st) / 2 * x(1);
for index = 2:N
    y_1st(index) = (1 - alpha_1st) / 2 * (x(index) + x(index-1)) + alpha_1st * y_1st(index-1);
end

y_2nd_intermediate(1) = (1 - alpha_2nd) / 2 * x(1);
for index = 2:N
    y_2nd_intermediate(index) = (1 - alpha_2nd) / 2 * (x(index) + x(index-1)) + alpha_2nd * y_2nd_intermediate(index-1);
end
y_2nd(1) = (1 - alpha_2nd) / 2 * y_2nd_intermediate(1);
for index = 2:N
    y_2nd(index) = (1 - alpha_2nd) / 2 * (y_2nd_intermediate(index) + y_2nd_intermediate(index-1)) + alpha_2nd * y_2nd(index-1);
end


y_2_1st(1) = (1 - alpha_1st) / 2 * x_2(1);
for index = 2:N
    y_2_1st(index) = (1 - alpha_1st) / 2 * (x_2(index) + x_2(index-1)) + alpha_1st * y_2_1st(index-1);
end

y_2_2nd_intermediate(1) = (1 - alpha_2nd) / 2 * x_2(1);
for index = 2:N
    y_2_2nd_intermediate(index) = (1 - alpha_2nd) / 2 * (x_2(index) + x_2(index-1)) + alpha_2nd * y_2_2nd_intermediate(index-1);
end
y_2_2nd(1) = (1 - alpha_2nd) / 2 * y_2_2nd_intermediate(1);
for index = 2:N
    y_2_2nd(index) = (1 - alpha_2nd) / 2 * (y_2_2nd_intermediate(index) + y_2_2nd_intermediate(index-1)) + alpha_2nd * y_2_2nd(index-1);
end

y_ds = y_2nd(1:4:N);

X = fft(x);
X = fftshift(X);
X = X(N/2+1:N);
X = abs(X);

Y_1st = fft(y_1st);
Y_1st = fftshift(Y_1st);
Y_1st = Y_1st(N/2+1:N);
Y_1st = abs(Y_1st);

Y_2nd = fft(y_2nd);
Y_2nd = fftshift(Y_2nd);
Y_2nd = Y_2nd(N/2+1:N);
Y_2nd = abs(Y_2nd);

N_ds = N / 4;
Y_ds = fft(y_ds);
Y_ds = fftshift(Y_ds);
Y_ds = Y_ds(N_ds/2+1:N_ds);
Y_ds = abs(Y_ds);

X_12Hz = fft(x_12Hz);
X_12Hz = fftshift(X_12Hz);
X_12Hz = X_12Hz(N/2+1:N);
X_12Hz = abs(X_12Hz);


f = (N/2:N-1) * F_s / N - F_s / 2;

F_s_ds = F_s/4;
f_ds = (N_ds/2:N_ds-1) * F_s_ds / N_ds - F_s_ds / 2;

f_12Hz = (N/2:N-1) * F_s_12Hz / N - F_s_12Hz / 2;

% (e) time domain
plot(t, x);
hold on;
plot(t, y_1st);
hold on;
plot(t, y_2nd);
xlabel('Time (s)');
ylabel('Magnitude');
title('x[n] and filtered x[n]');
legend('x[n]', '1st order filtered x[n]', '2nd order filtered x[n]');
axis([0 35 -0.8 1.2]);
set (gcf, 'Position', [500 500 1000 420]);

% (e) frequency domain
figure;
plot(f, X);
hold on;
plot(f, Y_1st);
hold on;
plot(f, Y_2nd);
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('FFT of x[n] and filtered x[n]');
legend('x[n]', '1st order filtered x[n]', '2nd order filtered x[n]');
set (gcf, 'Position', [500 500 1000 420]);

% (f) x2[n] - time domain
figure;
plot(t, x_2);
hold on;
plot(t, y_2_1st);
hold on;
plot(t, y_2_2nd);
xlabel('Time (s)');
ylabel('Magnitude');
title('x_2[n] and filtered x_2[n]');
legend('x_2[n]', '1st order filtered x_2[n]', '2nd order filtered x_2[n]');
axis([0 10 -0.1 0.1]);
set (gcf, 'Position', [500 500 1000 420]);

% (g) down sample and sampling frequency = 1.2Hz - time domain
figure;
plot(t(4:4:N), y_ds);
hold on;
plot(t_12Hz, x_12Hz);
xlabel('Time (s)');
ylabel('x[n]');
title('Down sample and F_s = 1.2Hz outputs');
legend('Down Sample', 'F_s = 1.2Hz');
axis([0 50 -0.8 1.2]);

% (g) down sample and sampling frequency = 1.2Hz - frequency domain
figure;
plot(f_ds, Y_ds);
hold on;
plot(f_12Hz, X_12Hz);
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('FFT of down sample and F_s = 1.2Hz outputs');
legend('Down Sample', 'F_s = 1.2Hz');
