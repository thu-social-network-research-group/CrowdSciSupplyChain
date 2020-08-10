function Decay = CalDecay(Graph, Arc, DecayRate, CoopNum)
%计算衰减率，即当节点连接数过多时，选择时倾向不选择该点
%输入：
%Graph:记录网络每层的节点编号
%Arc:记录网络边的连接
%DecayRate：表示衰减强弱，越大则衰减越明显
%CoopNum: 基本合作数
%输出：
%Decay：衰减系数
LayerNum = length(Graph);
Decay = cell(1, LayerNum);
for i = 1 : LayerNum
    temp = length(Graph{i});
    Decay{i} = zeros(2, temp);
end
D = Decay;

for i = 1 : LayerNum - 1
    temp = length(Graph{i});
    for j = 1 : temp
        D{i}(2, j) = length(find(Arc{i}(:, 1) == Graph{i}(j)));
        Decay{i}(2, j) = 1 - DecayRate*D{i}(2, j)/CoopNum;
    end
    
    temp = length(Graph{i+1});
    for j = 1 : temp
        D{i+1}(1, j) = length(find(Arc{i}(:, 2) == Graph{i+1}(j)));
        Decay{i+1}(1, j) = 1 - DecayRate*D{i+1}(1, j)/CoopNum;
    end
end
end