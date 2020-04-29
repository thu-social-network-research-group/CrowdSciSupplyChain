%初始化节点的弹性值
function R = R_initial(Graph)
    R = Graph; 
    for i = 1:length(R)
        for j = 1:length(R{i})
            R{i}(j) = betarnd(2,5);
        end
    end
end