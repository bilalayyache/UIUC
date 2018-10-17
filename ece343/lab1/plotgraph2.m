%% Sample matlab
% This sample code is written based on lab 1 which is
% mainly used as a guideline for lab 1 and future labs


%% Formatting
colordef white;
% Plot with default font size 16+
% Linewidth of 2 or 3
set(0,'defaultAxesFontName', 'Arial');
set(0,'defaultTextFontName', 'Arial');
set(0,'defaultAxesFontWeight', 'Bold');
set(0,'defaultTextFontWeight', 'Bold');
set(0, 'DefaultTextFontSize', 16) ;
set(0, 'DefaultAxesFontSize', 14) ;
set(0, 'DefaultLineLineWidth', 3.5) ;
set(0, 'DefaultStairLineWidth', 3.5) ;
set(0, 'DefaultAxesLineWidth', 2.5) ;
set(0, 'DefaultPatchLineWidth', 2) ;
set(0, 'DefaultAxesXGrid', 'on') ;
set(0, 'DefaultAxesYGrid', 'on') ;
set(0, 'DefaultAxesBox', 'on') ;
set(0, 'DefaultFigurePosition', [200 175 1000 600]);


%% Plotting
% modified the directory of the .txt file as needed
filename = '/home/yichi3/ece343/lab1/ltspice2.txt';
data = dlmread(filename, ' ', 1, 0);


% convert data into complex number for calculation
freq = data(:,1);
complex = data(:,2)+i*data(:,3);
magvv = abs(complex);               % obtain mag of AC response in V/V
magdB = 20*log10(magvv);            % obtain mag of AC response in dB
phase = angle(complex)*180/pi;      % obtain phase of AC response in deg


% plotting the required plots in 2 by 2 grid using subplot
subplot(2,2,1)
semilogx(freq,magdB)
xlabel('Freq (Hz)')
ylabel('Magnitude (dB)')


% fill your code here
% ...
% fill up your code to plot freq vs magdB
subplot(2,2,2)
plot(freq,magdB)
xlabel('Freq (Hz)')
ylabel('Magnitude (dB)')


% and log freq vs phase
subplot(2,2,3)
semilogx(freq,phase)
xlabel('Freq (Hz)')
ylabel('Phase (deg)')
% type "help subplot" in command window if you are not familiar with
% subplot function in matlab


subplot(2,2,4)
semilogx(freq,magvv)
xlabel('Freq (Hz)')
ylabel('Magnitude (V/V)')