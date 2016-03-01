% bw    3dB bandwidth in Hz
% F_s   sampling frequency in Hz
% f_0   notch frequency in Hz

function [alpha, beta] = A5_function(bw, F_s, f_0)
    omega0 = f_0 * 2 * pi / F_s;
    beta = cos(omega0);

    bw = bw * 2 * pi / F_s;

    cosine = cos(bw);
    alpha = 1/cosine - sqrt(1/cosine^2 - 1);
end
