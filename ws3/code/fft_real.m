clear;
close all;

x = randn(1, 16);

N = length(x) / 2;
index = 1:N;

x_o = x(index*2-1);     % odd index
x_e = x(index*2);       % even index

z = x_o + 1j * x_e;

Z = fft(z);

% Z1 = conj(Z[N-k])
Z1 = fliplr(Z);
Z1 = circshift(Z1, 1, 2);
Z1 = conj(Z1);

X_o = 0.5 * (Z + Z1);
X_e = -0.5j * (Z - Z1);

W = exp(-1j * pi / N) .^ (index-1);

X(index) = X_o + X_e .* W;
X(index+N) = X_o - X_e .* W;

if any(abs(fft(x) - X) > eps('single'))
    warning('fft() result and fft_real() result are inconsistent.');
end
