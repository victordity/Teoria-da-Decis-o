function s = fmeasure(sol, theta, tamSol)
solPesos = zeros(tamSol,1);
for i=1: tamSol
    solPesos(i) = theta(sol(i));
end
s = sum(solPesos);
end