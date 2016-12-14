clear;

load('data1');

is_noisy = false;
% true (noisy) or false (noise-free)

export_fig = false;
% print plots

% parameters
lambda = 1;
rho = 3;

P = rho * eye(2);

% inputs
mike = mike1;
if (is_noisy)
	mike = noisymike1;
end

noise_string = 'noise-free';
if (is_noisy)
	noise_string = 'noisy';
end

% sampling frequency
fs = 8192;

% data length
L = length(mike);

% echo cancellation result
output = zeros(L, 1);

% echo cancellation result
output = zeros(L, 1);

k1 = 1 * fs;
k2 = 2.5 * fs;

theta = zeros(2, 1);
weight1 = zeros(L, 1);
weight2 = zeros(L, 1);

tic;
for k = 1:L
	if k <= k1
		phi = [0; 0];
	elseif k <= k2
		phi = [output(k-k1); 0];
	else
		phi = [output(k-k1); output(k-k2)];
	end

	P = (P - P * phi * transpose(phi) * P / ( lambda + transpose(phi) * P * phi )) / lambda;

	err = mike(k) - transpose(theta) * phi;

	theta = theta + P * phi * err;

	output(k) = mike(k) - transpose(theta) * phi;

	weight1(k) = theta(1);
	weight2(k) = theta(2);
end
toc;

fprintf('lambda = %f\n', lambda);
fprintf('rho = %f\n', rho);
fprintf('norm(err) = %f\n', norm(output - loudspeaker));

filename_prefix = 'd-rls-';

fig = figure;
fig.PaperPosition = [0 0 5 3.75];
plot(weight1);
hold on;
plot(weight2);
hold off;
title(['1(d) RLS $\theta$', ' (', noise_string, ')'], 'interpreter', 'latex');
legend(['\theta_{1}'], ['\theta_{2}'], 'Location', 'southeast');
ylim([0 0.8]);
hold on;
plot(L, weight1(L), 'kx');
plot(L, weight2(L), 'kx');
text(0.9 * L, weight1(L) + 0.03, num2str(weight1(L)));
text(0.9 * L, weight2(L) + 0.03, num2str(weight2(L)));
if export_fig
	print([filename_prefix 'theta-', noise_string], '-dpng', '-r300');
end

fig = figure;
fig.PaperPosition = [0 0 5 3.75];
subplot(2, 1, 1);
plot(loudspeaker);
title(['1(d) \texttt{loudspeaker}'], 'interpreter', 'latex');
ylim([-1 1]);
subplot(2, 1, 2);
plot(mike);
if (is_noisy)
	title('\texttt{noisymike1}', 'interpreter', 'latex');
else
	title('\texttt{mike1}', 'interpreter', 'latex');
end
ylim([-1 1]);
if export_fig
	print([filename_prefix 'input-', noise_string], '-dpng', '-r300');
end

fig = figure;
fig.PaperPosition = [0 0 5 3.75];
subplot(2, 1, 1);
plot(output);
title(['1(d) \texttt{output}'], 'interpreter', 'latex');
ylim([-1 1]);
subplot(2, 1, 2);
plot(output - loudspeaker);
title('\texttt{output - loudspeaker}', 'interpreter', 'latex');
ylim([-1 1]);
if export_fig
	print([filename_prefix 'output-', noise_string], '-dpng', '-r300');
end

if export_fig
	close all;
end
