function Arc = UpdateArc(Graph, Arc, R, P, CoopNum, FundRate, Decay, RButton)
%��������������������������������������������������������������������������
%��������ṹ���µĺ���
%�������Ϊ
%Graph:��¼����ÿ��Ľڵ���
%Arc:��¼����ߵ�����
%R:��¼���ڵ��Rֵ
%P:��¼���ڵ��Pֵ
%CoopNum:��������������ÿ���˿���Ͷ���ĺ�����
%Decay:˥���ʣ������ڵ�����������ʱ�������ڵ�ѡ��ʱ����ѡ��õ�
%RButton:�׺����̶��Ƿ���ڵ㱾���Rֵ�йأ�1Ϊ�йأ������޹�
%�������Ϊ
%Arc:����������ߵ�����
%FundRate:����ֵ����
%��������������������������������ʼ��������������������������������������
LayerNum = length(Graph);%�õ�����
for i = 1 : LayerNum-1
    NextArc = [];%���������¼���������������
    ArcTemp = Arc{i};%���ֵ�����
    CoopRateTh = zeros(1,length(Graph{i}));%��ʼ�������׺����̶�
    CoopRateNt = zeros(1,length(Graph{i+1}));%��ʼ���²��׺����̶�
    %���㱾�����²���׺����̶�
    for j = 1 : size(Arc{i}, 1)
        temp = Arc{i}(j,2)-Graph{i+1}(1)+1;%���ӵ��²�ڵ������
        temp2 = Arc{i}(j,1)-Graph{i}(1)+1;%���ӵ��ϲ�ڵ������
        CoopRateNt(temp) = CoopRateNt(temp) + R{i}(temp2);
        CoopRateTh(temp2) = CoopRateTh(temp2) + R{i+1}(temp);
    end
    %���ӽڵ㱾���ֵ
    if(RButton == 1)
        CoopRateTh = CoopRateTh + R{i};
        CoopRateNt = CoopRateNt + R{i+1};
    end
    %����˥������
    CoopRateTh = CoopRateTh.*Decay{i}(2,:);
    CoopRateNt = CoopRateNt.*Decay{i+1}(1,:);
    
        
    %���ӻ���ֵ
    CoopRateTh = CoopRateTh + FundRate*mean(CoopRateTh) + 1;
    CoopRateNt = CoopRateNt + FundRate*mean(CoopRateNt) + 1;
%��������������������������������������Ը��������������������������������  
    CoopWillTh = zeros(length(Graph{i}), CoopNum);%��¼����ĺ�����Ը
    CoopWillNt = zeros(length(Graph{i+1}), CoopNum);%��¼�²�ĺ�����Ը
    %��Ȿ�������Ը
    for j = 1 : length(Graph{i})
        TempNum = Graph{i}(j);%��¼�ؽڵ���
        TempRetain = find(ArcTemp == TempNum);%����������
        if ( rand > P{i}(j) & length(TempRetain) > 0 )
            %������Ը
            TempCRN = CoopRateNt;
            for k = 1 : length(TempRetain)
                CoopWillTh(j,k) = ArcTemp(TempRetain(k), 2);
                TempCRN( ArcTemp(TempRetain(k), 2)-Graph{i+1}(1)+1 ) = 0;%�Ѿ�ѡ�е�ȥ��Ȩ��
            end
            if k < CoopNum
                %������Ը�²�δ�ﵽ����ѡ����
                CoopWillTh(j,k+1:CoopNum) = Dis_Rand(Graph{i+1},TempCRN,CoopNum-k);
            end
        else
            %����ѡ����Ը
            CoopWillTh(j, 1:CoopNum) = Dis_Rand(Graph{i+1},CoopRateNt,CoopNum);
        end
    end
    
    
    %����²������Ը
    %Ϊ�˷�����⣬�������Ӿ���ı�ʾ˳��ʹ��һ��Ϊ�²�ڵ�
    temp = ArcTemp(:,2);
    ArcTemp(:,2) = ArcTemp(:,1);
    ArcTemp(:,1) = temp;
    for j = 1 : length(Graph{i+1})
        TempNum = Graph{i+1}(j);%��¼�ֽڵ���
        TempRetain = find(ArcTemp == TempNum);%����������
        if ( rand > P{i+1}(j) & length(TempRetain) > 0 )
            %������Ը
            TempCRN = CoopRateTh;
            for k = 1 : length(TempRetain)
                CoopWillNt(j,k) = ArcTemp(TempRetain(k), 2);
                TempCRN( ArcTemp(TempRetain(k), 2)-Graph{i}(1)+1 ) = 0;%�Ѿ�ѡ�е�ȥ��Ȩ��
            end
            if k < CoopNum
                %������Ը�²�δ�ﵽ����ѡ����
                CoopWillNt(j,k+1:CoopNum) = Dis_Rand(Graph{i},TempCRN,CoopNum-k);
            end
        else
            %����ѡ����Ը
            CoopWillNt(j, 1:CoopNum) = Dis_Rand(Graph{i},CoopRateTh,CoopNum);
        end
    end
%�����������������������������ݺ�����Ը�����±����ӡ�����������������������
    for j = 1 : length(Graph{i})
        ThPt = j + Graph{i}(1) - 1;%�õ�����
        for k = 1 : CoopNum
            CoPt = CoopWillTh(j, k);%����������
            temp1 = CoPt - Graph{i+1}(1) + 1;%���������²��е�����
            if(length(find( CoopWillNt(temp1,:) ==  ThPt )) > 0)
                TempArc = [ThPt CoPt];
                NextArc = [NextArc; TempArc];
            end
        end
    end
    Arc{i} = unique(NextArc,'rows');%�õ�������Ľṹ
%     unique(NextArc,'rows')
end
end