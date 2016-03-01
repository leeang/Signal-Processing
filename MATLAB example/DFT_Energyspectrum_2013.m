
echo on
omc=1;
N=32;
deltaom2=0.2;
deltaom3=0.05;
sin1=sin(omc*[0:N-1])';
sin2=sin((omc-deltaom2)*[0:N-1])';
sin3=sin((omc-deltaom3)*[0:N-1])';

signal1=sin1+sin2;
signal2=sin1+sin3;
x=0:N-1;
%plot signal
pause

figure(1)
clf
subplot(211)
plot([0:N-1],[sin1 sin2 sin3])
grid
title('Sinusoids')
subplot(212)
plot([0:N-1],[signal1 signal2])
grid
title('Composite signals')


%Energy spectra
pause

per1=abs(fft(signal1)).^2;
per2=abs(fft(signal2)).^2;

%plot energy spectra
pause
figure(2)
clf
subplot(211)
stem(0:2*pi/N:pi,per1(1:ceil(N/2)+1),'filled')
title('Energy spectrum of signal 1.')
legend('N=32')
grid
xlabel('Radians per sample')

subplot(212)
stem(0:2*pi/N:pi,per2(1:ceil(N/2)+1),'filled')
title('Energy spectrum of signal 2.')
legend('N=32')
grid
xlabel('Radians per sample')

%padding with N zeros
pause

per12=abs(fft(signal1,2*N)).^2;
per22=abs(fft(signal2,2*N)).^2;

figure(3)
clf
subplot(211)
stem([0:pi/N:pi],per12(1:ceil(N)+1),'filled')
title('Energy spectrum of signal 1.')
legend('N=64')
hold off
grid
xlabel('Radians per sample')

subplot(212)
stem(0:pi/N:pi,per22(1:ceil(N)+1),'filled')
title('Energy spectrum of signal 2.')
legend('N=64')
grid
xlabel('Radians per sample')

%padding with 3N zeros
pause

per14=abs(fft(signal1,4*N)).^2;
per24=abs(fft(signal2,4*N)).^2;

figure(4)
clf
subplot(211)
stem([0:pi/(2*N):pi],per14(1:ceil(2*N)+1),'filled')
title('Energy spectrum of signal 1.')
legend('N=128')
grid
xlabel('Radians per sample')

subplot(212)
stem([0:pi/(2*N):pi],per24(1:ceil(2*N)+1),'filled')
title('Energy spectrum of signal 2.')
legend('N=128')
grid
xlabel('Radians per sample')

%all plots together

pause
figure(5)
subplot(311)
stem(0:2*pi/N:pi,per1(1:ceil(N/2)+1),'filled') 
grid
title('Energy spectrum of signal 1. N=32')
legend('No zero padding')
subplot(312)
stem([0:pi/N:pi],per12(1:ceil(N)+1),'filled')
legend('Data padded with 32 zeros')
grid
subplot(313)
stem([0:pi/(2*N):pi],per14(1:ceil(2*N)+1),'filled')
legend('Data padded with 96 zeros')
grid
xlabel('Radians per sample')
figure(6)

subplot(311)
stem(0:2*pi/N:pi,per2(1:ceil(N/2)+1),'filled')
grid
title('Energy spectrum of signal 2.')
legend('No zero padding')
subplot(312)
stem([0:pi/N:pi],per22(1:ceil(N)+1),'filled')
grid
legend('Data padded with 32 zeros')
subplot(313)
stem([0:pi/(2*N):pi],per24(1:ceil(2*N)+1),'filled')
grid
legend('Data padded with 96 zeros')
xlabel('Radians per sample')
%Increase data lenght with a factor 4
pause


N=4*N;
sin1=sin(omc*[0:N-1])';
sin2=sin((omc-deltaom2)*[0:N-1])';
sin3=sin((omc-deltaom3)*[0:N-1])';

signal1=sin1+sin2;
signal2=sin1+sin3;

%Energy spectra
pause

per1=abs(fft(signal1)).^2;
per2=abs(fft(signal2)).^2;
figure(7)
subplot(211)
stem(0:2*pi/N:pi,per1(1:ceil(N/2)+1),'filled')
title('Energy spectrum of signal 1. 128 data points')
grid
xlabel('Radians per sample')

subplot(212)
stem(0:2*pi/N:pi,per2(1:ceil(N/2)+1),'filled')
title('Energy spectrum of signal 2. 128 data points')
grid
xlabel('Radians per sample')

echo off
