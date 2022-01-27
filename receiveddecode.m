function [decode] = receiveddecode(encoded_final_rc1,t2, Tb)

    decode=[];
    for i=1:length(t2)
        if(mod(t2(i),Tb)==0)
        decode=[decode encoded_final_rc1(i)];
        end
    end
    decode=uint8((decode+1)/2);
end