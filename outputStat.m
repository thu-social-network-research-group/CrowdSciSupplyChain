function RAvg = outputStat(R)
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
    for i = 1:layerNum
        nodeTotCount = nodeTotCount + length(R{i});
        totR = totR + sum(R{i});
    end
    RAvg = totR / nodeTotCount;
end