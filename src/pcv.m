function P_cv = pcv(X)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

P_cv = zeros(1,length(X));

windowLength = 17; % lenght of the sliding window
halfWindow = floor(windowLength/2);

X = [zeros(1, halfWindow), X, zeros(1, halfWindow)]; % zero-pad to handle edges


for i = halfWindow+1:length(X)-halfWindow
    x = X(i-halfWindow:i+halfWindow);
    m = mean(x);
    sigma = std(x);
    P_cv(i-halfWindow) = sigma/m;
end

end

