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


%partD
%1
bn0 = [1 0 0 0.9]; %initial bn coefficients
a = [1 0 0 0]; %default aa value
f = filter(bn0, a, pulse); %a) running the pulse through the filter

n = 1:1:14; %indices for the stem plot 

figure
stem(n,f);%b) stem plot for the filter
title("Output vs n")
xlabel("n vallues")
ylabel("output values from the filter")

%2
bn1 = [6 0 0 0.9];% bn1 for sampling 6 and amplitude of 0.9
bn2 = [12 0 0 0.7]; %bn2 do sampling and amplitude of 0.7
f1 = filter(bn1,a,pulse); % passing pulse through bn1
bn = filter(bn2,a,f1); % passing f1(bn1) through bn2

figure
zplane(bn) % a)pole-zero
title("Pole-Zero Plot")

[H,f] = freqz(bn) %freq resp
dbbn = mag2db(abs(H)); %convert to decibal scale

figure 
plot(f/pi,dbbn)%b) plotting frequency response in dB scale
title("Frequency Response (dB Scale)")
xlabel("frequency(rad/sec)")
ylabel("Magnitude (dB)")










    