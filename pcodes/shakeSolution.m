function sol = shakeSolution(sol, pos)
    changedItem = randi(6);
    sol(pos) = changedItem;
end