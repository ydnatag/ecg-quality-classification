function Hd = FilterBaseLine (Fs)

if (nargin > 0  && isnumeric(Fs) && Fs > 0)

    Fpass = 1;       % Passband Frequency
    Fstop = 3;       % Stopband Frequency
    Apass = 0.5;     % Passband Ripple (dB)
    Astop = 40;      % Stopband Attenuation (dB)
    match = 'both';  % Band to match exactly

    h  = fdesign.lowpass(Fpass, Fstop, Apass, Astop, Fs);
    Hd = design(h, 'ellip', 'MatchExactly', match);

else
    Hd = NaN;
end

