function P_cv = pcv(X)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

P_cv = zeros(1,length(X));

windowLength = 11; % kan användas för att slippa hardcode
X = [0 0 0 0 0 X 0 0 0 0 0];


for i = 6:length(X)-5
    x = X(i-5:i+5);
    m = mean(x);
    sigma = std(x);
    P_cv(i-5) = sigma/m;
end

end

