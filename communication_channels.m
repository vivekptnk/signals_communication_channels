%partA
pulse = [zeros(1,2),ones(1,10),zeros(1,2)];
x = [0:1:13];
stem(x,pulse);

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

    