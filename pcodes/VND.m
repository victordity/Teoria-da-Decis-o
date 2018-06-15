function sol = VND(fobj, sol, nsol)
 
    tamSol = size(sol);
    for i=1:tamSol(1)
        newSol = shakeSolution(sol, i);
        newFobj = Fvalues1(newSol);
        if fobj > newFobj
            fobj = newFobj;
            sol(i,1) = newSol(i,1);
        end
    end
end