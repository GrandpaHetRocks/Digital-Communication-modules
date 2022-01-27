function [x,fs,t, y2, w, N] = input_audio(low_freq, high_freq, down_factor)
    downby=down_factor;                 %Downsampling factor
    [x,fs] = audioread('WID.wav');
    x=downsample(x,downby);
    fs=fs/downby;
    N = size(x,1); % Determine total number of samples in audio file    
    t=0:1/fs:3; 
    x=x(:,1)';
    x=x(1:length(t));

    x=bandpass(x,[low_freq high_freq],fs); %limiting spectrum

    figure(1);
    subplot(3,1,1);     
    plot(t,x);
    title("Input Band Limited Audio")
    xlabel("Time")
    ylabel("Amplitude")


    % Plot the spectrum
    df = fs / N;
    w = (-(N/2):(N/2)-1)*df;
    y = fft(x,N)/N; % For normalizing
    y2 = fftshift(y);
    subplot(3,1,2);
    plot(w,abs(y2));
    title("Band Limited Frequency Domain")
    xlabel("Frequency")
    ylabel("Amplitude")

    phase_x=angle(x);
    subplot(3,1,3);
    plot(t,phase_x)
    title("Phase")
    xlabel("Time")
    ylabel("Phase (rad)")
    
end