clear;
close all;

omega = -3*pi:0.01:3*pi;

% H(z)
y1 = square(omega+pi/4, 100/4)/2 + 0.5;

figure;
plot(omega, y1, 'LineWidth', 2);

set(gca,...
    'xlim', [min(omega) max(omega)],...
    'xtick', [-2*pi -pi -pi/4 0 pi/4 pi 2*pi],...
    'xticklabel', {'-2\pi' '-\pi' '-\pi/4' '0' '\pi/4' '\pi' '2\pi'});
set (gcf, 'Position', [500 500 900 420]);
title('H(z)');
xlabel('\omega rad/sample');
ylabel('magnitude (linear scale)');

% H(z^3)
y2 = square((omega+pi/12)*3, 100/12*3)/2 + 0.5;

figure;
plot(omega, y2, 'LineWidth', 2);

set(gca,...
    'xlim', [min(omega)/2 max(omega)/2],...
    'xtick', [-pi*9/12 -pi*7/12 -pi/3 -pi/12 0 pi/12 pi/3 pi*7/12 pi*9/12],...
    'xticklabel', {'-\pi9/12' '-\pi7/12' '-\pi/3' '-\pi/12' '0' '\pi/12' '\pi/3' '\pi7/12' '\pi9/12'});
set (gcf, 'Position', [500 500 900 420]);
title('H(z^3)');
xlabel('\omega rad/sample');
ylabel('magnitude (linear scale)');

% H(z) H(z^3)
figure;
plot(omega, y1 .* y2, 'LineWidth', 2);

set(gca,...
    'xlim', [min(omega)/2 max(omega)/2],...
    'xtick', [-pi*9/12 -pi*7/12 -pi/3 -pi/12 0 pi/12 pi/3 pi*7/12 pi*9/12],...
    'xticklabel', {'-\pi9/12' '-\pi7/12' '-\pi/3' '-\pi/12' '0' '\pi/12' '\pi/3' '\pi7/12' '\pi9/12'});
set (gcf, 'Position', [500 500 900 420]);
title('H(z) H(z^3)');
xlabel('\omega rad/sample');
ylabel('magnitude (linear scale)');

% H(-z)
y3 = square((omega+pi/4)+pi, 100/4)/2 + 0.5;

figure;
plot(omega, y3, 'LineWidth', 2);

set(gca,...
    'xlim', [min(omega) max(omega)],...
    'xtick', [-pi*5/4 -pi -pi*3/4 0 pi*3/4 pi pi*5/4],...
    'xticklabel', {'-\pi5/4' '-\pi' '-\pi3/4' '0' '\pi3/4' '\pi' '\pi5/4'});
set (gcf, 'Position', [500 500 900 420]);
title('H(-z)');
xlabel('\omega rad/sample');
ylabel('magnitude (linear scale)');

% H(-z) H(z^3)
figure;
plot(omega, y3 .* y2, 'LineWidth', 2);

set(gca,...
    'xlim', [min(omega) max(omega)],...
    'xtick', [-pi*5/4 -pi -pi*3/4 0 pi*3/4 pi pi*5/4],...
    'xticklabel', {'-\pi5/4' '-\pi' '-\pi3/4' '0' '\pi3/4' '\pi' '\pi5/4'});
set (gcf, 'Position', [500 500 900 420]);
title('H(-z) H(z^3)');
xlabel('\omega rad/sample');
ylabel('magnitude (linear scale)');
