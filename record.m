% Recording proof of concept
%Typical values supported by most sound cards are 8000, 11025, 22050, 44100, 48000, and 96000 hertz.
%recorder = audiorecorder(Fs,nBits,NumChannels)

recObj = audiorecorder(44100,8,1);

disp('Start speaking.')
recordblocking(recObj, 3);
disp('End of Recording.');

play(recObj);
y = getaudiodata(recObj);
plot(y);
