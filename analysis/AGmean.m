function [ an ] = AGmean(a0, g0)
%AGmean Combination of statistical and geometric means for two numbers
%   Iterate on both means until the values converge to a single value.
%   Is this just some numberical approximation of the geometric mean?
%
%   NOTE: I really don't like this function, it troubles me - Savo
%
% Inputs:
%   a0 - Initial statistical average (mean)
%   g0 - Initial geometric average
%
% Outputs: 
%   an - Some mutatant mean between the geometric and statistical means

tolerance = 1E-10;

an = 0.5 * (a0 + g0); % Statistical Mean (average)
gn = sqrt(a0 * g0); % Geometric mean

while abs(an - gn) > tolerance
    an = 0.5 * (an + gn);
    gn = sqrt(an * gn);
end
