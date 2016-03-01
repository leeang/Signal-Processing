echo on
% Effect of the locations of poles and zeros on the frequency response.

% Real poles and zeros

alpha1=0.5; alpha2=0.7; alpha3=0.9; %pole/zero locations
N=1024; %number of requency points
omd=0:pi/N:(N-1)*pi/N; %frequency points

% zeros
a1=1-alpha1; a2=1-alpha2; a3=1-alpha3; b1=[1 -alpha1]; b2=[1 -alpha2]; b3=[1 -alpha3];
h1=freqz(b1,a1,omd);
h2=freqz(b2,a2,omd);
h3=freqz(b3,a3,omd);

% plot frequency responses
pause
figure(1)
subplot(211)
plot(omd/pi,abs(h1),'-',omd/pi,abs(h2),'-',omd/pi,abs(h3),'-')
grid
xlabel('Radians per sample (\times\pi)')
ylabel('Magnitude (linear scale)')
title('One real zero')
subplot(212)
plot(omd/pi,angle(h1)*180/pi,'-',omd/pi,angle(h2)*180/pi,'-',omd/pi,angle(h3)*180/pi,'-')
grid
xlabel('Radians per sample (\times\pi)')
ylabel('Phase (degrees)')
legend('\alpha=0.5','\alpha=0.7','\alpha=0.9')

%poles
h1=freqz(a1,b1,omd);
h2=freqz(a2,b2,omd);
h3=freqz(a3,b3,omd);
figure(2)
subplot(211)
plot(omd/pi,abs(h1),'-',omd/pi,abs(h2),'-',omd/pi,abs(h3),'-')
grid
xlabel('Radians per sample (\times\pi)')
ylabel('Magnitude (linear scale)')
title('One real pole')
subplot(212)
plot(omd/pi,angle(h1)*180/pi,'-',omd/pi,angle(h2)*180/pi,'-',omd/pi,angle(h3)*180/pi,'-')
grid
xlabel('Radians per sample (\times\pi)')
ylabel('Phase (degrees)')
legend('\alpha=0.5','\alpha=0.7','\alpha=0.9')

% negative pole
pause
alpha4=-0.7; b4=[1 -alpha4]; h4=freqz(a2,b4,omd);
figure(3)
subplot(211)
plot(omd/pi,abs(h2),'-',omd/pi,abs(h4),'-')
grid
xlabel('Radians per sample (\times\pi)')
ylabel('Magnitude (linear scale)')
title('One real pole')
subplot(212)
plot(omd/pi,angle(h2)*180/pi,'-',omd/pi,angle(h4)*180/pi,'-')
grid
xlabel('Radians per sample (\times\pi)')
ylabel('Phase (degrees)')
legend('\alpha=0.7','\alpha=-0.7')
%one complex pole/zero
pause
%zero


r1=0.85; r2=0.95; om1=pi/6; om2=pi/3;

j=sqrt(-1);
b1=[1 -r2*exp(j*om1)]; b2=[1 -r2*exp(j*om2)];
b3=[1 -r1*exp(j*om1)]; b4=[1 -r1*exp(j*om2)];
a1=abs(1+b1(2)); a2=abs(1+b2(2));
h1=freqz(b1,1,N,'whole');
h2=freqz(b2,1,N,'whole');
h3=freqz(b3,1,N,'whole');
h4=freqz(b4,1,N,'whole');

figure(4)
subplot(211)
plot(2*omd/pi,abs(h1),'-',2*omd/pi,abs(h2),'-',2*omd/pi,abs(h3),'-',2*omd/pi,abs(h4),'-')
grid
xlabel('Radians per sample (\times\pi)')
ylabel('Magnitude (linear scale)')
title('One complex zero')
subplot(212)
plot(2*omd/pi,angle(h1)*180/pi,'-',2*omd/pi,angle(h2)*180/pi,'-',2*omd/pi,angle(h3)*180/pi,'-',2*omd/pi,angle(h4)*180/pi,'-')
grid
xlabel('Radians per sample (\times\pi)')
ylabel('Phase (degrees)')
legend('r=0.95,\phi=\pi/6','r=0.95,\phi=\pi/3','r=0.85,\phi=\pi/6','r=0.85,\phi=\pi/3')


%pole
h1=freqz(1,b1,N,'whole');
h2=freqz(1,b2,N,'whole');
h3=freqz(1,b3,N,'whole');
h4=freqz(1,b4,N,'whole');
figure(5)
subplot(211)
plot(2*omd/pi,abs(h1),'-',2*omd/pi,abs(h2),'-',2*omd/pi,abs(h3),'-',2*omd/pi,abs(h4),'-')
grid
xlabel('Radians per sample (\times\pi)')
ylabel('Magnitude (linear scale)')
title('One complex pole')
subplot(212)
plot(2*omd/pi,angle(h1)*180/pi,'-',2*omd/pi,angle(h2)*180/pi,'-',2*omd/pi,angle(h3)*180/pi,'-',2*omd/pi,angle(h4)*180/pi,'-')
grid
xlabel('Radians per sample (\times\pi)')
ylabel('Phase (degrees)')
legend('r=0.95,\phi=\pi/6','r=0.95,\phi=\pi/3','r=0.85,\phi=\pi/6','r=0.85,\phi=\pi/3')


%complex conjugate poles and zeros;
pause
b1=[1 -r2*exp(j*om1)]; b2=[1 -r2*exp(j*om2)]; %single pole/zero
b5=[1 -r2*exp(-j*om1)]; b6=[1 -r2*exp(-j*om2)];
b3=[1 -2*r2*cos(om1) r2^2]; b4=[1 -2*r2*cos(om2) r2^2]; %complex conjugate poles/zeros


%zeros
h1=freqz(b1,1,N,'whole');
h2=freqz(b2,1,N,'whole');
h3=freqz(b3,1,N,'whole');
h4=freqz(b4,1,N,'whole');
%h5=freqz(b5,1,N,'whole');
%h6=freqz(b6,1,N,'whole');
figure(6)
subplot(211)
plot(2*omd/pi,abs(h1),'-',2*omd/pi,abs(h2),'-',2*omd/pi,abs(h3),'-',2*omd/pi,abs(h4),'-')
grid
xlabel('Radians per sample (\times\pi)')
ylabel('Magnitude (linear scale)')
title('Single complex zero and complex conjugate zeros')
subplot(212)
plot(2*omd/pi,angle(h1)*180/pi,'-',2*omd/pi,angle(h2)*180/pi,'-',2*omd/pi,angle(h3)*180/pi,'-',2*omd/pi,angle(h4)*180/pi,'-')
grid
xlabel('Radians per sample (\times\pi)')
ylabel('Phase (degrees)')
legend('r=0.95,\phi=\pi/6, single','r=0.95,\phi=\pi/3, single','r=0.95,\phi=\pi/6, cc','r=0.95,\phi=\pi/3, cc')


%poles
h1=freqz(1,b1,N,'whole');
h2=freqz(1,b2,N,'whole');
h3=freqz(1,b3,N,'whole');
h4=freqz(1,b4,N,'whole');
figure(7)
subplot(211)
plot(2*omd/pi,abs(h1),'-',2*omd/pi,abs(h2),'-',2*omd/pi,abs(h3),'-',2*omd/pi,abs(h4),'-')
grid
xlabel('Radians per sample (\times\pi)')
ylabel('Magnitude (linear scale)')
title('Single complex pole and complex conjugate poles')
subplot(212)
plot(2*omd/pi,angle(h1)*180/pi,'-',2*omd/pi,angle(h2)*180/pi,'-',2*omd/pi,angle(h3)*180/pi,'-',2*omd/pi,angle(h4)*180/pi,'-')
grid
xlabel('Radians per sample (\times\pi)')
ylabel('Phase (degrees)')
legend('r=0.95,\phi=\pi/6, single','r=0.95,\phi=\pi/3, single','r=0.95,\phi=\pi/6, cc','r=0.95,\phi=\pi/3, cc')

echo off
