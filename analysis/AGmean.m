function [ an ] = AGmean(a0, g0)
%AGmean Summary of this function goes here
%   Detailed explanation goes here
tolerance = 1E-10;


an = 0.5*(a0 + g0);
gn = sqrt(a0 * g0);

while abs(an - gn) > tolerance
    an = 0.5*(an +gn);
    gn = sqrt(an *gn);
end
