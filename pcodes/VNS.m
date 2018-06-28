function X = VNS(fobj, X)
    
    [tamSol, nSol] = size(X);
    for i=1:nSol
        jx = VND(fobj(1,i), X(:,i));
        X(:,i) = jx;
    end
end
    
