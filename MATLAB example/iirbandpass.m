echo on
%design of digital elliptic bandpass filter

%allowed ripples: 0.01 in passband, 0.05 in stopband
dp=0.01; ds=0.05;
%passband edge frequencies 0.2pi and 0.4pi.
%stopband edge frequencies 0.1pi and 0.5pi
wp1=0.2*pi; wp2=0.4*pi; ws1=0.1*pi; ws2=0.5*pi;

%bandedge frequencies for analog filter (T=1)
pause
omp1=2*tan(wp1/2)
omp2=2*tan(wp2/2)
oms1=2*tan(ws1/2)
oms2=2*tan(ws2/2)
%adjust stopband edqes to get symmetry with respect to 
%centre frequency
if omp1*omp2>oms1*oms2
    oms1=omp1*omp2/oms2
else
    oms2=omp1*omp2/oms1
end

%peak passband ripple and minimum stopband attenuation in dB
pause
ap=-20*log10(1-dp); as=-20*log10(ds);


%passband edge of prototype lowpass filter
omplp=1;
%stopband edge of prototype lowpass filter
omslp=-omplp*(omp1*omp2-oms2^2)/(oms2*(omp2-omp1))

%design of prototype elliptic lowpass filter
pause
[Nbp,Wlpproto]=ellipord(omplp,omslp,ap,as,'s')
[blp,alp]=ellip(Nbp,ap,as,Wlpproto,'s');
%use spectral tansformation to convert analog lowpass filter to
%an analog bandpass filter
pause
[bbp,abp]=lp2bp(blp,alp,sqrt(omp1*omp2),omp2-omp1)

%use the bilinear transform to get the digital bandpass filter
pause
T=1;
[b,a]=bilinear(bbp,abp,T)
%compute frequency response of filter
pause
figure(1)
[h w s]=freqz(b,a,1024);
 
freqzplot(h,w)
%plot mangnitude in linear scale
pause
s.yunits='linear';
figure(2)
freqzplot(h,w,s)

%the quick way to design the filter
pause
[N, wn]=ellipord([0.2 0.4],[0.1 0.5],ap,as);
[bq, aq]=ellip(N,ap,as,[0.2 0.4]);

[hq wq sq]=freqz(bq,aq,1024);
sq.yunits='linear';
figure(3)
freqzplot(hq,wq,sq)
echo off
