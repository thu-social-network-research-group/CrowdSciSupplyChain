%%返回Graph{i}(j)父节点的总产值
function sum_parents_V = calc_parents_V(Graph,Arc,V_list,i,j)
    if i==1
        sum_parents_V = 0;
    else
        parents = [];
        sum_parents_V = 0;
        for u = 1:size(Arc{i-1}, 1)
            if Arc{i-1}(u,2)==Graph{i}(j)
                sum_parents_V=sum_parents_V+V_list(Arc{i-1}(u,1));
            end
        end
    end     
end
