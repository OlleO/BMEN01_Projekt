function classifier = trainClassifier(X,Y)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
classifier = fitcknn(X',Y);

end

