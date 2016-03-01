clear;
close all;

omega0 = 330 * 2 * pi / 44.1E3;
beta = cos(omega0);


for bw = [0.1 0.01 0.005]
    cosine = cos(bw * pi);
    alpha = 1/cosine - sqrt(1/cosine^2 - 1);

    fprintf('alpha=%f (Bw = %.3fpi)\n', alpha, bw);

    num = ((1+alpha) / 2) * [1 -2*beta 1];
    den = [1 -beta*(1+alpha) alpha];

    figure;
    zplane(num, den);
    title(sprintf('Pole/zero map (B_w= %.3f * pi)', bw));

    figure;
    freqz(num, den);
    title(sprintf('Magnitude and phase response (B_w = %.3f * pi)', bw));
end
