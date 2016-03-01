echo on
%Transmitted signal
x=sign(randn(size([1:100])));
alpha=0.1;
noisevar=0.1^2;

%Received signal 1: Attenuated transmitted signal + noise
y1=alpha*[zeros(size([1:20])) x(1:80)]+sqrt(noisevar)*randn(size([1:100]));

%Received signal 2: Noise only
y2=sqrt(noisevar)*randn(size([1:100]));

%Plot signals
pause
figure(1)
subplot(311)
stairs(x)
axis([0 100 -1.1 1.1])
title('Transmitted signal')
subplot(312)
plot(y1)
title('Received signal 1. Attenuated signal + noise. SNR=0dB')
grid
subplot(313)
plot(y2)
title('Received signal 2. Noise only')
grid

%Compute crosscorrelations between transmitted 
%and received signals
[c1 c1lag]=xcorr(y1,x,50,'unbiased');
[c2 c2lag]=xcorr(y2,x,50,'unbiased');

%plot crosscorrelations
pause
figure(2)
subplot(211)
plot(c1lag,c1)
title('Crosscorrelation between transmitted and first received signal')
grid
subplot(212)
plot(c2lag,c2)
title('Crosscorrelation between transmitted and second received signal')
grid

echo off
