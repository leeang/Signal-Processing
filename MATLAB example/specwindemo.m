echo on

%Signal 1 : 2 sinusoids with frequency 0.2pi and 0.3pi. The amplitude of
%the two frequency componenets are 0.1 and 1.

%Signal 2: 2 sinusoids with frequency 0.28pi and 0.3pi. Both sinusoids have
%amplitude 1.

%Number of data points
N=128;

%generate signals

sin1=sin(0.3*pi*[0:N-1]);
sin2=0.1*sin(0.2*pi*[0:N-1]);
sin3=sin(0.28*pi*[0:N-1]);

signal1=sin1+sin2;
signal2=sin1+sin3;

%plot signal
pause
figure(1)
clf
plot([0:N-1],signal1,'-',[0:N-1],signal2,'-')
grid
legend('\omega_1=0.2, \omega_2=0.3','\omega_1=0.28, \omega_2=0.3')
title('Sinusoidal signals')


%Estimate energy spectrum using rectangular and  Hamming windows.
%Press any key to continue

pause

%Rectangular window
sig1rec=signal1;
sig2rec=signal2;

%Hamming window
sig1ham=signal1.*hamming(N)';
sig2ham=signal2.*hamming(N)';
hamcorrection=sum(hamming(N).^2)/N;

%Energy spectrum
N=1024;
%compute ffts
Xrec1=fft(sig1rec,N);
Xham1=fft(sig1ham,N);
Xrec2=fft(sig2rec,N);
Xham2=fft(sig2ham,N);
%absolute value and square
Sxxham1=abs(Xham1).^2/hamcorrection;
Sxxrec1=abs(Xrec1).^2;
Sxxham2=abs(Xham2).^2/hamcorrection;
Sxxrec2=abs(Xrec2).^2;

%convert to dB
Sxxrec1db=10*log10(Sxxrec1);
Sxxham1db=10*log10(Sxxham1);
Sxxrec2db=10*log10(Sxxrec2);
Sxxham2db=10*log10(Sxxham2);
%Plot spectrum estimates. Press any key to continue.
pause

Nmax=ceil(N/2)+1;
freqscale2=[0:2/N:1];
figure(2)
subplot(211)
plot(freqscale2,Sxxrec1db(1:Nmax))
grid
title('Estimates of energy spectrum of signal 1. Rectangular window')
ylabel('Magnitude')
%xlabel('Radians per sample times \pi')
subplot(212)
plot(freqscale2,Sxxham1db(1:Nmax))
grid
title('Estimates of energy spectrum. Hamming window')
ylabel('Magnitude')
xlabel('Radians per sample times \pi')

figure(3)
subplot(211)
plot(freqscale2,Sxxrec2db(1:Nmax))
grid

title('Estimates of energy spectrum of signal 2. Rectangular window')
ylabel('Magnitude')
%xlabel('Radians per sample times \pi')
subplot(212)
plot(freqscale2,Sxxham2db(1:Nmax))
grid
title('Estimates of energy spectrum. Hamming window')
ylabel('Magnitude')
xlabel('Radians per sample times \pi')
echo off
