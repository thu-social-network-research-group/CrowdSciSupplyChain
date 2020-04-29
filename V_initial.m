%初始化各节点产量，按照Beta分布，由[3,10]间的节点能力A约束
%V(t)->V(t+1)
function V = V_initial(Graph)
    A = Graph; min_A = 3; max_A = 10;  %节点i的能力A(i)
    V = Graph; %节点i的产量V(i,t)
    for i = 1:length(A)
        for j = 1:length(A{i})
            A{i}(j) = randi([min_A, max_A]);
            V{i}(j) = betarnd(2,5)*A{i}(j);
        end
    end
end