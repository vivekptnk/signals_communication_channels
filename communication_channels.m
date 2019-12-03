%partA
pulse = [zeros(1,2),ones(1,10),zeros(1,2)];
ind1 = [0:1:13];
stem(ind1,pulse);

%partB
rng(00708981);
bits = randi([0 1],1,20);
ind = [1:1:20];
stem(ind,bits);
B = bits;

for i = 1:20
    if B(i) == 0 
        B(i) = -1;
        i = i+1;
    else
        i = i+1;
    end 
end

stem(ind,B);

%partC
negpulse = -pulse;
x = []
for i = 1:20 
    if B(i) == 1
        x = horzcat(x,pulse);
        i = i + 1;
    else 
        x = horzcat(x,negpulse);
        i = i + 1;
    end
end

Fs = 10e3;
t = [0:1/Fs:279/Fs];
plot(t,x);
        
axis([-2/Fs 32/Fs -1.5 1.5]);


%partD



    