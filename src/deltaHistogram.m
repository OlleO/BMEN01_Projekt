function [ histogramX] = deltaHistogram(X)

X = medfilt1(X);

% Diff
dX=filter([1 -1], 1, X); % Corrupted?

histogramX = zeros(1,length(dX));

lim = 3;
windowLength = 17; % lenght of the sliding window
halfWindow = floor(windowLength/2);

dX(dX > lim) = lim;
dX(dX < -lim) = -lim;

dX = [zeros(1, halfWindow), dX, zeros(1, halfWindow)]; % zero-pad to handle edges
 
for i = halfWindow+1:length(dX)-halfWindow
    x = dX(i-halfWindow:i+halfWindow);
    h = histcounts(x, 'BinWidth', 0.1, 'BinLimits', [-lim lim]); 
    nonEmptyBins=length(find(h~=0));  
    histogramX(i-halfWindow) = nonEmptyBins/length(h); 
end
    
end

