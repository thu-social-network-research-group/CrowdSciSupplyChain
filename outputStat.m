function REval = outputStat(R)
% -------------------------------------------------------------------------
% ���ݵ�ǰ�ֵ�Rֵ������ȫ�����ͳ��������һ���ֿ��Բ�������µ�evaluation��������ֻ
% ����ȫ����� R ��ֵ
% ���������
% R�������Rֵ��cell����
% ���������
% RAvg��ȫ�����R��ֵ
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