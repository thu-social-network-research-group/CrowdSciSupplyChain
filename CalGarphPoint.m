function GraphPoint = CalGarphPoint(Graph)
%����ÿ������ͼ���е�λ��
%���룺Graph��ͼ�ṹ
%�����GraphPoint��ͼ��ͼ���е�λ�ã���ά����
len = length(Graph);
PointNum = max(Graph{len});
GraphPoint = zeros(PointNum, 2);
temp = 1;
for i = 1 : len
    len2 = length(Graph{i});%����ڵ���
    for j = 1 : length(Graph{i})
        GraphPoint(temp, 1) = i*5;
        GraphPoint(temp, 2) = j/len2*10;
        temp = temp + 1;
    end
end
end