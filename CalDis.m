function Dis = CalDis(Graph, Arc, Coopnum)
Dis = [];
LayerNum = length(Graph);
for i = 1 : LayerNum-1
    %前层连接
    temp = length(Graph{i});
    for j = 1 : temp
        temp2 = length(find(Arc{i}(:, 1) == Graph{i}(j)));
        Dis = [Dis temp2];
    end
    %后层连接
    temp = length(Graph{i+1});
    for j = 1 : temp
        temp2 = length(find(Arc{i}(:, 2) == Graph{i+1}(j)));
        Dis = [Dis temp2];
    end
    
end