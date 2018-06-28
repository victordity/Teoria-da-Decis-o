function sol = VND(fobj, sol)
 
    tamSol = size(sol);
    i = randi(21);
    newSol = shakeSolution(sol, i);
    newFobj = fmeasure(newSol, theta, tamSol(1));
    if fobj > newFobj
        fobj = newFobj;
        sol(i,1) = newSol(i,1);  
    end
end