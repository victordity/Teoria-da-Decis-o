function [X,jX,fobj] = Fvalues1()
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
X(:,infSol) = [];
Cost(infSol) = [];
Pmin(infSol) = [];
Pfun(infSol) = [];

% Original cost of network (fobj1)
fobj(1,:) = Cost(:)';

% Negative minimum node pressure of original network (fobj2)
fobj(2,:) = -Pmin(:)';

% Additional merit functions
% - Infeasibility rate of network (fobj3)
% - Mean fault cost of feasible networks (fobj4)
% [fobj(3,:),fobj(4,:)] = criteria(X,params,data,scenarios);
% 
% % - Network sensibility (fobj5)
% fobj(5,:) = sensibility(X,'casestudy',params);

% Pareto Dominance Analysis
[X,jX] = nondominatedpoints(X,fobj);

end