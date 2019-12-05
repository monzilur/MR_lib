function db = rms2db(rms)
    ref = 10.^(-94/20); % Or 2 e -5 N/m^2
    db = 20*log10(rms./ref);
end