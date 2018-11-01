words = ["asr", "cnn", "dnn", "hmm", "tts"];
for i = 1:1
    disp(words(i));
    for j = 1:5
        in_filename = strcat("yz_", words(i), int2str(j), ".wav");
        [input, Fs] = audioread(in_filename);
        input = input(2501:end, 1);
        soundsc(input, Fs);
        pause(2);
        coeff = mfcc(input, Fs);
        out_filename = strcat("yz_", words(i), int2str(j), ".fea");
        fileID = fopen(out_filename, 'w');
        fprintf(fileID,'%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f\n',coeff);
        fclose(fileID);
    end
end
