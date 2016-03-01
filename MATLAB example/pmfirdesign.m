echo on
%Design of FIR linear phase equiripple lowpass filter using the Parks-McClelland algorithm. 
%Specifications:
%       Passband edge: omega_p=0.3pi
%       Stoppband edge omega_s=0.5pi
%       Ripple in passband  delta_1=0.01
%       Ripple in stopband  delta_2=0.01


%ripples and edge frequencies

ds=0.01; dp=0.01; omp=0.3; oms=0.5;

%estimate of filter order using Kaiser's formula

N=ceil((-10*log10(ds*dp)-13)/(2.3424*(oms-omp)*pi))

%estimate using remezord

[N1, F0, A0, W0]=remezord([omp oms],[1 0],[dp ds])

f=[0 omp oms 1];
a=[1 1 0 0];
w1=[1 dp/ds];

%filter coefficients
b=remez(N,f,a,w1);

%plot the frequency response
pause
figure(1)

[h w s]=freqz(b,1);
freqzplot(h,w)

s.yunits='linear';
freqzplot(h,w,s)

%specifications not satisfied, increase filter order
N=N+2;
%filter coefficients
b=remez(N,f,a,w1);

%plot the frequency response
pause
figure(1)

[h w s]=freqz(b,1);
freqzplot(h,w)

s.yunits='linear';
freqzplot(h,w,s)
%plot filter coefficients
pause
figure(2)
stem([0:N],b)
grid
title('Filter coefficients of FIR lowpass filter')

%unweighted error
Nfp=512;
j=sqrt(-1);
phasefactor=exp(j*N/2*[0:Nfp-1]'*pi/Nfp);
Np=ceil(omp*Nfp); Ns=floor(oms*Nfp);
ind1=[0:Np]; ind2=[Ns:Nfp-1];

freqax1=ind1*pi/Nfp; freqax2=ind2*pi/Nfp;
amplitude=h.*phasefactor;
errl=real(amplitude(ind1+1))-1;
err2=real(amplitude(ind2));

figure(3)
plot(freqax1/pi,errl,freqax2/pi,err2)
grid

%New specifications, ripple in passband should be 0.001 or less
%ripples and edge frequencies
pause
 
ds=0.01; dp=0.001; omp=0.3; oms=0.5;

%estimate of filter order using Kaiser's formula

N=ceil((-10*log10(ds*dp)-13)/(2.3424*(oms-omp)*pi))

%estimate using remezord

[N1, F0, A0, W0]=remezord([omp oms],[1 0],[dp ds])

f=[0 omp oms 1];
a=[1 1 0 0];
w1=[1 dp/ds];

%filter coefficients
b=remez(N,f,a,w1);

%plot the frequency response
pause
figure(1)

[h w s]=freqz(b,1);
freqzplot(h,w)

s.yunits='linear';
freqzplot(h,w,s)

%unweighted error
Nfp=512;
j=sqrt(-1);
phasefactor=exp(j*N/2*[0:Nfp-1]'*pi/Nfp);
Np=ceil(omp*Nfp); Ns=floor(oms*Nfp);
ind1=[0:Np]; ind2=[Ns:Nfp-1];

freqax1=ind1*pi/Nfp; freqax2=ind2*pi/Nfp;
amplitude=h.*phasefactor;
errl=real(amplitude(ind1+1))-1;
err2=real(amplitude(ind2));

figure(3)
plot(freqax1/pi,errl,freqax2/pi,err2)
grid
echo off
