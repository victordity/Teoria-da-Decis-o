function [x] = VND(x, cost)
 
    spaceSolutions = size(cost);
    tamSol = size(x);
    for i=1: tamSol
        jx = randi(spaceSolutions);
        if cost[x[i]] > cost[jx]
            x[i] = jx;
        end
    end
end