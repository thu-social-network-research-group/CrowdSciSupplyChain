function [A,V] = calcu_V(Graph)
%计算A,V
A = Graph; min_A = 3; max_A = 10;  %节点i的能力A(i)
V = Graph; %节点i的产量V(i,t)
for i = 1:length(A)
    for j = 1:length(A{i})
        A{i}(j) = randi([min_A, max_A]);
        V{i}(j) = betarnd(2,5)*A{i}(j);
    end
end
end

function V = updateV(V,R)
for i = 1:length(V)
    for j = 1:length(V{i})
        V{i}(j) = normrnd(V{i}(j), 0.01*R{i}(j));
    end
end
end 
