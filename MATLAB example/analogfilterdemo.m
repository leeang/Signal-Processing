echo on
%Design example. Butterworth, Type 1 and 2 Chebyshev and elliptic filters

%allowed ripples in passband and stopband
dp=0.01; ds=0.01;
%passband and stopband edge frequencies
omp=1; oms=2; 

ap=-20*log10(1-dp); as=-20*log10(ds);
%calculate filter orders and cutoff frequencies
pause
[N1, Wn1]=buttord(omp,oms,ap,as,'s')
[N2, Wn2]=cheb1ord(omp,oms,ap,as,'s')
[N3, Wn3]=cheb2ord(omp,oms,ap,as,'s')
[N4, Wn4]=ellipord(omp,oms,ap,as,'s')
%filter coefficients
pause
[b1,a1]=butter(N1,Wn1,'s');
[b2,a2]=cheby1(N2,ap,Wn2,'s');
[b3,a3]=cheby2(N3,as,Wn3,'s');
[b4,a4]=ellip(N4,ap,as,Wn4,'s');

%frequency responses
pause
w=linspace(0,4,1024);
h1=freqs(b1,a1,w); h2=freqs(b2,a2,w); 
h3=freqs(b3,a3,w); h4=freqs(b4,a4,w);

%plot frequency responses
pause
figure(1)
subplot(211)
plot(w,abs(h1),'-',w,abs(h2),'-',w,abs(h3),'-',w,abs(h4),'-')
axis([0 4 0 1.05])
title('Magnitude response')
legend('Butterworth','Chebyshev type 1','Chebyshev type 2','Elliptic')
grid
subplot(212)
plot(w,180/pi*unwrap(angle(h1)),'-',w,180/pi*unwrap(angle(h2)),'-',w,180/pi*unwrap(angle(h3)),'-',w,180/pi*unwrap(angle(h4)),'-')
grid


%design of bandpass filter
pause

%allowed ripples in passband and stopband
dp=0.01; ds=0.005;
%passband and stopband edge frequencies
omp1=5; omp2=7; oms1=3; oms2=9;
%adjust lower stopband edqe to get symmetry with respect to 
%centre frequency
oms1m=omp1*omp2/oms2;
ap=-20*log10(1-dp); as=-20*log10(ds);

%passband edge of prototype lowpass filter
omplp=1;
%stopband edge of prototype lowpass filter
omslp=-omplp*(omp1*omp2-oms2^2)/(oms2*(omp2-omp1));
%design prototype Butterworth lowpass filter
%epsilon and A
epsilon=sqrt((1-(1-dp)^2)/((1-dp)^2)); A=1/ds;
%minimum filter order
pause
N=log10(sqrt(A^2-1)/epsilon)/log10(omslp/omplp)
N=ceil(N)

%cut off frequency. Solve for stopp band equation.
%specifications satisfied in stopband and exceeded in passband
pause

omclp=omslp/((1-ds^2)/ds^2)^(1/(2*N))

%check calculations using buttord
pause
[Nbp,Wlpproto]=buttord(omplp,omslp,ap,as,'s')
[blp,alp]=butter(Nbp,Wlpproto,'s');
%convert lowpass filter to bandpass filter
pause
[bbp,abp]=lp2bp(blp,alp,sqrt(omp1*omp2),omp2-omp1);
%plot frequency response
pause
w1=linspace(2,10,1024);
h5lp=freqs(blp,alp,w1);
h5=freqs(bbp,abp,w1);

figure(2)
clf
plot(w1,abs(h5),'-')
title('Magnitude response')
xlabel('Rad/sec')
grid

%direct design using butter 
omc1=Wlpproto+sqrt(Wlpproto^2+omp1*omp2)
omc2=abs(Wlpproto-sqrt(Wlpproto^2+omp1*omp2))
[b2bp,a2bp]=butter(Nbp,[omc2 omc1],'s');
%plot frequency response and compare. One response shifted with 0.01 in
%magnitude 
pause
h6=freqs(b2bp,a2bp,w1);
figure(3)
clf
plot(w1,abs(h5),'-',w1,abs(h6)+0.01)
title('Magnitude response')
xlabel('Rad/sec')
grid

%even simpler design
[N, Wn]=buttord([omp1 omp2],[oms1 oms2],ap ,as,'s')
[b3bp a3bp]=butter(N,Wn,'s');
%plot frequency response and compare. Responses shifted with 0.01 and 0.02 in
%magnitude 
pause
h7=freqs(b3bp,a3bp,w1);
figure(4)
clf
plot(w1,abs(h5),'-',w1,abs(h6)+0.01,w1,abs(h7)+0.02)
title('Magnitude response')
xlabel('Rad/sec')
grid
