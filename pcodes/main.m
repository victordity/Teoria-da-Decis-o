
function main()

% Network's parameters
cd 'networks'
load('casestudy')
cd ..
data = networkdata(params); 

% Initialization
N  = 10; % number of solutions
lb = 1;  % lower bound
ub = 6;  % upper bound
X  = (lb + (ub-lb).*rand(params.np,N));
X  = round(X);

% Evaluation of the candidate solutions
[Cost,Pmin,Pfun] = evaluate(X,params,data);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% optimization algorithm
%
% DEVE SER DESENVOLVIDO PELOS ALUNOS 
% PODE SER BASEADO EM TRAJETÓRIA OU POPULAÇÃO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


save solutions X Cost Pmin Pfun

% Plot the solutions versus the monetary costs
figure
[~,idx] = sort(Cost);
Y = Cost(idx);
plot(Y,'ko','MarkerFaceColor',[0 0 0],'MarkerSize',2)
xlabel('Solution'), ylabel('Monetary cost (nominal condition)')
drawnow

% Calculate the Function Values of the solutions found by the algorithm
[X,jX] = Fvalues();

save effSolutions X jX
