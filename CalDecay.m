function Decay = CalDecay(Graph, Arc, DecayRate, CoopNum)
%����˥���ʣ������ڵ�����������ʱ��ѡ��ʱ����ѡ��õ�
%���룺
%Graph:��¼����ÿ��Ľڵ���
%Arc:��¼����ߵ�����
%DecayRate����ʾ˥��ǿ����Խ����˥��Խ����
%CoopNum: ����������
%�����
%Decay��˥��ϵ��
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