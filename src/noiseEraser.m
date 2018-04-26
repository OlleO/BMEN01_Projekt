function [smoothDetectRR] = noiseEraser(X)
smoothDetectRR = zeros(1,length(X));

windowLength = 11; % lenght of the sliding window
threshold=0.6; 
halfWindow = floor(windowLength/2);

X = [zeros(1, halfWindow), X, zeros(1, halfWindow)]; % zero-pad to handle edges


for i = halfWindow+1:length(X)-halfWindow
    x = X(i-halfWindow:i+halfWindow);
    m = mean(x);
    if  m>threshold
        smoothDetectRR(i-halfWindow)=1;
    else 
        smoothDetectRR(i-halfWindow)=0;
    end
end


end

