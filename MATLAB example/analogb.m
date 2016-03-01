echo on
% Design of analog Butterworth filter
% Specifications: Passband: 0-2Hz, stopband: above 12 Hz
% Max deviation from unit gain in passband: 0.01, 
% Minimum attenuation in stopband 40dB

%band edge frequencies and magnitude errors
fp=2; fs=12; dp=0.01; ds=10^(-40/20);
%epsilon and A
epsilon=sqrt((1-(1-dp)^2)/((1-dp)^2)); A=1/ds;
%minimum filter order
pause
N=log10(sqrt(A^2-1)/epsilon)/log10(fs/fp)
N=ceil(N)

%cut off frequency. Solve for stopp band equation.
%specifications satisfied in stopband and exceeded in passband
pause

fc=fs/((1-ds^2)/ds^2)^(1/(2*N))
%analog filter coefficients
pause

[b a]=butter(N,fc*2*pi,'s');

%plot frequency response of filter
pause
omega = [0: 60*pi];
h = freqs(b,a,omega);
figure(1)
subplot(211)
plot ((omega/(2*pi)),20*log10(abs(h)));
grid
xlabel('Frequency, Hz'); ylabel('Gain, dB');
subplot(212)
plot (omega/(2*pi),(abs(h)));
grid
xlabel('Frequency, Hz'); ylabel('Gain, linear scale');

%plot both magnitude and phase respons
pause
figure(2)
freqs(b,a)

%plot pole locations
pause
[z p k]=tf2zpk(b,a);
figure(3)
zplane(z,p)

%verify that all poles are in the left half plane on a circle around 0
pause
abs(p) 
p

%Use of Matlab functions to find the order and cut off frequency
pause
alphap=-20*log10(1-dp);
alphas=-20*log10(ds);
[N1,Omegac]=buttord(fp*2*pi,fs*2*pi,alphap,alphas,'s')
fc1=Omegac/(2*pi)

echo off
