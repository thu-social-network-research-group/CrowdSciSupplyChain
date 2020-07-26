%%椤圭洰涓诲嚱鏁?
%R涓簍鏃跺埢鍚勮妭鐐瑰脊鎬у?硷紝V涓簍鏃跺埢鍚勮妭鐐逛骇鍊?
clc;clear;
iteration = 500;  % 杩唬鐨勬鏁?
Chain_layer_Num=8;    %鑺傜偣灞傛暟
CoopNum = 5; %姣忎釜鑺傜偣鏈?澶ц繛鎺ユ暟k
Max_node = 18; % 姣忎竴灞傛渶澶ц妭鐐逛釜鏁?
Min_node = 14;  %姣忎竴灞傛渶灏忚妭鐐逛釜鏁?
[Graph,Arc]=Graph_Create(Chain_layer_Num, CoopNum, Max_node, Min_node);     %鍒涘缓鍥俱?佽竟鍏冭優


Repu = Repu_intial2(Graph); %The reputation of every agent, the cooperate rate of every agent in last turn
TP = TP_intial(Graph);%The total paypoff  of every agent

Payoff = cell(2,2);
Payoff{1,1} = [6,6];%agent1 and agent2 cooperate
Payoff{1,2} = [2,10];%agent1 cooperate and agent2 defect
Payoff{2,1} = [10,2];%agent2 cooperate and agent1 defect
Payoff{2,2} = [4,4];%agent1 and agent2 defect

R = R_initial(Graph);   %R鍊煎垵濮嬪寲(鎸夌収Beta(2,5)鍒嗗竷)
min_A = 3; max_A = 10;  %鑺傜偣i鑳藉姏涓婁笅闄?
V = V_initial(Graph, min_A, max_A);   %V鍊煎垵濮嬪寲(鎸夌収Beta(2.5)鍒嗗竷鍜屽悇鑺傜偣鍒濆鑳藉姏鍊肩害鏉?)

%R(t+1)=(1-alpha)R(t)+alpha*g(V(t),Vu(t),Vd(t))
%g()~N((a*V+b*Vu+c*Vd),0.1)
alpha = 0.1;  %寮辫繛鎺ョ郴鏁?
a = 1/3; b = 1/3; c = 1/3; %浜у?肩嚎鎬х粍鍚堝弬鏁?
R_sigma = 0.1;  %R楂樻柉鍒嗗竷鏂瑰樊
gamma = 10;    %璋冭妭g澶у皬鐨勫弬鏁?
V_sigma = 0.01; %V楂樻柉鍒嗗竷鏂瑰樊
P_sigma = 0.1;  % 鏀瑰彉绛栫暐鐨勬鐜囪绠椾腑锛宻igmoid鍑芥暟鐨勫弬鏁?
FundRate = 0.3;
RButton = 1;%决定是否考虑本层R值对易合作程度的影响
DecayRate = 0.5;%衰减率
gama = 0.7;%The decay rate of Repu
GreedAgentRate = 0.2;%The rate of greed agent
% -------------------------------------------------------------------------
% 鏇存柊鍥続rc杩囩▼
% DIS = [];


%%%更改部分%%%
REval = zeros(iteration, 4);
layer_connect = zeros(iteration, 4);  % max, min, average, variance
CoopRate = zeros(iteration, 1);
ArcTypeRate = zeros(iteration, 3);
MeanTP = zeros(iteration, 3);
AgentLabel = AgentLabel_intial(Graph, GreedAgentRate);%The label of the agent to show whether it is greed agent
%%%更改部分%%%


for i = 1:iteration
    [R_list,V_list] = calc_RV_list(R,V) ;    %%鎸夌収搴忓彿椤哄簭鎺掑垪鍚勮妭鐐筊鍊笺?乂鍊?(灞曞紑涓洪暱鍚戦噺)
    R = R_Calc(Graph,Arc,R,V_list,alpha,a,b,c,R_sigma,gamma);    %R鍊艰绠楋紙鏇存柊锛塕(t)->R(t+1)
    V = V_calc(R,V,V_sigma);        %V鍊艰绠楋紙鏇存柊锛塚(t)->V(t+1)
    %%%%%
    
    

    
    
    P = calculateP(R, P_sigma);
    Decay = CalDecay(Graph, Arc, DecayRate, CoopNum);%计算衰减率
    Arc = UpdateArc(Graph, Arc, R, P, CoopNum, FundRate, Decay, RButton);%更新网络
    Dis = CalDis(Graph, Arc, CoopNum);
    [TP, Repu Arcs] = AgentGame2(Graph, Arc, Repu, TP, Payoff, gama, AgentLabel);
%     DIS = [DIS mean(Dis)];


    %%%更改部分---位置更改至迭代计算后
    REval(i, :) = outputStat(R);
    layer_connect(i, :) = checkConnectsAll(Arc);
    CoopRate(i) = mean(Repu(1, :));
    ArcTypeRate(i, :) = CalArcTypeRate(Arcs);
    MeanTP(i, 1) = mean(TP);
    MeanTP(i, 2) = mean(TP(find(AgentLabel == 1)));
    MeanTP(i, 3) = mean(TP(find(AgentLabel == 2)));
%     connects = checkConnects(Arc);
%     layer_connect(i, :) = connects{1, 2};  % if want to check any layers connects, just change the connects {1, ?}
    %%%更改部分%%%
    
    
    %绘图,每十次迭代绘图一次，停1s
    if mod(i,10) == 1
%         figure(1)
%         clf
%         hist(Dis, CoopNum+1);
%         figure(2)
        clf
        GraphPoint = CalGarphPoint(Graph);
        
        
        %%%%更改部分%%%%
        ShowGraph2(GraphPoint, Arcs);
        %%%%更改部分%%%%
        
        
        pause(1)
        i
        
    end
end


%%%%更改部分%%%%
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
legend('Mean payoff', 'Mean payoff of ordinary agent', 'Mean payoff of greed agent')
%%%%更改部分%%%%

