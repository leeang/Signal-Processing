echo on
%Design of FIR linear phase lowpass filter. 
%Specifications:
%       Passband edge: omega_p=0.3pi
%       Stoppband edge omega_s=0.5pi
%       Ripple in passband  delta_1=0.01
%       Ripple in stopband  delta_2=0.01

fr=0.4; % average of passband and stopband edge as a fraction of Nyquist
        %frequency
omc=fr*pi; % average of passband and stopband edge
N=15;      %filter order, first try

%Ideal impulse response
hd=fr*sinc(fr*[-N/2:N/2]);
%Try  rectangular window
hrec=hd;

%Check frequency characteristics of filter
pause

N2=200; %number of frequency samples
om=-pi:pi/N2:pi;

%Frequency characteristics of ideal filter 
hdom=zeros(size(om));
hdom((1-fr)*N2:2*N2-(1-fr)*N2+1)=ones(size(1,fr*2*N2+1));

%frequency response of designed filter
hom=fftshift(fft(hrec,length(om)));

%plot the frequency response
pause

plot(om,abs(hom),'-',om,hdom,'--')
legend('|H(\omega)|','|H_d(\omega)|')
axis([-3.5 3.5 -0.25 1.25])
grid
title('Magnitude of frequency response of ideal filter and realised filter with rectangular window and M=16')


%ripple too large. Ripple of 0.01 -> 40 db error.
%From table a Hanning window should be OK

pause

%coefficients of filter using hanning window
hhan=hd.*hanning(N+1)';
%frequency response of designed filter
hhanom=fftshift(fft(hhan,length(om)));
%plot the frequency response 
pause

plot(om,abs(hhanom),'-',om,hdom,'--')
legend('|H(\omega)|','|H_d(\omega)|')
axis([-3.5 3.5 -0.05 1.05])
grid
title('Magnitude of frequency response of ideal filter and realised filter with Hanning window')

%Ripple is OK, but transition region is to wide
%width of mainlobe for a hanning window is 8\pi/M. Try M=40

pause

N=39;
%Ideal impulse response
hd=fr*sinc(fr*[-N/2:N/2]);
hhan=hd.*hanning(N+1)';
%frequency response of designed filter
hhanom=fftshift(fft(hhan,length(om)));
%plot the frequency response 

pause

plot(om,abs(hhanom),'-',om,hdom,'--')
legend('|H(\omega)|','|H_d(\omega)|')
axis([-3.5 3.5 -0.05 1.05])
grid
title('Magnitude of frequency response of ideal filter and realised filter with Hanning window')

%filter satisfies specs

%plot filter coefficients
pause
stem([0:N],hhan')
grid
title('Filter coefficients of FIR lowpass filter')
%Filter coefficients are symmetric about (M-1)/2. Hence filter has
%linear phase.
