function REval = outputStat(R)
% -------------------------------------------------------------------------
% 根据当前轮的R值，计算全网络的统计量。这一部分可以不断添加新的evaluation，这里先只
% 考虑全网络的 R 均值
% 输入参数：
% R：网络的R值，cell数组
% 输出参数：
% RAvg：全网络的R均值
% -------------------------------------------------------------------------
    layerNum = length(R);
    nodeTotCount = 0;
    totR = 0;
    R0 = [];
    for i = 1:layerNum
        R0 = [R0 R{i}];
    end
    RAvg = mean(R0);
    RMax = max(R0);
    RMin = min(R0);
    RVar = var(R0);
    RDistribution = prctile(R0,[10,90]);
    REval = [RAvg RMax RMin RVar RDistribution];
end