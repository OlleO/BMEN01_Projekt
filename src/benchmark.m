function [sensitivity, specificity] = benchmark(ground_truth, Y)
maxPoints = length(Y); 

TP=0;
TN=0; 
FP=0; 
FN=0; 

for i=1:maxPoints 
    %Truevärden 
    if ground_truth(i)==Y(i)
        if Y(i)==1 
            TP=TP+1;
        else 
            TN=TN+1; 
        end
        
    else 
        if Y(i)==1
           FP=FP+1;  
        else 
           FN=FN+1;   
        end
    end    
end

%Sensitivity 
sensitivity=TP/(TP+FN); 
specificity=TN/(TN+FP); 

end
