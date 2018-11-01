words = ["asr", "cnn", "dnn", "hmm", "tts"];
for i = 1:5
    disp(words(i));
    for j = 1:5
        in_filename = strcat("yz_", words(i), int2str(j), ".wav");
        [input, Fs] = audioread(in_filename);
        input = input(:, 1);
        coeff = mfcc(input, Fs);
        out_filename = strcat("yz_", words(i), int2str(j), ".fea");
        csvwrite(out_filename, coeff);
    end
end
