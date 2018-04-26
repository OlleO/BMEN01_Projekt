function [ histogramX] = deltaHistogram(X)

%Diff
dX=filter([1 -1], 1, X); %Corrupted?

histogramX = zeros(1,length(dX));

windowLength = 17; % lenght of the sliding window
halfWindow = floor(windowLength/2);

dX = [zeros(1, halfWindow), dX, zeros(1, halfWindow)]; % zero-pad to handle edges
 
for i = halfWindow+1:length(dX)-halfWindow
    x = dX(i-halfWindow:i+halfWindow);
    h = histcounts(x, 'BinWidth', 0.1, 'BinLimits', [-10 10]); 
    nonEmptyBins=length(find(h~=0));  
    histogramX(i-halfWindow) = nonEmptyBins/length(h); 
end
    
end

