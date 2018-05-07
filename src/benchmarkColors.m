function matriceGrande = benchmarkColors(targets,Y,rr)
% 1st row indices
% 2nd row colors
% 3rd row vectors for plotting

matriceGrande = cell(3,4);

targetZero = find(targets == 0);
targetOne = find(targets == 1);

detectZero = find(Y == 0);
detectOne = find(Y == 1);

% Target 0, Detect 0
matriceGrande{2,1} = 'b';
matriceGrande{1,1} = intersect(targetZero, detectZero);

% Target 1, Detect 1
matriceGrande{2,2} = 'g';
matriceGrande{1,2} = intersect(targetOne, detectOne);

% Target 1, Detect 0
matriceGrande{2,3} = 'r';
matriceGrande{1,3} = intersect(targetOne, detectZero);

% Target 0, Detect 1
matriceGrande{2,4} = 'y';
matriceGrande{1,4} = intersect(targetZero, detectOne);


for i=1:4
    matriceGrande{3,i} = NaN(1,length(rr));
    matriceGrande{3,i}(matriceGrande{1,i}) = rr(matriceGrande{1,i});
end

end

