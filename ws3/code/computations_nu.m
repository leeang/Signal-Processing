clear;
close all;

M = 47;
nu = 1:20;

mlt1 = 2.^nu .* (nu + 1);
c_mlt1 = mlt1 ./ (2.^nu - M + 1);

mlt2 = 2.^nu .* (nu/2 + 1) + 1;
c_mlt2 = mlt2 ./ (2.^nu - M + 1);

stem(nu, c_mlt1);
hold on;
stem(nu, c_mlt2);
title(['Relationship between c(\nu) and \nu  M = ' num2str(M)]);
xlabel('\nu');
ylabel('computations per output point');
legend('general', 'symmetric');

%% min

nu_0 = 9;
c_mlt = c_mlt2(nu_0);
c_add = 2^nu_0 * (nu_0 + 2.5)/ (2^nu_0 - M + 1);

F_s = 24E3;

multiplications = c_mlt * F_s;
additions = c_add * F_s;

fprintf('%.0f multiplications per second\n', multiplications);
fprintf('%.0f additions per second\n', additions);

%% formula

% mlt1 = (radix2_computations(N/2, 'm') + N/2) * 2 + N/2 + 1;
% mlt2 = N/2 .* log2(N) + N + 1;
% mlt3 = 2.^nu .* (nu/2 + 1) + 1;
% 
% add1 = radix2_computations(N/2, 'a') + 2*N + radix2_computations(N/2, 'a') + 1.5*N;
% add2 = N.*log2(N) + 2.5*N;
% add3 = 2.^nu .* (nu + 2.5);
