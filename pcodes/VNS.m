function X = VNS(X, cost)
    
    [tamSol, nSol] = size(X);
    for i=1:nSol
        jx = VND(X(:,i), cost);
        X(:,i) = jx;
    end
    
end