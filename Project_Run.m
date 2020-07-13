%%项目主函数
%R为t时刻各节点弹性值，V为t时刻各节点产值
clc;clear;
iteration = 400;  % 迭代的次数
TH=2;%节点被去除的R值阈值
REval = zeros(1, iteration);
layer_connect = zeros(iteration, 3);  % max, min, average
Chain_layer_Num=8;    %节点层数
CoopNum = 4; %每个节点最大连接数k
Max_node = 15; % 每一层最大节点个数
Min_node = 15;  %每一层最小节点个数
[Graph,Arc]=Graph_Create(Chain_layer_Num, CoopNum, Max_node, Min_node);      %创建图与边元胞

Repu = Repu_intial(Graph); %The reputation of every agent, the cooperate rate of every agent in last turn
TP = TP_intial(Graph);%The total paypoff  of every agent
Payoff = cell(2,2);
Payoff{1,1} = [5,5];%agent1 and agent2 cooperate
Payoff{1,2} = [2,8];%agent1 cooperate and agent2 defect
Payoff{2,1} = [8,2];%agent2 cooperate and agent1 defect
Payoff{2,2} = [3,3];%agent1 and agent2 defect

R = R_initial(Graph);   %R值初始化(按照Beta(2,5)分布)
min_A = 3; max_A = 10;  %节点i能力上下界
V = V_initial(Graph, min_A, max_A);   %V值初始化(按照Beta(2.5)分布和各节点初始能力值初始化)


%R(t+1)=(1-alpha)R(t)+alpha*g(V(t),Vu(t),Vd(t))
%g()~N((a*V+b*Vu+c*Vd),0.1)
alpha = 0.1;  %弱连接系数
a = 1/3; b = 1/3; c = 1/3; %产量线性组合参数
R_sigma = 0.1;  %R高斯分布方差
gamma = 10;    %调节g大小的参数
V_sigma = 0.01; %V高斯分布方差
P_sigma = 0.1;  % 改变策略的概率计算中，sigmoid函数的参�?
FundRate = 0.3;
RButton = 1;% 改变策略的概率计算中，sigmoid函数的参数
DecayRate = 0.5;%˥����
GraphPoint = CalGarphPoint(Graph);
% -------------------------------------------------------------------------
% 更新图Arc过程
% DIS = [];
for i = 1:iteration
    [R_list,V_list] = calc_RV_list(R,V) ;    %%按照序号顺序排列各节点R值�?�V�?(展开为长向量)
    R = R_Calc(Graph,Arc,R,V_list,alpha,a,b,c,R_sigma,gamma);    %R值计算（更新）R(t)->R(t+1)
    V = V_calc(R,V,V_sigma);        %V值计算（更新）V(t)->V(t+1)
    [Graph,Arc,R,V,Repu,TP] = RemoveNode(Graph,Arc,R,V,Repu,TP,3);

    for ii=1:length(Graph)-1        %Add Node
        if length(Graph{ii}) < 5
            [Graph,Arc,R,V,Repu,TP] = AddNode(Graph,Arc,R,V,Repu,TP,ii);

        end
    end
    %%%%%
    REval(i) = outputStat(R);
    connects = checkConnects(Arc);
    layer_connect(i, :) = connects{1, 2};  % if want to check any layers connects, just change the connects {1, ?}
    P = calculateP(R, P_sigma);
    Decay = CalDecay(Graph, Arc, DecayRate, CoopNum);%����˥����
    Arc = UpdateArc(Graph, Arc, R, P, CoopNum, FundRate, Decay, RButton);%��������
    Dis = CalDis(Graph, Arc, CoopNum);
%     DIS = [DIS mean(Dis)];
    
    %��ͼ,ÿʮ�ε�����ͼһ�Σ�ͣ1s
    if mod(i,10) == 1
%         figure(1)
        clf
%         hist(Dis, CoopNum+1);
%         figure(2)
        clf
%         ShowGraph(GraphPoint, Arc);
        pause(1)
        i
        
    end
end
figure
plot(REval);
% hold on
% plot(DIS);
figure
plot(layer_connect)
legend('Max Connects', 'Min Connects', 'Average Connects')
