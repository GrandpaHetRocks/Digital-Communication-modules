% Huffman decoding
function [final_sig] = tablelookup(decode, final_codebook, quantized_unique, t, f_aud)

    stream = decode;
    arr = final_codebook;
    symbol = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","a","b","c","d","e","f"];
    decoded_data=[];
    window=0;
    pointer = 1;
    while(pointer<=length(stream))
        %disp(pointer+window);
        if(pointer+window>length(stream))
            break;
        end
        s1 = char(stream(pointer:pointer+window)+ '0');
        %s1 = string(stream(pointer:pointer+window))
        find_s1 = strmatch(s1,arr,"exact");
        if(length(find_s1)==0)
            window = window + 1;
            %disp("Unmatched");
        else
            s2 = symbol(find_s1);
            decoded_data = [decoded_data ; s2];
            pointer = pointer+window+1;
            window = 0;
        end
        %disp("Hello");
    end

    % decoded_data=char(num2cell(decoded_data));
    % decoded_data=string(reshape(str2num(Output),1,[]))
    levels_decoded = zeros(1,length(decoded_data));
    for i = 1 : length(decoded_data)
        %disp(decoded_data(i));
        if(decoded_data(i)=="A")
    %         disp("KL");
            levels_decoded(i)=0;
        end
        if(decoded_data(i)=="B")
            levels_decoded(i)=1;
        end
        if(decoded_data(i)=="C")
    %         disp("PP");
            levels_decoded(i)=2;
        end
        if(decoded_data(i)=="D")
            levels_decoded(i)=3;
        end
        if(decoded_data(i)=="E")
            levels_decoded(i)=4;
        end
        if(decoded_data(i)=="F")
            levels_decoded(i)=5;
        end
        if(decoded_data(i)=="G")
            levels_decoded(i)=6;
        end
        if(decoded_data(i)=="H")
            levels_decoded(i)=7;
        end
        if(decoded_data(i)=="I")
            levels_decoded(i)=8;
        end
        if(decoded_data(i)=="J")
            levels_decoded(i)=9;
        end
        if(decoded_data(i)=="K")
            levels_decoded(i)=20;
        end
        if(decoded_data(i)=="L")
            levels_decoded(i)=11;
        end
        if(decoded_data(i)=="M")
            levels_decoded(i)=12;
        end
        if(decoded_data(i)=="N")
            levels_decoded(i)=13;
        end
        if(decoded_data(i)=="O")
            levels_decoded(i)=14;
        end
        if(decoded_data(i)=="P")
            levels_decoded(i)=15;
        end
        if(decoded_data(i)=="Q")
            levels_decoded(i)=16;
        end
        if(decoded_data(i)=="R")
            levels_decoded(i)=17;
        end
        if(decoded_data(i)=="S")
            levels_decoded(i)=18;
        end
        if(decoded_data(i)=="T")
            levels_decoded(i)=19;
        end
        if(decoded_data(i)=="U")
            levels_decoded(i)=20;
        end
        if(decoded_data(i)=="V")
            levels_decoded(i)=21;
        end
        if(decoded_data(i)=="W")
            levels_decoded(i)=22;
        end
        if(decoded_data(i)=="X")
            levels_decoded(i)=23;
        end
        if(decoded_data(i)=="Y")
            levels_decoded(i)=24;
        end
        if(decoded_data(i)=="Z")
            levels_decoded(i)=25;
        end
        if(decoded_data(i)=="a")
            levels_decoded(i)=26;
        end
        if(decoded_data(i)=="b")
            levels_decoded(i)=27;
        end
        if(decoded_data(i)=="c")
            levels_decoded(i)=28;
        end
        if(decoded_data(i)=="d")
            levels_decoded(i)=29;
        end
        if(decoded_data(i)=="e")
            levels_decoded(i)=30;
        end
        if(decoded_data(i)=="f")
            levels_decoded(i)=31;
        end
    end

    final_sig = [];
    for i = 1 : length(levels_decoded)
        final_sig = [final_sig quantized_unique(levels_decoded(i)+1)];
    end 
    
    figure
    plot(t,final_sig(1:length(t)));
    xlabel('Time')
    ylabel('Signal(Amplitude)')
    title('Reconstructed Signal')
    audiowrite("out.wav",final_sig,f_aud);    
end