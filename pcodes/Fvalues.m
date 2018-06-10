
function [X,jX] = Fvalues()
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
[fobj(3,:),fobj(4,:)] = criteria(X,params,data,scenarios);

% - Network sensibility (fobj5)
fobj(5,:) = sensibility(X,'casestudy',params);

% Pareto Dominance Analysis
[X,jX] = nondominatedpoints(X,fobj);

end





% Network merit functions
function [inrate,mfaultcost,mfincost] = criteria(x,params,data,scenarios)

Q = params.Q;   % nominal demand at internal nodes

ni = params.ni; % number of internal nodes
np = params.np; % number of pipes

N = size(x,2);          % number of solutions
n = length(scenarios);  % number of scenarios

fr = 0.001*ones(1,params.np);   % mean failure rate of each pipe
fd = ones(1,params.np);         % mean fault duration of each pipe
gas_tx = 0.10;                  % gas tax

for i = 1:N
    for j = 1:n        
        % Demand regarding the j-th scenario
        params.Q = Q + scenarios(j)*Q;
        
        % Update the data information
        data.qc = data.P * [data.F*params.Q; zeros(np-ni,1)];  % qc is any solution to Ai'*q = Q
        data.Y  = data.P * [-data.F*data.G; eye(np-ni)];       % Y is a np x (np-1) matrix s.t. Ai'*Y = 0
        
        % Calculate the network flow for the solution i
        [q,pi,~,cost] = networkflow(x(:,i),params,data);
        
        % Determine the number of nodes that violates the pressure bounds
        w = length(pi(pi<params.pmin)) + length(pi(pi>params.pmax));
        
        % Unfeasibility flag
        unflag(i,j) = min(1,w);        
        
        % Financial cost of solution i        
        fincost(i,j) = not(unflag(i,j))*cost;
        
        % Fault cost of solution i
        faultcost(i,j) = sum(fr .* fd .* params.L(:)' .* abs(q(:)') * gas_tx);
        faultcost(i,j) = not(unflag(i,j))*faultcost(i,j);
    end
    % Infeasibility rate 
    inrate(i) = sum(unflag(i,:))/n;
    
    % Mean financial cost of feasible solutions
    vec = fincost(i,:);
    nf  = length(vec(vec>0));   % number of feasible scenarios
    mfincost(i) = sum(fincost(i,:))/nf;
    
    % Mean fault cost of feasible solutions
    mfaultcost(i) = sum(faultcost(i,:))/nf;            
end
inrate = inrate(:)';
mfincost = mfincost(:)';
mfaultcost = mfaultcost(:)';
end





% Network sensibility function
% Determine the average error value w.r.t the pressure bounds
function sensrate = sensibility(S,networkname,params)

N = size(S,2);  % number of solutions
np = params.np; % number of pipes
ni = params.ni; % number of internal nodes

for i = 1:N
    for j = 1:np
        
        % Network parameters
        cd 'networks'
        load(networkname)
        cd ..
        
        % Demand regarding the sensibility analisys (MOST LIKELY SCENARIO AFTER 10 YEARS)
        params.Q = 1.28*params.Q;

        % Update the network by removing the pipe j
        x = S(:,i);
        x(j) = [];
        params.Ai(j,:) = []; 
        params.As(j,:) = [];
        params.np = params.np - 1;
        params.L(j) = [];                        
        data = networkdata(params);
        
        % Calculate the network flow for the modified solution i
        [~,pi,~,~] = networkflow(x,params,data);
        
        % Determine the number of nodes that violates the pressure bounds
        w = length(pi(pi<params.pmin)) + length(pi(pi>params.pmax));   
        
        % Determine the average error value w.r.t the pressure bounds
        r = sum( max(0,(params.pmin-pi)/params.pmin) + max(0,(pi-params.pmax)/params.pmax) )/max(w,eps);
        
        % Infeasibility flag        
        inflag(i,j) = r;
    end
    % Sensibility rate     
    inflagVec = inflag(i,:);
    sensrate(i) = sum(inflagVec)/max(length(inflagVec(inflagVec>0)),eps);
end
sensrate = sensrate(:)';
end

