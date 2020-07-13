%%项目主函�?
%R为t时刻各节点弹性�?�，V为t时刻各节点产�?
clc;clear;
iteration = 2000;  % 迭代的次�?
Chain_layer_Num=8;    %节点层数
CoopNum = 5; %每个节点�?大连接数k
Max_node = 15; % 每一层最大节点个�?
Min_node = 15;  %每一层最小节点个�?
[Graph,Arc]=Graph_Create(Chain_layer_Num, CoopNum, Max_node, Min_node);     %创建图�?�边元胞


Repu = Repu_intial(Graph); %The reputation of every agent, the cooperate rate of every agent in last turn
TP = TP_intial(Graph);%The total paypoff  of every agent
Payoff = cell(2,2);
Payoff{1,1} = [5,5];%agent1 and agent2 cooperate
Payoff{1,2} = [2,8];%agent1 cooperate and agent2 defect
Payoff{2,1} = [8,2];%agent2 cooperate and agent1 defect
Payoff{2,2} = [3,3];%agent1 and agent2 defect

R = R_initial(Graph);   %R值初始化(按照Beta(2,5)分布)
min_A = 3; max_A = 10;  %节点i能力上下�?
V = V_initial(Graph, min_A, max_A);   %V值初始化(按照Beta(2.5)分布和各节点初始能力值约�?)

%R(t+1)=(1-alpha)R(t)+alpha*g(V(t),Vu(t),Vd(t))
%g()~N((a*V+b*Vu+c*Vd),0.1)
alpha = 0.1;  %弱连接系�?
a = 1/3; b = 1/3; c = 1/3; %产�?�线性组合参�?
R_sigma = 0.1;  %R高斯分布方差
gamma = 10;    %调节g大小的参�?
V_sigma = 0.01; %V高斯分布方差
P_sigma = 0.1;  % 改变策略的概率计算中，sigmoid函数的参�?
FundRate = 0.3;
RButton = 1;%�����Ƿ��Ǳ���Rֵ���׺����̶ȵ�Ӱ��
DecayRate = 0.5;%˥����
% -------------------------------------------------------------------------
% 更新图Arc过程
% DIS = [];


%%%���Ĳ���%%%
REval = zeros(iteration, 4);
layer_connect = zeros(iteration, 4);  % max, min, average, variance
CoopRate = zeros(iteration, 1);
ArcTypeRate = zeros(iteration, 3);
MeanTP = zeros(iteration, 1);
%%%���Ĳ���%%%


for i = 1:iteration
    [R_list,V_list] = calc_RV_list(R,V) ;    %%按照序号顺序排列各节点R值�?�V�?(展开为长向量)
    R = R_Calc(Graph,Arc,R,V_list,alpha,a,b,c,R_sigma,gamma);    %R值计算（更新）R(t)->R(t+1)
    V = V_calc(R,V,V_sigma);        %V值计算（更新）V(t)->V(t+1)
    %%%%%
    
    

    
    
    P = calculateP(R, P_sigma);
    Decay = CalDecay(Graph, Arc, DecayRate, CoopNum);%����˥����
    Arc = UpdateArc(Graph, Arc, R, P, CoopNum, FundRate, Decay, RButton);%��������
    Dis = CalDis(Graph, Arc, CoopNum);
    [TP, Repu Arcs] = AgentGame(Graph, Arc, Repu, TP, Payoff);
%     DIS = [DIS mean(Dis)];


    %%%���Ĳ���---λ�ø��������������
    REval(i, :) = outputStat(R);
    layer_connect(i, :) = checkConnectsAll(Arc);
    CoopRate(i) = mean(Repu(1, :));
    ArcTypeRate(i, :) = CalArcTypeRate(Arcs);
    MeanTP(i) = sum(TP);
%     connects = checkConnects(Arc);
%     layer_connect(i, :) = connects{1, 2};  % if want to check any layers connects, just change the connects {1, ?}
    %%%���Ĳ���%%%
    
    
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
end


%%%%���Ĳ���%%%%
figure
plot(REval(:,1:3));
legend('Average R', 'Max R', 'Min R')
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
legend('Total payoff every turn')
%%%%���Ĳ���%%%%

