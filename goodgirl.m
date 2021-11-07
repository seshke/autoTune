[y,FS] = audioread('Rihannanna.m4a');
start=25;
finish=46;
FS1=44100;
[f]=audioread('rihbo.mp3',[start*FS1,finish*FS1]);

t=[1:1:length(y)];
t1=[1:1:length(f)];
%soundsc(y,FS);

freq=[-FS/2:FS/length(y):FS/2];
freq=freq(1:end-1);
freq1=[-FS1/2:FS1/length(f):FS1/2];
freq1=freq1(1:end-1);

rih=fftshift(fft(y));
rihboed=fftshift(fft(f));

figure(1)
subplot(2,1,1);
plot(t,y,t1,f);

subplot(2,1,2);
plot(freq,abs(rih),freq1,abs(rihboed));
xlim([-1000 1000]);