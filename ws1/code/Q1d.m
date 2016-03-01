clear;
close all;
omega = -pi:0.01:pi;

z = exp(1j*omega);

index = 0;
for alpha = 0.8:-0.4:-0.8
    H_LP = (1 - alpha) / 2 * (1 + 1./z) ./ (1 - alpha./z);

    magnitude = abs(H_LP);
    phase = angle(H_LP);

    figure(1);
    plot(omega, magnitude);
    hold on;

    figure(2);
    plot(omega, rad2deg(phase));
    hold on;
    
    index = index + 1;
    legendInfo{index} = ['\alpha = ', sprintf('%0.1f', alpha)];
end

figure(1);
xlabel('\omega (rad/sample)');
ylabel('|H_{LP}(e^{j\omega})|');
legend(legendInfo);

figure(2);
xlabel('\omega (rad/sample)');
ylabel('\angle H_{LP}(e^{j\omega}) deg');
legend(legendInfo);
