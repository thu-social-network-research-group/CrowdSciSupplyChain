%%项目主函数
%R为t时刻各节点弹性值，V为t时刻各节点产值
clc;clear;
Chain_layer_Num=8;    %节点层数
[Graph,Arc]=Graph_create(Chain_layer_Num);     %创建图、边元胞
R = R_initial(Graph);   %R值初始化(按照Beta分布)
V = V_initial(Graph);   %V值初始化(按照Beta分布和各节点初始能力值约束)
[R_list,V_list] = calc_RV_list(R,V) ;    %%按照序号顺序排列各节点R值、V值(展开为长向量)
R = R_calc(Graph,Arc,R,V_list);    %R值计算（更新）R(t)->R(t+1)
V = V_calc(R,V);        %V值计算（更新）V(t)->V(t+1)

% -------------------------------------------------------------------------
% 更新图Arc过程