function connects = checkConnects(Arc)
% -----------------------------------------------------------------------------
% 根据网络的结构以及连接边，统计每一层节点向下游连接边数的最大值，最小值，平均值
% 输入参数：
% Arc: 供应链网络与下层边的链接
% 输出参数：
% connects: 一个一维元胞数组, 单元数等于供应链网络的层数，其中有三个值，分别代表本层向下层链接的最大值，最小值和平均值
% -----------------------------------------------------------------------------
interval_num = length(Arc);
connects = cell(1, interval_num);
for i = 1:interval_num
    if (ndims(Arc{1, i}) == 1)
        connects{1, i} = [1, 1, 1];  % 最大值，最小值，均值都是1
    else  % 多条边
        source_nodes = Arc{1, i}(:, 1);  % 取出所有边的源节点
        h = hist(source_nodes, unique(source_nodes));  % 统计每一个上游节点作为源节点出现的次数，see hist()
        connects{1, i} = [max(h), min(h), mean(h)];
    end
end
end