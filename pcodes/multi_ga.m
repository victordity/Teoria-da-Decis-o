function multi_ga(x,params,data)

MAX_ITER = 10;
sobreviventes = [];
p_crossover = 0.7;
p_mutation = 0.15;
n_generation = 1;
param_limitador = 50;
[nrow,ncol] = size(x);
cont =1;
%[Cost,Pmin,Pfun] = evaluate(x,params,data);

while n_generation < MAX_ITER 
   
   % probabilidade de cruzamento
    for i=1: ncol-1
        for j=i+1:ncol
            if rand < p_crossover
                [filho1,filho2] = crossover(x(:,i),x(:,j));
                
                pop_filhos(:,cont) = [filho1];
                pop_filhos(:,cont+1) = [filho2];
                cont = cont+2;
            end

        end
    end

    [~,ncol_POP] = size(pop_filhos);

   % probabilidade de mutacao
    for i=1: ncol_POP
        if rand < p_mutation;
            [pop_filhos(:,i)] = mutacao(pop_filhos(:,i));
        end
    
    end
     new_pop = [x,pop_filhos];

    % Evolucao
    
    [Cost,Pmin,Pfun] = evaluate(new_pop,params,data);
    Pmin = -Pmin;
    [x,Cost,Pmin,Pfun] = removeInfeasible(new_pop,params,Cost,Pmin,Pfun);
    % Teste de ordenacao por dominancia
    [idx] = non_dominated_sort(Cost,Pmin,x);
    bestCost(n_generation) = Cost(idx(1));
    bestPressure(n_generation) = Pmin(idx(1));
    % [~,idx] = sort(Cost);
    % bestCost(n_generation) = Cost(idx(1));
    % bestPressure(n_generation) = Pmin(idx(1));
    
    n_generation = n_generation+1;
    
    % Atribuir os dois melhores sobreviventes ao vetor de sobreviventes
    %evolui = taxaSobreviventes*
    [~,s] = size(idx);
    s = ceil(0.3*s);
    sobreviventes  = [x(:,idx(1:s)), sobreviventes];
    X = cria_pop();
    x = podaPop(x, param_limitador);
    x = [sobreviventes,X];
    % Rodar o while ate o size da matriz for 50
     
end
% Plot the solutions versus the monetary costs
    [Cost,Pmin,Pfun] = evaluate(sobreviventes,params,data);
    Pmin = -Pmin;
    plot(Pmin, Cost,'.');
    figure
    [~,idx] = sort(Cost);
    Y = fliplr(Cost(idx));
    plot(Y,'ko','MarkerFaceColor',[0 0 0],'MarkerSize',2)
    xlabel('Solution'), ylabel('Monetary cost (nominal condition)')
    
    figure
    plot([1:n_generation-1],bestCost,'ko',[1:n_generation-1],bestPressure,'g');
    title('geracao x solucao')
    
    figure
    plot([1:n_generation-1],bestCost);
    
    figure
    plot([1:n_generation-1],bestPressure);

    drawnow
    % plot(Cost,Pmin,'o')
end
function X = cria_pop()
np = 21;
N  = 10; % number of solutions
lb = 1;  % lower bound
ub = 6;  % upper bound
X  = (lb + (ub-lb).*rand(np,N));
X  = round(X);
end

function [pop,Cost,Pmin,Pfun] = removeInfeasible(pop,params,Cost,Pmin,Pfun)

infSol = find(Pmin<params.pmin);
pop(:,infSol) = [];
Cost(infSol) = [];
Pmin(infSol) = [];
Pfun(infSol) = [];

infSol2 = find(Pmin > params.pmax);
pop(:,infSol2) = [];
Cost(infSol2) = [];
Pmin(infSol2) = [];
Pfun(infSol2) = [];
end
function [filho1, filho2] = crossover(p1,p2)
    pos_corte = randi(21);
    filho1 = [ p1(1:pos_corte); p2(pos_corte+1:end)];
    filho2 = [ p2(1:pos_corte); p1(pos_corte+1:end)];

end

function [individuo] = mutacao(individuo)
    pos_troca = randi(21);
    gene = randi(6);
    
    individuo(pos_troca,1) = gene;
end

function [indOrdenado] = non_dominated_sort(Cost, Pmin, x)
% Inicializa a populacao nao dominada e a matriz de avaliacao
popSort(1,1) = 1;
popSort(2,1) = Cost(1);
popSort(3,1) = Pmin(1);
[~, nPop] = size(x);
% Indicador de dominancia
flag = 0;
% Compara todos os individuos com eles mesmos
for i=2:nPop
    [~,nPopSort] = size(popSort);
    for j=1:nPopSort
        % Se a solucao atual dominar alguem na matriz, insere na posicao
        if (Cost(i) < popSort(2,j)) && (Pmin(i) < popSort(3,j))
            matAux(1,1) = i;
            matAux(2,1) = Cost(i);
            matAux(3,1) = Pmin(i);
            popSort = [popSort(:,1:j-1) matAux popSort(:,j:end)];
            flag = 1;
            break;
        end
    end
    % Se a solucao atual nao dominou ninguem, coloca ela no final
    if flag == 0
       popSort(1,nPopSort + 1) = i;
       popSort(2,nPopSort + 1) = Cost(i);
       popSort(3,nPopSort + 1) = Pmin(i);
    end
    flag = 0;
end
% Apos definir a posicao dos individuos, ordene a populacao de acordo com a
% dominancia
for i=1:nPop
    newPop(:,i) = x(:,popSort(1,i)); 
    newCost(1,i) = Cost(popSort(1,i));
    newPmin = Pmin(popSort(1,i));
end
indOrdenado = popSort(1,:);
end

function [x] = podaPop(x, limite)
[~, nPop] = size(x);
if nPop > limite
   matAux = x(:,1:limite);
   x = matAux;
end

end