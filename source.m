%source
function [nqr] = source(y2,w,fs,x, N)
    figure(2)
    subplot(3,1,1)
    [val,argmax]=max(abs(y2));
    max_freq=abs(w(argmax));
    nqr=max_freq*2;

    nqr_greater=nqr*5;
    [P,Q]=rat(nqr_greater/fs);
    x1=resample(x,P,Q);
    % x1=x(1:length(t1))';

    df = nqr_greater / N;
    w = (-(N/2):(N/2)-1)*df;
    y = fft(x1, N) / N; % For normalizing
    y2 = fftshift(y);
    plot(w,abs(y2));
    title("Sampled at F>NQR")
    xlabel("Frequency")
    ylabel("Amplitude")

    not_nqr=nqr/5;
    [P,Q]=rat(not_nqr/fs);
    x2=resample(x,P,Q);

    df = not_nqr / N;
    w = (-(N/2):(N/2)-1)*df;
    y = fft(x2, N) / N; % For normalizing
    y2 = fftshift(y);
    subplot(3,1,2);
    plot(w,abs(y2));
    title("Sampled at F<NQR")
    xlabel("Frequency")
    ylabel("Amplitude")

    at_nqr=nqr;
    [P,Q]=rat(at_nqr/fs);
    x3=resample(x,P,Q);
    t3=0:1/nqr:3;

    df = at_nqr / N;
    w = (-(N/2):(N/2)-1)*df;
    y = fft(x3, N) / N; % For normalizing
    y2 = fftshift(y);
    subplot(3,1,3);
    plot(w,abs(y2));
    title("Sampled at F=NQR")
    
    xlabel("Frequency")
    ylabel("Amplitude")
end