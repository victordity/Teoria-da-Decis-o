function [fobj1] = Fvalues1(sol)
% Return the Function Values of the solutions found by the algorithm

% Network solutions
load solutions

% Uncertainty scenarios
load scen

% Network parameters
cd 'networks'
load('casestudy')
cd ..
data = networkdata(params);

% Eliminate infeasible solutions
infSol = find(Pmin<params.pmin);
Cost(infSol) = [];
Pmin(infSol) = [];
Pfun(infSol) = [];

% Atribui o custo para a solucao atual
[tamSol, nSol] = size(sol);
custoTotal = zeros(1, nSol);
for i = 1: nSol
    for j = 1: tamSol
       custoTotal(i) = custoTotal(i) + params.C(1, sol(j,i)); 
    end 
end
fobj1 = custoTotal;

end