%PART A
pulse = [zeros(1,2),ones(1,10),zeros(1,2)]; %1. zeros and ones making the pulse
ind1 = [0:1:13]; %setting the indices to have 14 places for the stem plot
figure
stem(ind1,pulse); %the stem plot for PART A
title("PROTOTYPE PULSE");
xlabel("DT Time Index");
ylabel("Pulse Value")

%PART B
rng(00708981); %1. random number generator
bits = randi([0 1],1,20);%3 randi command to create a random sequence of 1x20 vector
ind = [1:1:20];%indices matching the 20 arrays for stem plot 
figure
stem(ind,bits);% 4. Stem plot-1  for PART B
title("RANDOM BIT STREAM");
xlabel("Indices");
ylabel("Random Bit Value");




B = bits; % initializing B for the conversion of 0s to -1s

for i = 1:20 %5. Conversion of 0s to -1 in a for loop and leaving the 1s to be 1s
    if B(i) == 0 
        B(i) = -1;
        i = i+1;
    else
        i = i+1;
    end 
end

figure
stem(ind,B); %6. Stem plot-2 for PART B
title("RANDOM BIT STREAM MODIFIED");
xlabel("Indices");
ylabel("Random Bit Value");

%PART C
negpulse = -pulse; %creating an inverted pulse of the prototype pulse
x = []; % initializing x
for i = 1:20 %1. making a for loop for creating a DT version of the illustrated figure using the prototype pulse and a negative of the prototpye pulse
    if B(i) == 1
        x = horzcat(x,pulse);
        i = i + 1;
    else 
        x = horzcat(x,negpulse);
        i = i + 1;
    end
end

Fs = 10e3;%2. Sampling Rate is 10kHz
t = [0:1/Fs:279/Fs]; % creating a time period for the 280 elements in x with the sampling rate of Fs = 10kHz
figure
plot(t,x);% plot of x and t
title("DT PULSE");
xlabel("Time (sec)")
ylabel("DT Values")

        
axis([-2/Fs 32/Fs -1.5 1.5]); % restricing the plot according to the guide


%PART D
%1
bn0 = [1 0 0 0.9]; %initial bn coefficients
a = [1 0 0 0]; %default aa value
f = filter(bn0, a, pulse); %a) running the pulse through the filter

n = 1:1:14; %indices for the stem plot 

figure
stem(n,f);%b) stem plot for the filter
title("Output vs n")
xlabel("n values")
ylabel("output values from the filter")

%2
bn1 = [6 0 0 0.9];% bn1 for sampling 6 and amplitude of 0.9
bn_2 = [12 0 0 0.7]; %bn2 do sampling and amplitude of 0.7
f1 = filter(bn1,a,pulse); % passing pulse through bn1
bn = filter(bn_2,a,f1); % passing f1(bn1) through bn_2

figure
zplane(bn); % a)pole-zero
title("Pole-Zero Plot for Multipath Channel #1")

[H,f] = freqz(bn); %freq resp
dbbn = mag2db(abs(H)); %convert to decibal scale

figure 
plot(f/pi,dbbn)%b) plotting frequency response in dB scale
title("Frequency Response (dB Scale)")
xlabel("frequency(rad/sec)")
ylabel("Magnitude (dB)")


%3
y = filter(bn,a,x); % a) applying input x to the filter with derived bn and default aa
tt = [0:1/Fs:279/Fs]; % time for both input and output signals with sampling rate 10kHz

figure
subplot(2,1,1)% b)Subplot for input plot
plot(tt,x); % input plot
title("Input Signal")
ylabel("Input Values x")
xlabel("Time (sec)")
axis([-2/Fs 32/Fs -1.5 1.5])

subplot(2,1,2)% Subplot for output plot
plot(tt,y);% output plot
title("Onput Signal")
ylabel("Onput Values y")
xlabel("Time (sec)")
axis([-2/Fs 32/Fs -900 900])

%4
xfft = fftshift(fft(x)); % FFT of x
yfft = fftshift(fft(y)); % FFT of y
    
[H1,f1] = freqz(x); % getting the frequency response of the input signal
[H2,f2] = freqz(y); % getting the frequency response of the output signal

figure
subplot(2,1,1)
plot(f1/pi, 20*log10(abs(H1))); %plotting the input signal 
title("Input Signal x");
xlabel("omega(rad/sec)");
ylabel("Magnitude of x (dB)")

subplot(2,1,2)
plot(f2/pi, 20*log10(abs(H2))); %plotting the output signal
title("Output Signal y");
xlabel("omega(rad/sec)");
ylabel("Magnitude of y (dB)");


% PART E
an_eq = bn;
bn_eq = 1;

iir_eq = fftshift(fft(an_eq),bn_eq); %1. creating the IIR equalizer.

figure
zplane(iir_eq); %2. PoleZero Plot for the IIR Equalizer
title("PZ plot for IIR Equalizer")

[H3, f3] = freqz(iir_eq); %Frequency Response of the IIR Equalizer

figure
plot(f3/pi, 20*log10(abs(H3)),'b',f/pi,dbbn,'r-'); %plotting both IIR equalizer and the channel response
legend("IIR Equalizer","Channel")
title("Frequency Response for IIR Equalizer and Channel");
xlabel("omega(rad/sec)")
ylabel("Magnitude (dB)")

%6 
% a) y already exists in PART D
% b) now for applying the channel output as input to a filter command
%    implementing the equalizer filter
y_eq  = filter(an_eq,bn_eq,y); % b)

% c)now plotting the x,y and y_eq v time in msec (tt is already declared as
% (0:1:279)/Fs
figure
subplot(3,1,1)
plot(tt,x); % plotting x
title("Plot of Input x")
xlabel("Time(in sec)")
ylabel("Magnitude of x")
axis([0 0.03 -5e5 5e5])

subplot(3,1,2)
plot(tt,y); % plotting y
title("Plot of output y")
xlabel("Time(in sec)")
ylabel("Magnitude of y")
axis([0 0.03 -5e5 5e5])


subplot(3,1,3)
plot(tt,y_eq) % plotting y_eq
title("Plot of output y eq")
xlabel("Time(in sec)")
ylabel("Magnitude of y eq")
axis([0 0.03 -5e5 5e5])

%7 Adding Gaussian Noise

y_n = y + 0.1*randn(1,280);
y_eq_n  = filter(an_eq,bn_eq,y_n); % Applying y equalizer on y_n

figure
subplot(3,1,1)
plot(tt,x); % plotting x
title("Plot of Input x")
xlabel("Time(in sec)")
ylabel("Magnitude of x")

subplot(3,1,2)
plot(tt,y_n); % plotting y
title("Plot of output y with Gaussian Noise")
xlabel("Time(in sec)")
ylabel("Magnitude of y n")

subplot(3,1,3)
plot(tt,y_eq_n) % plotting y_eq
title("Plot of output y with Gaussian Noise")
xlabel("Time(in sec)")
ylabel("Magnitude of y eq n")



% PART F
%1
bn3 = [6 0 0 0.9];% bn3 for sampling 6 and amplitude of 0.9
bn4 = [13 0 0 0.7]; %bn4 do sampling 13 and amplitude of 0.7
ff = filter(bn3,a,pulse); % passing pulse through bn3
bn2 = filter(bn4,a,ff); % passing ff(bn4) through bn2

figure
zplane(bn2) % 1a) PZ plot of the Multipath Channel #2
title("PZ plot for multipath channel #2")

[H4, f4] = freqz(bn2); % 

figure
plot(f4/pi, abs(H4)) % 1b) Freq Response of Multipath Channel #2
title("Frequency response of Multipath Channel #2")
xlabel("omega(rad/sec)")
ylabel("Magnitude")

figure
plot(f4/pi, 20*log10(abs(H4)))
title("Frequency response of Multipath Channel #2")
xlabel("omega(rad/sec)")
ylabel("Magnitude(dB)")


%2
y2 = filter(bn2,a,x); % Applying input signal x to this multipath channel

%3
an2_eq = bn2;
bn2_eq = 1;
iir_eq2 = fftshift(fft(an2_eq),bn2_eq); % IIR equalizer for the Multipath Channel #2

%4 PZ PLOTS
figure
zplane(iir_eq2)
title("PZ plot for IIR Equalizer 2")

%5
y2_eq = filter(an2_eq,bn2_eq,y2); % 5a)Appying the channel y2 in through the equalizer

%5b) Plotting the equlizer output (tt already declared)
figure
subplot(3,1,1)
plot(tt,x); % plotting x
title("Plot of Input x")
xlabel("Time(in sec)")
ylabel("Magnitude of x")

subplot(3,1,2)
plot(tt,y2); % plotting y
title("Plot of output y2")
xlabel("Time(in sec)")
ylabel("Magnitude of y2")

subplot(3,1,3)
plot(tt,y2_eq) % plotting y_eq
title("Plot of output y2 equalizer")
xlabel("Time(in sec)")
ylabel("Magnitude of y2 eq")


%6 Gaussian Noise
 y2_n = y2 + 0.1*randn(1,280); %6a
 y2_eq_n = filter(an2_eq,bn2_eq,y2_n); %6b
 
%6c Plotting the equalized y2
figure
subplot(3,1,1)
plot(tt,x); % plotting x
title("Plot of Input x")
xlabel("Time(in sec)")
ylabel("Magnitude of x")

subplot(3,1,2)
plot(tt,y2_n); % plotting y
title("Plot of output y2 n")
xlabel("Time(in sec)")
ylabel("Magnitude of y2 n")

subplot(3,1,3)
plot(tt,y2_eq_n) % plotting y_eq
title("Plot of output y2 equalizer n")
xlabel("Time(in sec)")
ylabel("Magnitude of y2 eq n")








    