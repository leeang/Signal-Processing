echo on

%Design of Butterworth lowpass filter

%Specifications passband edge w_p=0.3pi
%               stopband edge w_s=0.5pi
%               ripple delta_1=delta_2=0.01

%discrete time edge frequencies
wp=0.3*pi;
ws=0.5*pi;
%gain at edge frequencies
gp=0.99;
gs=0.01;

%Find continuous time edge frequencies

omp=2*tan(wp/2)
oms=2*tan(ws/2)

%Find filter order and continuous time cutoff
%frequency

pause

N=ceil(log((1/gs^2-1)/(1/gp^2-1))/(2*log(oms/omp)))

%solve for cutoff frequency. Let gain at 0.5 be 0.01,
%i.e. design specifications are exactly satisfied in 
%stopband and exceeded in passband

lomcc=log(oms)-log(1/gs^2-1)/(2*N);
omcc=exp(lomcc)

%find discrete cutoff frequency
pause
omcd=2*atan(omcc/2)

%get coefficients of butterworth filter
[b a]=butter(N,omcd/pi);

%plot filter coefficients
pause
figure(1)
subplot(211)
stem([0:N],b)
grid
title('Coefficients of B-polyomial')
subplot(212)
stem([0:N],a)
grid
title('Coefficients of A-polynomial')

%compute frequency response of filter
pause
[h w s]=freqz(b,a,1024);

freqzplot(h,w)
%plot mangnitude in linear scale
pause
s.yunits='linear';
freqzplot(h,w,s)
%echo off

%alternative
pause
%filterorder and cutoff for analog filter
ap=-20*log10(gp); as=-20*log10(gs);
[N1,Wn1]=buttord(omp,oms,ap,as,'s')
[blpc, alpc]=butter(N1,Wn1,'s');
[blpd,alpd]=bilinear(blpc,alpc,1);

%plot filter coefficients
pause
figure(1)
subplot(211)
stem([0:N],b)
hold on
stem([0:N1],blpd,'r*')
grid
title('Coefficients of B-polyomial')
hold off
subplot(212)
stem([0:N],a)
hold on
stem([0:N1],alpd,'r*')
grid
title('Coefficients of A-polynomial')
hold off

%the quick way to design the filter
pause
[N2 Wn2]=buttord(wp/pi, ws/pi, ap, as);
[blpe alpe]=butter(n2,wn2);
pause
figure(1)
subplot(211)
stem([0:N],b)
hold on
stem([0:N1],blpd,'r*')
stem([0:N1],blpe,'kd')
grid
title('Coefficients of B-polyomial')
hold off
subplot(212)
stem([0:N],a)
hold on
stem([0:N1],alpd,'r*')
stem([0:N1],alpe,'kd')
grid
title('Coefficients of A-polynomial')
hold off
echo off
