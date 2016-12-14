clear;

load('data1');
load('data2');

question = 'a';
% 'a', 'b' or 'c'

is_noisy = false;
% true (noisy) or false (noise-free)

export_fig = false;
% print plots

% parameters
switch question
	case 'a'
		lambda = 0.999;
		rho = 1000;

		if (is_noisy)
			rho = 0.1;
		end

	case 'b'
		lambda = 0.999;
		rho = 1000;

		if (is_noisy)
			rho = 0.6;
		end

	case 'c'
		lambda = 0.999;
		rho = 100;

		if (is_noisy)
			rho = 0.001;
		end
end

% inputs
switch question
	case 'a'
		mike = mike1;
		if (is_noisy)
			mike = noisymike1;
		end
		side = 0;
		% known delay

	case 'b'
		mike = mike2;
		if (is_noisy)
			mike = noisymike2;
		end
		side = 0;
		% known delay

	case 'c'
		mike = mike2;
		if (is_noisy)
			mike = noisymike2;
		end
		side = 8;
		% 8192Hz * 0.001s = 8
end

P = rho * eye(2+4*side);

% the signal played by loudspeaker
u = loudspeaker;

noise_string = 'noise-free';
if (is_noisy)
	noise_string = 'noisy';
end

y = mike - loudspeaker;

% sampling frequency
fs = 8192;

% data length
L = length(u);

% echo cancellation result
err = zeros(L, 1);

% echo cancellation result
output = zeros(L, 1);

k1 = 1 * fs;
k2 = 2.5 * fs;

k1_first = k1 - side;
k1_last = k1 + side;

k2_first = k2 - side;
k2_last = k2 + side;

theta = zeros(2+4*side, 1);
weight1 = zeros(L, 1);
weight2 = zeros(L, 1);

tic;
for k = 1:L
	if k <= k1_first
		phi = [zeros(side*2+1, 1); zeros(side*2+1, 1)];
	elseif k <= k1_last
		phi = [zeros(k1_last-k+1, 1); u(1:k-k1_first); zeros(side*2+1, 1)];
	elseif k <= k2_first
		phi = [u(k-k1_last:k-k1_first); zeros(side*2+1, 1)];
	elseif k <= k2_last
		phi = [u(k-k1_last:k-k1_first); zeros(k2_last-k+1, 1); u(1:k-k2_first)];
	else
		phi = [u(k-k1_last:k-k1_first); u(k-k2_last:k-k2_first)];
	end

	P = (P - P * phi * transpose(phi) * P / ( lambda + transpose(phi) * P * phi )) / lambda;

	product = transpose(theta) * phi;
	err(k) = y(k) - product;
	output(k) = mike(k) - product;

	theta = theta + P * phi * err(k);

	weight1(k) = theta(side+1);
	weight2(k) = theta(side*2+1+side+1);
end
toc;

fprintf('lambda = %f\n', lambda);
fprintf('rho = %f\n', rho);
fprintf('norm(err) = %f\n', norm(err));

filename_prefix = [question '-rls-'];

fig = figure;
fig.PaperPosition = [0 0 5 3.75];
plot(weight1);
hold on;
plot(weight2);
hold off;
title(['1(', question, ') RLS $\theta$', ' (', noise_string, ')'], 'interpreter', 'latex');
xlabel(['$\lambda$ = ' num2str(lambda) ' $\rho$ = ' num2str(rho)], 'interpreter', 'latex');
legend(['\theta_{' num2str(side+1) '}'], ['\theta_{' num2str(side*2+1+side+1) '}'], 'Location', 'southeast');
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
title(['1(', question, ') \texttt{loudspeaker}'], 'interpreter', 'latex');
ylim([-1 1]);
subplot(2, 1, 2);
plot(mike);
if (is_noisy)
	title('\texttt{noisymike}', 'interpreter', 'latex');
else
	title('\texttt{mike}', 'interpreter', 'latex');
end
ylim([-1 1]);
if export_fig
	print([filename_prefix 'input-', noise_string], '-dpng', '-r300');
end

fig = figure;
fig.PaperPosition = [0 0 5 3.75];
subplot(2, 1, 1);
plot(err);
title(['1(', question, ') \texttt{err}'], 'interpreter', 'latex');
xlabel(['\texttt{norm(err)} = ' sprintf('%f', norm(err))], 'interpreter', 'latex');
ylim([-1 1]);
subplot(2, 1, 2);
plot(output);
title('\texttt{output}', 'interpreter', 'latex');
ylim([-1 1]);
if export_fig
	print([filename_prefix 'output-', noise_string], '-dpng', '-r300');
end

if export_fig
	close all;
end
