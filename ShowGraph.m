function ShowGraph(GraphPoint, Arc)
%��ͼ����
%���룺
%GraphPoint������õ��ĸ���λ��
%Arc��ͼ������
scatter(GraphPoint(:,1),GraphPoint(:,2),'filled');
hold on
len1 = length(Arc);
for i = 1 : len1
    len2 = size(Arc{i},1);
    for j = 1 : len2
        p1 = Arc{i}(j, 1);
        p2 = Arc{i}(j, 2);
        x1 = GraphPoint(p1, 1);
        x2 = GraphPoint(p2, 1);
        y1 = GraphPoint(p1, 2);
        y2 = GraphPoint(p2, 2);
        plot([x1,x2],[y1,y2],'r');
        hold on
    end
end



end