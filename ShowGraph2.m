function ShowGraph2(GraphPoint, Arcs)
%绘图函数
%输入：
%GraphPoint：计算得到的各点位置
%Arc：图的连接
% xmin = min(GraphPoint(:,1));
% xmax = max(GraphPoint(:,1));
% ymin = min(GraphPoint(:,2));
% ymax = max(GraphPoint(:,2));
% axis( [xmin xmax ymin ymax] )
scatter(GraphPoint(:,1),GraphPoint(:,2),'filled','b');
hold on
len1 = length(Arcs);
for i = 1 : len1
    len2 = size(Arcs{i},1);
    for j = 1 : len2
        p1 = Arcs{i}(j, 1);
        p2 = Arcs{i}(j, 2);
        label = Arcs{i}(j, 3);
        x1 = GraphPoint(p1, 1);
        x2 = GraphPoint(p2, 1);
        y1 = GraphPoint(p1, 2);
        y2 = GraphPoint(p2, 2);
        if(label == 1)
            plot([x1,x2],[y1,y2],'g');
        elseif(label == 2)
            plot([x1,x2],[y1,y2],'b');
            %draw_arrow([x2,y2],[x1,y1],0.2);
        elseif(label == 3)
            %draw_arrow([x1,y1],[x2,y2],0.2);
            plot([x1,x2],[y1,y2],'b');
        else
            plot([x1,x2],[y1,y2],'r');
        end
        hold on
    end
end
end