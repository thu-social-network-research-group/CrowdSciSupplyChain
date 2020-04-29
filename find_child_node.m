%%寻找某个节点的下层节点，返回一个friend_list矩阵
function childs=find_child_node(Graph,Arc,i,j)
    if i==length(Graph)
        childs=0;
    else
        childs=[];
        for u=1:length(Arc{i})
            if Arc{i}(u,1)==Graph{i}(j)
                childs=[childs,Arc{i}(u,2)];
            end
        end
    end     
end

