%更新t时刻各节点的产值V
%以上一时刻产值为均值，弹性值为方差做高斯分布
function V = V_calc(R,V,V_sigma)
    for i = 1:length(V)
        for j = 1:length(V{i})
            V{i}(j) = normrnd(V{i}(j), V_sigma*R{i}(j)); 
    end
end 
