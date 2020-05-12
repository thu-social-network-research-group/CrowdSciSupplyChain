function GraphPoint = CalGarphPoint(Graph)
%计算每个点在图像中的位置
%输入：Graph：图结构
%输出：GraphPoint：图在图像中的位置，二维数组
len = length(Graph);
PointNum = max(Graph{len});
GraphPoint = zeros(PointNum, 2);
temp = 1;
for i = 1 : len
    len2 = length(Graph{i});%本层节点数
    for j = 1 : length(Graph{i})
        GraphPoint(temp, 1) = i*5;
        GraphPoint(temp, 2) = j/len2*10;
        temp = temp + 1;
    end
end
end