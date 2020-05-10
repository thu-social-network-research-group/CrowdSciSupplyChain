%更新t时刻各节点的产�?V
%以上�?��刻产值为均�?，弹性�?为方差做高斯分布
function V = V_calc(R,V,V_sigma)
    for i = 1:length(V)
        for j = 1:length(V{i})
            V{i}(j) = normrnd(V{i}(j), V_sigma); 
    end
end 
