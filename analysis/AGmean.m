function [ an ] = AGmean(a0, g0)
%AGmean 
%   Detailed explanation goes here
tolerance = 1E-10;

% Is this just some numberical approximation of the geometric mean?

an = 0.5 * (a0 + g0); % Statistical Mean (average)
gn = sqrt(a0 * g0); % Geometric mean

while abs(an - gn) > tolerance
    an = 0.5 * (an + gn);
    gn = sqrt(an * gn);
end
