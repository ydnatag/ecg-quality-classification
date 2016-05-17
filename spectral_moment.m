function [ w_n ] = spectral_moment( signal, fs, order )
%SPECTRAL_MOMENT Summary of this function goes here
%   Detailed explanation goes here
    N = length(signal);
    sig_fft = abs(fft(signal)/N).^2;
    l =size(sig_fft,1)/2;
    dw = pi/l;
    
    if order==0
        w = ones(1,l);
    elseif mod(order,2)~=0
        w_n = zeros(1,size(signal,2));
        return;
    else
        w = linspace(0,pi,l).^order;
    end
    w_n =2* w*sig_fft(1:l,:)*dw;
end

