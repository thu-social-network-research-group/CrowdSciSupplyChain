%%项目主函数
%R为t时刻各节点弹性值，V为t时刻各节点产值
clc;clear;
<<<<<<< HEAD
iteration =50000;  % 迭代的次�?
=======
iteration = 500;  % 迭代的次数
>>>>>>> 5b3c87b8da07af5decbf13821a4bd4ed0e88bf70
Chain_layer_Num=8;    %节点层数
CoopNum = 5; %每个节点最大连接数k
Max_node = 14; % 每一层最大节点个数
Min_node = 14;  %每一层最小节点个数
[Graph,Arc]=Graph_Create(Chain_layer_Num, CoopNum, Max_node, Min_node);     %创建图与边元胞
R_TH=1;   %%如果R小于R_TH，将被删除


Repu = Repu_intial2(Graph); %The reputation of every agent, the cooperate rate of every agent in last turn
TP = TP_intial(Graph);%The total paypoff  of every agent
payoff_one_turn = TP;
Payoff = cell(2,2);
Payoff{1,1} = [6,6];%agent1 and agent2 cooperate
Payoff{1,2} = [2,10];%agent1 cooperate and agent2 defect
Payoff{2,1} = [10,2];%agent2 cooperate and agent1 defect
Payoff{2,2} = [4,4];%agent1 and agent2 defect

R = R_initial(Graph);   %R值初始化(按照Beta(2,5)分布)
min_A = 3; max_A = 10;  %节点i能力上下界
V = V_initial(Graph, min_A, max_A);   %V值初始化(按照Beta(2.5)分布和各节点初始能力值初始化)

%R(t+1)=(1-alpha)R(t)+alpha*g(V(t),Vu(t),Vd(t))
%g()~N((a*V+b*Vu+c*Vd),0.1)
alpha = 0.1;  %弱连接系数
a = 1/3; b = 1/3; c = 1/3; %产量线性组合参数
R_sigma = 0.001;  %R高斯分布方差
gamma = 10;    %调节g大小的参数
V_sigma = 0.01; %V高斯分布方差
P_sigma = 0.1;  % 改变策略的概率计算中，sigmoid函数的参数
FundRate = 0.3;
<<<<<<< HEAD
RButton = 1;%�����Ƿ��Ǳ���Rֵ���׺����̶ȵ�Ӱ��
DecayRate = 0.5;%˥����
gama = 0.95;%The decay rate of Repu
GreedAgentRate = 0.7;%The rate of greed agent
=======
RButton = 1;% 改变策略的概率计算中，sigmoid函数的参数
DecayRate = 0.5;
gama = 0.7;%The decay rate of Repu
GreedAgentRate = 0.2;%The rate of greed agent
>>>>>>> 5b3c87b8da07af5decbf13821a4bd4ed0e88bf70
% -------------------------------------------------------------------------
% 更新图Arc过程
% DIS = [];


%%%���Ĳ���%%%
REval = zeros(iteration, 6);
layer_connect = zeros(iteration, 4);  % max, min, average, variance
CoopRate = zeros(iteration, 1);
ArcTypeRate = zeros(iteration, 3);
MeanTP = zeros(iteration, 3);
AgentLabel = AgentLabel_intial(Graph, GreedAgentRate);%The label of the agent to show whether it is greed agent
%%%���Ĳ���%%%


for i = 1:iteration
    V = V_calc(R,V,V_sigma);        %V值计算（更新）V(t)->V(t+1)
    [~,V_list] = calc_RV_list(R,V) ;    %%按照序号顺序排列各节点展开V为长向量
    R = R_Calc2(Graph,Arc,R,V_list,alpha,a,b,c,R_sigma,gamma);
    %R = R_Calc(Graph,Arc,R,V_list,alpha,a,b,c,R_sigma,gamma,payoff_one_turn);    %R值计算（更新）R(t)->R(t+1)
    [R_list,~] = calc_RV_list(R,V) ;    %%按照序号顺序排列各节点展开R为长向量
    
    %%%% Remove Node
    if i>40
         [Graph,Arc,R,V,Repu,TP,AgentLabel] = RemoveNode(Graph,Arc,R,V,Repu,TP,AgentLabel,R_TH);   %%去点
    end
   
    %%%% Add Node
    for ii=2:length(Graph)-1        %%从第2层到倒数第2层
        if length(Graph{ii}) < Min_node+1      %%如果某层节点数少于Min_node个
           % [Graph,Arc,R,V,Repu,TP,AgentLabel] = AddNode(Graph,Arc,R,V,Repu,TP,AgentLabel,GreedAgentRate,ii); %%加点
        end
    end   

    
    
    P = calculateP(R, P_sigma);
    Decay = CalDecay(Graph, Arc, DecayRate, CoopNum);%����˥����
    Arc = UpdateArc(Graph, Arc, R, P, CoopNum, FundRate, Decay, RButton);%��������
    Dis = CalDis(Graph, Arc, CoopNum);
    [TP, Repu Arcs] = AgentGame(Graph, Arc, Repu, TP, Payoff);
  % [TP, payoff_one_turn, Repu, Arcs] = AgentGame2(Graph, Arc, Repu, TP, Payoff, gama, AgentLabel);
%     DIS = [DIS mean(Dis)];


    %%%���Ĳ���---λ�ø��������������
    REval(i, :) = outputStat(R);
    layer_connect(i, :) = checkConnectsAll(Arc);
    CoopRate(i) = mean(Repu(1, :));
    ArcTypeRate(i, :) = CalArcTypeRate(Arcs);
    MeanTP(i, 1) = mean(TP);
    MeanTP(i, 2) = mean(TP(find(AgentLabel == 1)));
    MeanTP(i, 3) = mean(TP(find(AgentLabel == 2)));
%     connects = checkConnects(Arc);
%     layer_connect(i, :) = connects{1, 2};  % if want to check any layers connects, just change the connects {1, ?}
    %%%���Ĳ���%%%
    
    
<<<<<<< HEAD
    %��ͼ,ÿʮ�ε�����ͼһ�Σ�ͣ1s
%     if mod(i,10) == 1
% %         figure(1)
% %         clf
% %         hist(Dis, CoopNum+1);
% %         figure(2)
%         clf
%         GraphPoint = CalGarphPoint(Graph);
%         
%         
%         %%%%���Ĳ���%%%%
%         ShowGraph2(GraphPoint, Arcs);
%         %%%%���Ĳ���%%%%
%         
%         
%         pause(1)
%         i
%         
%     end
=======
    %��ͼ,ÿʮ�ε�����ͼһ�Σ�ͣ1s
    if mod(i,10) == 1
%         figure(1)
%         clf
%         hist(Dis, CoopNum+1);
%         figure(2)
        clf
        GraphPoint = CalGarphPoint(Graph);
        
        
        %%%%���Ĳ���%%%%
        ShowGraph2(GraphPoint, Arcs);
        %%%%���Ĳ���%%%%
        
        
        pause(1)
        i
        
    end
>>>>>>> 5b3c87b8da07af5decbf13821a4bd4ed0e88bf70
end


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

