words = ["asr", "cnn", "dnn", "hmm", "tts"];
for i = 1:5
    disp(words(i));
    for j = 1:5
        in_filename = strcat("dd_", words(i), "_", int2str(j), ".wav");
        [input, Fs] = audioread(in_filename);
        input = input(:, 1);
        coeff = mfcc(input, Fs);
        out_filename = strcat("dd_", words(i), "_", int2str(j), ".fea");
        csvwrite(out_filename, coeff);
    end
end
