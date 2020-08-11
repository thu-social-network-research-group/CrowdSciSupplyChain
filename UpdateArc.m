function Arc = UpdateArc(Graph, Arc, R, P, CoopNum, FundRate, Decay, RButton)
%—————————————————————————————————————
%计算网络结构更新的函数
%输入参数为
%Graph:记录网络每层的节点编号
%Arc:记录网络边的连接
%R:记录各节点的R值
%P:记录各节点的P值
%CoopNum:基本合作数，即每个人可以投出的合作数
%Decay:衰减率，即当节点连接数过多时，其他节点选择时倾向不选择该点
%RButton:易合作程度是否与节点本身的R值有关，1为有关，否则无关
%输出参数为
%Arc:迭代后网络边的连接
%FundRate:基础值比例
%———————————————开始迭代—————————————————
LayerNum = length(Graph);%得到层数
for i = 1 : LayerNum-1
    NextArc = [];%开辟数组记录迭代结束后的连接
    ArcTemp = Arc{i};%本轮的连接
    CoopRateTh = zeros(1,length(Graph{i}));%初始化本层易合作程度
    CoopRateNt = zeros(1,length(Graph{i+1}));%初始化下层易合作程度
    %计算本层与下层的易合作程度
    for j = 1 : size(Arc{i}, 1)
        temp = Arc{i}(j,2)-Graph{i+1}(1)+1;%连接的下层节点的索引
        temp2 = Arc{i}(j,1)-Graph{i}(1)+1;%连接的上层节点的索引
        CoopRateNt(temp) = CoopRateNt(temp) + R{i}(temp2);
        CoopRateTh(temp2) = CoopRateTh(temp2) + R{i+1}(temp);
    end
    %增加节点本身的值
    if(RButton == 1)
        CoopRateTh = CoopRateTh + R{i};
        CoopRateNt = CoopRateNt + R{i+1};
    end
    %增加衰减率项
    CoopRateTh = CoopRateTh.*Decay{i}(2,:);
    CoopRateNt = CoopRateNt.*Decay{i+1}(1,:);
    
        
    %增加基础值
    CoopRateTh = CoopRateTh + FundRate*mean(CoopRateTh) + 1;
    CoopRateNt = CoopRateNt + FundRate*mean(CoopRateNt) + 1;
%———————————————求解合作意愿————————————————  
    CoopWillTh = zeros(length(Graph{i}), CoopNum);%记录本层的合作意愿
    CoopWillNt = zeros(length(Graph{i+1}), CoopNum);%记录下层的合作意愿
    %求解本层合作意愿
    for j = 1 : length(Graph{i})
        TempNum = Graph{i}(j);%记录县节点编号
        TempRetain = find(ArcTemp == TempNum);%保留边索引
        if ( rand > P{i}(j) & length(TempRetain) > 0 )
            %保留意愿
            TempCRN = CoopRateNt;
            for k = 1 : length(TempRetain)
                CoopWillTh(j,k) = ArcTemp(TempRetain(k), 2);
                TempCRN( ArcTemp(TempRetain(k), 2)-Graph{i+1}(1)+1 ) = 0;%已经选中的去掉权重
            end
            if k < CoopNum
                %保留意愿下并未达到基本选择数
                CoopWillTh(j,k+1:CoopNum) = Dis_Rand(Graph{i+1},TempCRN,CoopNum-k);
            end
        else
            %重新选择意愿
            CoopWillTh(j, 1:CoopNum) = Dis_Rand(Graph{i+1},CoopRateNt,CoopNum);
        end
    end
    
    
    %求解下层合作意愿
    %为了方便求解，交换连接矩阵的表示顺序，使第一列为下层节点
    temp = ArcTemp(:,2);
    ArcTemp(:,2) = ArcTemp(:,1);
    ArcTemp(:,1) = temp;
    for j = 1 : length(Graph{i+1})
        TempNum = Graph{i+1}(j);%记录现节点编号
        TempRetain = find(ArcTemp == TempNum);%保留边索引
        if ( rand > P{i+1}(j) & length(TempRetain) > 0 )
            %保留意愿
            TempCRN = CoopRateTh;
            for k = 1 : length(TempRetain)
                CoopWillNt(j,k) = ArcTemp(TempRetain(k), 2);
                TempCRN( ArcTemp(TempRetain(k), 2)-Graph{i}(1)+1 ) = 0;%已经选中的去掉权重
            end
            if k < CoopNum
                %保留意愿下并未达到基本选择数
                CoopWillNt(j,k+1:CoopNum) = Dis_Rand(Graph{i},TempCRN,CoopNum-k);
            end
        else
            %重新选择意愿
            CoopWillNt(j, 1:CoopNum) = Dis_Rand(Graph{i},CoopRateTh,CoopNum);
        end
    end
%—————————————根据合作意愿，更新边连接————————————
    for j = 1 : length(Graph{i})
        ThPt = j + Graph{i}(1) - 1;%该点的序号
        for k = 1 : CoopNum
            CoPt = CoopWillTh(j, k);%合作点的序号
            temp1 = CoPt - Graph{i+1}(1) + 1;%合作点在下层中的索引
            if(length(find( CoopWillNt(temp1,:) ==  ThPt )) > 0)
                TempArc = [ThPt CoPt];
                NextArc = [NextArc; TempArc];
            end
        end
    end
    Arc{i} = unique(NextArc,'rows');%得到迭代后的结构
%     unique(NextArc,'rows')
end
end