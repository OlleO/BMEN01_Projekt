function Y = myClassifier(X, classifier)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

Y = predict(classifier, X');

Y=Y';
end

