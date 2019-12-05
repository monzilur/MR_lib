function [output] = gammatone_response(amplitude,time,order,bandwidth,...
    frequency,phase)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
a = amplitude;
t = time;
n = order;
b = bandwidth;
f = frequency;
phi =phase;
output = a.*t.^(n-1).*exp(-2.*pi.*b.*t).*sin(2.*pi.*f.*t + phi);
end

