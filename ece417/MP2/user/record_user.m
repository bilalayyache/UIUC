recObj = audiorecorder(22050, 16, 1);
% record sound
disp('Start speaking.')
recordblocking(recObj, 2);
disp('End of Recording.');
% write sound into a doule array
myRecording = getaudiodata(recObj);
% myRecording = myRecording(11:end);
% write into a wav file
filename = 'yz_tts5.wav';
audiowrite(filename, myRecording, 22050);
