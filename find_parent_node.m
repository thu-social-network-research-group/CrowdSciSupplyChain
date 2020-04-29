%%寻找某个节点的下层节点，返回一个friend_list矩阵
function parents=find_parent_node(Graph,Arc,i,j)
    if i==1
        parents=0;
    else
        parents=[];
        for u=1:length(Arc{i-1})
            if Arc{i-1}(u,2)==Graph{i}(j)
                parents=[parents,Arc{i-1}(u,1)];
            end
        end
    end     
end
