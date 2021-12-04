%% Recording proof of concept
%Typical values supported by most sound cards are 8000, 11025, 22050, 44100, 48000, and 96000 hertz.
%recorder = audiorecorder(Fs,nBits,NumChannels)

recObj = audiorecorder(44100,8,1);

disp('Start speaking.')
recordblocking(recObj, 3);
disp('That was terrible.');
%play(recObj);

y = getaudiodata(recObj);
fs = 44100;
audioIn= y;

%Estimate pitch for singing voice
%https://www.mathworks.com/help/audio/ref/pitch.html
t = (0:size(audioIn,1)-1)/fs;

winLength = round(0.05*fs);
overlapLength = round(0.045*fs);
%overlapLength = 132300;
%display(audioIn)
[f0,idx] = pitch(audioIn,fs,'Method','PEF','Range',[15,800],'WindowLength',winLength,'OverlapLength',overlapLength);
%[f0,idx] = pitch(audioIn,fs,'Method','SRH','WindowLength',winLength,'OverlapLength',overlapLength);
tf0 = idx/fs;

%sound(audioIn,fs)
% for i=1:length(f0)
% end
%xt=cos(2*pi*f0(100)*t);
%soundsc(xt,fs);

figure(1)
tiledlayout(2,1)

nexttile
plot(t,audioIn)
ylabel('Amplitude')
title('Audio Signal')
axis tight

nexttile
plot(tf0,f0)
xlabel('Time (s)')
ylabel('Pitch (Hz)')
title('Pitch Estimations')
axis tight

%Use the harmonic ratio as the threshold for valid pitch decisions. 
% If the harmonic ratio is less than the threshold, set the pitch decision to NaN. 
% Plot the results.
hr = harmonicRatio(audioIn,fs,"Window",hamming(winLength,'periodic'),"OverlapLength",overlapLength);

threshold = 0.9;
f0(hr < threshold) = 0;

%Back to time domain
time_f0 = ifft(f0);
real_f0 = real(time_f0); 
%disp(f0);
%sound(audioIn,fs)
%sound(abs(time_f0),fs)

%soundsc(f0,fs)

%playOut(f0)


%% Plotting

figure(2)
plot(tf0,f0);
xlabel('Time (s)');
ylabel('Pitch (Hz)');
title('Pitch Estimations');
grid on;

t=[-0.1:deltat:5];
[noteNam,fixedFrequencies]=makeRect(tf0,1,f0,NoteName);
fixed=fixedFrequencies(1:224911);
%disp(noteNam);

figure(3);
plot(t,fixed);
xlabel('Time (s)');
title('Corrected Pitch Guesses');
grid on;
soundsc(fixedFrequencies,44100);

disp(noteNam.');

% Playing out notes

% pitch_array = f0; 
% for i = 1:length(pitch_array)
%     %disp(i)
%     Fs = 44100;        % Samples per second. 48000 is also a good choice
%     %curVal = pitch_array(i); 
%     %if curVal == 0
%     %    sound(a,Fs);
%     toneFreq = pitch_array(i);  % Tone frequency, in Hertz. must be less than .5 * Fs.
%     disp(toneFreq)
%     %disp(toneFreq)
%     nSeconds = 0.1;      % Duration of the sound
%     a = sin(linspace(0, nSeconds*toneFreq*2*pi, round(nSeconds*Fs)));
%     %soundsc(a,Fs); % Play sound at sampling rate Fs
% end

% Playing out notes function
function [sounds,newRect] = makeRect(t,progressIndex, arr, notes)
    newRect=zeros(1,300000);
    sounds=strings(1,592);
    FS = 44100;
    deltat = 1/FS;
    t=[-0.1:deltat:7];
    %disp(length(t));
    j=1;
    
    for k=progressIndex:length(arr)
        if (arr(k)>0) %if a pitch is detected
            for h=1:381
                [f,fi]=freqFinder(arr(k));
                %disp(f);
                %disp(length(newRect));
                %disp(length(t));
                %disp(j);
                newRect(j)=cos(2*pi()*f*t(j));
                %sounds(j) = notes(fi);
                %disp(fi);
                %disp(notes(fi));
                j=j+1;
            end
            sounds(k)=notes(fi);
        else
            for h=1:381 %if no pitch detected (silence)
                newRect(j)=0;
                %sounds(j) = "silent";
                j=j+1;
            end
            sounds(k) = "silent (N/A)";
        end
        %disp(j);
    end
    %disp(j);
    
end

%% Frequency Finder function
%% Matches recorded pitch to the closest known note
function [bat,batIndex] = freqFinder(freq)

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
    7902.13];
placeholder=knownFreq;
freqLength = length(knownFreq);
sample=freq; %sets to sample frequency
i=cast(freqLength/2 + 0.5, 'uint32');
while(freqLength>1)
    freqLength=length(knownFreq);
    %disp("length");
    %disp(freqLength);
    %disp("index");
    %disp(i);
    if (abs(knownFreq(i+1)-sample)<abs(knownFreq(i)-sample)) %move up
        %disp("up");
        knownFreq=knownFreq(i+1:end);
        freqLength=length(knownFreq);
        i=cast((freqLength/2), 'uint32');
    else %move down
        %disp("down");
        knownFreq=knownFreq(1:i);
        freqLength=length(knownFreq);
        i=cast((freqLength/2), 'uint32');
    end
    bat=knownFreq(1);
    %disp("bat");
    %disp(bat);
    if (bat~=0)
        batIndex=find(placeholder==bat);
    else
        batIndex=0; %index of zero means silence; no note sung
    end
    %disp(batIndex); 
end

end
