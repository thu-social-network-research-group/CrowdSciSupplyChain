function Dis = CalDis(Graph, Arc, Coopnum)
Dis = [];
LayerNum = length(Graph);
for i = 1 : LayerNum-1
    %ǰ������
    temp = length(Graph{i});
    for j = 1 : temp
        temp2 = length(find(Arc{i}(:, 1) == Graph{i}(j)));
        Dis = [Dis temp2];
    end
    %�������
    temp = length(Graph{i+1});
    for j = 1 : temp
        temp2 = length(find(Arc{i}(:, 2) == Graph{i+1}(j)));
        Dis = [Dis temp2];
    end
    
end