
function [P,jP] = nondominatedpoints(P,jP)
% Eliminate the Pareto dominated points

% P : candidate solutions (varDim x N)
% jP: objective values (objDim x N)

[objDim, N] = size(jP);
I = repmat(jP(:),1,N) <= repmat(jP,N,1);
I = reshape(I',N,objDim,N);
I = prod(double(I),2);
I = sum(I(:,:),2) > 1;

% Eliminate dominated subproblems
P(:,I)  = [];
jP(:,I) = [];

