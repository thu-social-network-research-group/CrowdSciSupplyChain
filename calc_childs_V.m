%%寻找某个节点的下层节点，返回一个friend_list矩阵
function sum_childs_V = calc_childs_V(Graph,Arc,V_list,i,j)
    if i==length(Graph)
        sum_childs_V = 0;
    else
        sum_childs_V = 0;
        childs=[];
        for u=1:length(Arc{i})
            if Arc{i}(u,1)==Graph{i}(j)
                sum_childs_V = sum_childs_V+V_list(Arc{i}(u,2));
            end
        end
    end     
end

