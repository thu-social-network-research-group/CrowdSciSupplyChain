%初始化节点的弹�?��??
function R = R_initial(Graph)
R = Graph;
for i = 1:length(Graph)
    for j = 1:length(Graph{i})
        R{i}(j) = betarnd(2,5);
    end
end
end