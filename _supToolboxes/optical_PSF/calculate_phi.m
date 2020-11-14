   
% calculation of phi matrix
function phi = calculate_phi(NPXLS)
    N = (NPXLS-1)/2; A = (-N:1:N); XX = [A]; YY = [-A'];
    X = repmat(XX,NPXLS,1); 
    Y = repmat(YY,1,NPXLS); 
    phi = atan2(Y,X);
end