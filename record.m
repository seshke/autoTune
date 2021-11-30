% Recording proof of concept
%Typical values supported by most sound cards are 8000, 11025, 22050, 44100, 48000, and 96000 hertz.
%recorder = audiorecorder(Fs,nBits,NumChannels)

recObj = audiorecorder(44100,8,1);

disp('Start speaking.')
recordblocking(recObj, 3);
disp('End of Recording.');
%play(recObj);

y = getaudiodata(recObj);
fs = 44100;
audioIn= y;

%Estimate pitch for singing voice
%https://www.mathworks.com/help/audio/ref/pitch.html
t = (0:size(audioIn,1)-1)/fs;

winLength = round(0.05*fs);
overlapLength = round(0.045*fs);
[f0,idx] = pitch(audioIn,fs,'Method','SRH','WindowLength',winLength,'OverlapLength',overlapLength);
tf0 = idx/fs;

sound(audioIn,fs)

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
f0(hr < threshold) = nan;

figure(2)
plot(tf0,f0)
xlabel('Time (s)')
ylabel('Pitch (Hz)')
title('Pitch Estimations')
grid on
