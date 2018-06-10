
function [Cost,Pmin,Pfun] = evaluate(x,params,data)

N = size(x,2);

parfor i = 1:N
    
    % Calculate the network flow for solution i
    [~,pi,~,cost] = networkflow(x(:,i),params,data);
    
    % Number of nodes that violates the minimum pressure bound
    w = length(pi(pi<params.pmin));
    
    % Penalization function of solution i
    Pfun(i) = w*(params.C(end)-params.C(1))*sum(params.L);
    
    % Cost of solution i
    Cost(i) = cost;
    
    % Minimum node pressure of solution i
    Pmin(i) = min(pi);
end

