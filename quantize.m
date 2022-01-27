function [quantized, symbol, symbols_rowVector, quantized_unique] = quantize(x,t)

    %quantize
figure(3)
max_val=max(x);
min_val=min(x);

mse_=[];
for q=3:250
    levels=q;
    quantized=[];
    symbol=[];
    delta=linspace(min_val,max_val,levels);
    for i=1:length(x)
        if(x(i)==max_val)
            quantized=[quantized (delta(levels)+delta(levels-1))*0.5];
            symbol=[symbol levels-1];
    end
    for j=1:levels-1
        if(x(i)>delta(j) && x(i)<=delta(j+1))
            quantized=[quantized (delta(j)+delta(j+1))*0.5];
            symbol=[symbol j-1];
        end 
    end
end
    mse=((sum((quantized-x).^2))/length(x));
    mse_=[mse_ mse];
end


plot(3:1:250,mse_)
title("MSE vs Levels")
xlabel("Levels")
ylabel("MSE")

figure(4)
levels=32;
quantized=[];
symbol=[];
delta=linspace(min_val,max_val,levels);

for i=1:length(x)
    if(x(i)==max_val)
        quantized=[quantized (delta(levels)+delta(levels-1))*0.5];
        symbol=[symbol levels-1];
    end
    for j=1:levels-1
        if(x(i)>delta(j) && x(i)<=delta(j+1))
            quantized=[quantized (delta(j)+delta(j+1))*0.5];
            symbol=[symbol j-1];
        end 
    end
end

Bitstream_symbol = dec2bin(symbol);
str_bit = "";
for i = 1:length(Bitstream_symbol)
    str_bit = strcat(str_bit,Bitstream_symbol(i));
end

disp('Bitstream of the encoded sample(5 bits per symbol)');
str_bit

symbols_rowVector = symbol;
plot(t,quantized,'.')
title("32 Level Uniform Quantization")
xlabel("Time")
ylabel("Amplitude")

quantized_unique =zeros(1,32);
for i = 1:length(quantized)
    quantized_unique(symbol(i)+1) = quantized(i);
end
mse
disp('bitstream size after quantization(5 bits per level)');
disp(length(x)*5);
end