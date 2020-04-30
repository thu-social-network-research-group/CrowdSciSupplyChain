%%项目主函数
%R为t时刻各节点弹性值，V为t时刻各节点产值
clc;clear;
Chain_layer_Num=8;    %节点层数
CoopNum = 5; %每个节点最大连接数k
Max_node = 10; % 每一层最大节点个数
Min_node = 4;  %每一层最小节点个数
[Graph,Arc]=Graph_Create(Chain_layer_Num, CoopNum, Max_node, Min_node);     %创建图、边元胞

R = R_initial(Graph);   %R值初始化(按照Beta(2,5)分布)
min_A = 3; max_A = 10;  %节点i能力上下限
V = V_initial(Graph, min_A, max_A);   %V值初始化(按照Beta(2.5)分布和各节点初始能力值约束)

%R(t+1)=(1-alpha)R(t)+alpha*g(V(t),Vu(t),Vd(t))
%g()~N((a*V+b*Vu+c*Vd),0.1)
alpha = 0.1;  %弱连接系数
a = 1/3; b = 1/3; c = 1/3; %产值线性组合参数
R_sigma = 0.1;  %R高斯分布方差
gamma = 10;    %调节g大小的参数
V_sigma = 0.01; %V高斯分布方差

% -------------------------------------------------------------------------
% 更新图Arc过程
iteration = 1;
for i = 1:iteration
    [R_list,V_list] = calc_RV_list(R,V) ;    %%按照序号顺序排列各节点R值、V值(展开为长向量)
    R = R_Calc(Graph,Arc,R,V_list,alpha,a,b,c,R_sigma,gamma);    %R值计算（更新）R(t)->R(t+1)
    V = V_calc(R,V,V_sigma);        %V值计算（更新）V(t)->V(t+1)
    %%%%%
end  
