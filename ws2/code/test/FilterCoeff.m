clear;
close all;

omega0 = 550 * 2 * pi / 24E3;
beta = cos(omega0);

fprintf('beta=%f\n', beta);


for bw = [0.1 0.01 0.0025]
    cosine = cos(bw * pi);
    alpha = 0.5 * (2/cosine - sqrt(4/cosine^2 -4));

    fprintf('alpha=%f (Bw = %.4fpi)\n', alpha, bw);

    num = ((1+alpha) / 2) * [1 -2*beta 1];
    den = [1 -beta*(1+alpha) alpha];
end
