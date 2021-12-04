[alexSing,FS] = audioread('Rihannanna.m4a'); %alex file
start=25;
finish=46;
FS1=44100; %for rihanna file?
[rihSing,FS2]=audioread('rihbo.mp3',[start*FS1,finish*FS1]); %rihanna file

t=[1:1:length(alexSing)];
t1=[1:1:length(rihSing)];
%soundsc(alexSing,FS);

freq=[-FS/2:FS/length(alexSing):FS/2];
freq=freq(1:end-1);
freq1=[-FS1/2:FS1/length(rihSing):FS1/2];
freq1=freq1(1:end-1);

rih=fftshift(fft(alexSing)); %shifts so it's half on the left and half on right side of y axis
rihboed=fftshift(fft(rihSing));

figure(1)
subplot(2,1,1);
plot(t,alexSing,t1,rihSing);

subplot(2,1,2);
plot(freq,abs(rih),freq1,abs(rihboed));
xlim([-1000 1000]);

win1 = hamming(FS/10);
[S,F,T] = stft(alexSing,FS,'Window',win1,'OverlapLength',250);
figure(2);
smag = mag2db(abs(S));
pcolor(seconds(T),F,smag);
xlabel('Time (s)');
ylabel('Frequency (Hz)');
shading flat;
ylim([-1500 1500]);
colorbar;
caxis(max(smag(:)) + [-60 0]);

sam=100000;
bat=freqFinder(sam);
disp("corrected pitch");
disp(bat);

f0=300;
pitches=[0.05:0.005:592];
t=[1:1:length(pitches)+1];
%xt=(t>=0).*(t <=30).*cos(2*pi()*f0*t);
[sound1,rect1]=makeRect(1,pitches);
soundsc(rect1, 44100);

function [sound,newRect] = makeRect(progressIndex, arr)
    f0=0;
    t=[1:1:length(pitches)+1];
    newRect=arr;
    sound=zeros(1,length(arr));
    for k=progressIndex:length(arr)
        if (arr(k)>0)
            f0=freqFinder(arr(k));
            newRect(k)=cos(2*pi*f0*t);
            sound(k) = NoteName(find(note));
        else
            newRect(k)=0;
            sound(k) = "silent";
        end
    end
end

function bat = freqFinder(freq)

knownFreq = [16.35
    17.32
    18.35
    19.45
    20.6
    21.83
    23.12
    24.5
    25.96
    27.5
    29.14
    30.87
    32.7
    34.65
    36.71
    38.89
    41.2
    43.65
    46.25
    49
    51.91
    55
    58.27
    61.74
    65.41
    69.3
    73.42
    77.78
    82.41
    87.31
    92.5
    98
    103.83
    110
    116.54
    123.47
    130.81
    138.59
    146.83
    155.56
    164.81
    174.61
    185
    196
    207.65
    220
    233.08
    246.94
    261.63
    277.18
    293.66
    311.13
    329.63
    349.23
    369.99
    392
    416.3
    440
    466.16
    493.88
    523.25
    554.37
    587.33
    622.25
    659.25
    698.46
    739.99
    783.99
    830.61
    880
    932.33
    987.77
    1046.5
    1108.73
    1174.66
    1244.51
    1318.51
    1396.91
    1479.98
    1567.98
    1661.22
    1760
    1864.66
    1975.53
    2093
    2217.46
    2349.32
    2489.02
    2637.02
    2793.83
    2959.96
    3135.96
    3322.44
    3520
    3729.31
    3951.07
    4186.01
    4434.92
    4698.63
    4978.03
    5274.04
    5587.65
    5919.91
    6271.93
    6644.88
    7040
    7458.62
    7902.13
    100000000];
freqLength = length(knownFreq);
sample=freq; %sets to sample frequency
i=freqLength/2;
while(freqLength>1)
    if (abs(knownFreq(i+1)-sample)<abs(knownFreq(i)-sample)) %move up
        knownFreq=knownFreq(i+1:end);
        i=cast((length(knownFreq)/2) + 0.5, 'uint32');
        disp(length(knownFreq));
        disp(i);
    else %move down
        knownFreq=knownFreq(1:i);
        disp(length(knownFreq));
        disp(i);
    end
    freqLength=length(knownFreq);
end

end