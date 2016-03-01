clear;

omega_max = 0.165;
F_s = 4.8;
omega_2 = 1.9 * pi / F_s;

syms unknown;
assume(-1<unknown<1);
eqn = abs(1 - unknown) / sqrt(2) * sqrt(1 + cos(omega_max)) / sqrt(1 + unknown^2 - 2 * unknown * cos(omega_max)) == 0.95;
result = solve(eqn, unknown);
alpha_1st = double(result);

syms unknown;
assume(-1<unknown<1);
eqn = (1 - unknown)^2 / 2 * (1 + cos(omega_max)) / (1 + unknown^2 - 2 * unknown * cos(omega_max)) == 0.95;
result = solve(eqn, unknown);
alpha_2nd = double(result);

gain_1st = abs(1 - alpha_1st) / sqrt(2) * sqrt(1 + cos(omega_2)) / sqrt(1 + alpha_1st^2 - 2 * alpha_1st * cos(omega_2));
gain_2nd = (1 - alpha_2nd)^2 / 2 * (1 + cos(omega_2)) / (1 + alpha_2nd^2 - 2 * alpha_2nd * cos(omega_2));

fprintf('1st order alpha = %f\n', alpha_1st);
fprintf('2nd order alpha = %f\n', alpha_2nd);

fprintf('1st order gain at omega_2 = %f > 0.25\n', gain_1st);
fprintf('2nd order gain at omega_2 = %f < 0.25\n', gain_2nd);
