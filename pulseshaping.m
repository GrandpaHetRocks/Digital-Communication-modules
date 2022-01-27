function [encoded_final_rc1, t2, Tb] = pulseshaping(long_bitstream, roll_offs)

figure
encoded_data = long_bitstream(1:20);

Tb = 0.2; %bit duration
sampling_freq=1000;
t2 = 0*Tb:1/(sampling_freq*Tb):length(encoded_data)*Tb;
Bo=1/(2*Tb);
fr=-1.2*Bo:(2.4*Bo)/(length(t2)-1):1.2*Bo;

% roll_offs=[0 0.3 0.6 0.99];

for j=roll_offs
r2=j;
t1 = -length(encoded_data)/2*Tb:1/(sampling_freq*Tb):length(encoded_data)/2*Tb;
ah = sinc(2*Bo.*t1).*(cos(2*pi*r2*Bo.*t1)./(1-(16*(r2^2)*(Bo^2).*(t1.^2))));
hold on
plot(t1,ah)
end
legend("0","0.3","0.6","0.99")
title("Raised Cosine Filters in Time Domain")
xlabel("Time");
ylabel("Amplitude")

figure

for j=roll_offs
    encoded_final_rc1=zeros(1,length(t2));
    b=0; %to shift pulses in time domain
    r2=j;
for i = 1:length(encoded_data)
    hoho=sinc(2*Bo.*(t2-(b*Tb)))...
                    .*(cos(2*pi*r2*Bo.*(t2-(b*Tb)))...
                    ./(1-(16*(r2^2)*(Bo^2).*((t2-(b*Tb)).^2))));
    if(encoded_data(i) == 1)
        encoded_final_rc1=encoded_final_rc1+hoho;
    else
        encoded_final_rc1=encoded_final_rc1-hoho;
    end
    b=b+1;
end
hold on
plot(t2,encoded_final_rc1,'linewidth',1);
end
legend("0","0.3","0.6","0.99")
title("Transmit Signal (20 bits)")
xlabel("Time");
ylabel("Amplitude")

figure

for j=roll_offs
    encoded_final_rc1=zeros(1,length(t2));
    b=0; %to shift pulses in time domain
    r2=j;
for i = 1:length(encoded_data)
    hoho=sinc(2*Bo.*(t2-(b*Tb)))...
                    .*(cos(2*pi*r2*Bo.*(t2-(b*Tb)))...
                    ./(1-(16*(r2^2)*(Bo^2).*((t2-(b*Tb)).^2))));
    if(encoded_data(i) == 1)
        encoded_final_rc1=encoded_final_rc1+hoho;
    else
        encoded_final_rc1=encoded_final_rc1-hoho;
    end
    b=b+1;
end
oh=fft(encoded_final_rc1);
hold on
plot(fr,fftshift(abs(oh)))
end
legend("0","0.3","0.6","0.99")
title("Transmit Signal (20 bits) Freq Domain")
xlabel("Frequency");
ylabel("Amplitude")


figure

for j=roll_offs
r2=j;
t1 = -length(encoded_data)/2*Tb:1/(sampling_freq*Tb):length(encoded_data)/2*Tb;
ah = sinc(2*Bo.*t1).*(cos(2*pi*r2*Bo.*t1)./(1-(16*(r2^2)*(Bo^2).*(t1.^2))));
oh=fft(ah);
hold on
plot(fr,fftshift(abs(oh)))
end
legend("0","0.3","0.6","0.99")
title("Raised Cosine Filters in Frequency Domain")
xlabel("Frequency")
ylabel("Amplitude")

%roll off factor of 0.7 taken according to minimum ISI  and bandwidth
%tradeoff

Tb=0.5;
sampling_frequency=100;
t2 = 0*Tb:1/(sampling_freq*Tb):length(long_bitstream)*Tb;
Bo=1/(2*Tb);
fr=-1.2*Bo:(2.4*Bo)/(length(t2)-1):1.2*Bo;
encoded_final_rc1=zeros(1,length(t2));
r2=0.7;
for i = 1:length(long_bitstream)
    hoho=sinc(2*Bo.*(t2-(b*Tb)))...
                    .*(cos(2*pi*r2*Bo.*(t2-(b*Tb)))...
                    ./(1-(16*(r2^2)*(Bo^2).*((t2-(b*Tb)).^2))));
    if(long_bitstream(i) == 1)
        encoded_final_rc1=encoded_final_rc1+hoho;
    else
        encoded_final_rc1=encoded_final_rc1-hoho;
    end
    b=b+1;
end

end