%%项目主函数
%R为t时刻各节点弹性值，V为t时刻各节点产值
clc;clear;
iteration = 500;  % 迭代的次数
Repeat_Num = 100; %重复实验次数
Chain_layer_Num=8;    %节点层数
CoopNum = 5; %每个节点最大连接数k
Max_node = 18; % 每一层最大节点个数
Min_node = 14;  %每一层最小节点个数
R_TH=1;   %%如果R小于R_TH，将被删除
min_A = 3; max_A = 10;  %节点i能力上下界
alpha = 0.1;  %弱连接系数
a = 1/3; b = 1/3; c = 1/3; %产量线性组合参数
R_sigma = 0.001;  %R高斯分布方差
gamma = 10;    %调节g大小的参数
V_sigma = 0.01; %V高斯分布方差
P_sigma = 0.1;  % 改变策略的概率计算中，sigmoid函数的参数
FundRate = 0.3;
RButton = 1;% 改变策略的概率计算中，sigmoid函数的参数
DecayRate = 0.5;
gama = 0.7;%The decay rate of Repu
GreedAgentRate = 0.2;%The rate of greed agent

Average_REval=cell(1,Repeat_Num);
Average_layer_connect=cell(1,Repeat_Num);
Average_CoopRate = cell(1,Repeat_Num);
Average_ArcTypeRate=cell(1,Repeat_Num);
Average_MeanTP=cell(1,Repeat_Num);
for repeat_count = 1 : Repeat_Num
    disp("当前进行第"+repeat_count+"轮重复实验");
    %单次实验初始化
    [Graph,Arc]=Graph_Create(Chain_layer_Num, CoopNum, Max_node, Min_node);     %创建图与边元胞
    Repu = Repu_intial2(Graph); %The reputation of every agent, the cooperate rate of every agent in last turn
    TP = TP_intial(Graph);%The total paypoff  of every agent
    payoff_one_turn = TP;
    Payoff = cell(2,2);
    Payoff{1,1} = [6,6];%agent1 and agent2 cooperate
    Payoff{1,2} = [2,10];%agent1 cooperate and agent2 defect
    Payoff{2,1} = [10,2];%agent2 cooperate and agent1 defect
    Payoff{2,2} = [4,4];%agent1 and agent2 defect
    R = R_initial(Graph);   %R值初始化(按照Beta(2,5)分布)
    V = V_initial(Graph, min_A, max_A);   %V值初始化(按照Beta(2.5)分布和各节点初始能力值初始化)
    %统计量初始化
    REval = zeros(iteration, 6);
    layer_connect = zeros(iteration, 4);  % max, min, average, variance
    CoopRate = zeros(iteration, 1);
    ArcTypeRate = zeros(iteration, 3);
    MeanTP = zeros(iteration, 3);
    AgentLabel = AgentLabel_intial(Graph, GreedAgentRate);%The label of the agent to show whether it is greed agent
    for i = 1:iteration
        V = V_calc(R,V,V_sigma);        %V值计算（更新）V(t)->V(t+1)
        [~,V_list] = calc_RV_list(R,V) ;    %%按照序号顺序排列各节点展开V为长向量
        %     R = R_Calc2(Graph,Arc,R,V_list,alpha,a,b,c,R_sigma,gamma);
        R = R_Calc(Graph,Arc,R,V_list,alpha,a,b,c,R_sigma,gamma,payoff_one_turn);    %R值计算（更新）R(t)->R(t+1)
        [R_list,~] = calc_RV_list(R,V) ;    %%按照序号顺序排列各节点展开R为长向量
        
        %%%% Remove Node
        if i>40
        %    [Graph,Arc,R,V,Repu,TP,payoff_one_turn, AgentLabel] = RemoveNode(Graph,Arc,R,V,Repu,TP,payoff_one_turn,AgentLabel,R_TH);   %%去点
        end
        
        %%%% Add Node
        for ii=2:length(Graph)-1        %%从第2层到倒数第2层
            if length(Graph{ii}) < Min_node+1     %%如果某层节点数少于Min_node个
           %     [Graph,Arc,R,V,Repu,TP,payoff_one_turn,AgentLabel] = AddNode(Graph,Arc,R,V,Repu,TP,payoff_one_turn,AgentLabel,GreedAgentRate,ii); %%加点
            end
        end
        
        P = calculateP(R, P_sigma);
        Decay = CalDecay(Graph, Arc, DecayRate, CoopNum);%����˥����
        Arc = UpdateArc(Graph, Arc, R, P, CoopNum, FundRate, Decay, RButton);%��������
        Dis = CalDis(Graph, Arc, CoopNum);
        %     [TP, Repu Arcs] = AgentGame(Graph, Arc, Repu, TP, Payoff);
        [TP, payoff_one_turn, Repu, Arcs] = AgentGame2(Graph, Arc, Repu, TP, Payoff, gama, AgentLabel);
        %     DIS = [DIS mean(Dis)];
        
        %%%取平均
        REval(i, :) = outputStat(R);
        Average_REval{repeat_count}=REval;
        
        layer_connect(i, :) = checkConnectsAll(Arc);
        Average_layer_connect{repeat_count}=layer_connect;
        
        CoopRate(i) = mean(Repu(1, :));
        Average_CoopRate{repeat_count}=CoopRate;
        
        ArcTypeRate(i, :) = CalArcTypeRate(Arcs);
        Average_ArcTypeRate{repeat_count}=ArcTypeRate;
        
        MeanTP(i, 1) = mean(TP);
        MeanTP(i, 2) = mean(TP(find(AgentLabel == 1)));
        MeanTP(i, 3) = mean(TP(find(AgentLabel == 2)));
        Average_MeanTP{repeat_count}=MeanTP;
        
        %connects = checkConnects(Arc);
        
    end
end

for re_count=1:Repeat_Num-1
    REval=REval+Average_REval{re_count};
    layer_connect=layer_connect+Average_layer_connect{re_count};
    CoopRate=CoopRate+Average_CoopRate{re_count};
    ArcTypeRate=ArcTypeRate+Average_ArcTypeRate{re_count};
    MeanTP=ArcTypeRate+Average_MeanTP{re_count};
end
    REval=REval/Repeat_Num;
    layer_connect=layer_connect/Repeat_Num;
    CoopRate=CoopRate/Repeat_Num;
    ArcTypeRate=ArcTypeRate/Repeat_Num;
    MeanTP=ArcTypeRate/Repeat_Num;

%%%%���Ĳ���%%%%
figure
plot(REval(:,1:3));
hold on
plot(REval(:,5:6));
legend('Average R', 'Max R', 'Min R', '10%R', '90%R');
figure
plot(REval(:,4));
legend('Variance')
% hold on
% plot(DIS);
figure
plot(layer_connect)
legend('Max Connects', 'Min Connects', 'Average Connects', 'Variance')
figure
plot(CoopRate)
legend('CooperateRate')
figure
plot(ArcTypeRate)
legend('Both cooperate', 'One cooperate and one defect', 'Both defect')
figure
plot(diff(MeanTP))
legend('Mean payoff', 'Mean payoff of ordinary agent', 'Mean payoff of greed agent')
%%%%���Ĳ���%%%%

