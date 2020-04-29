
% -------------------------------------------------------------------------
%程序输出参数：
%Graph:记录网络每层的节点编号
%Arc:记录网络边的连接
%R:记录各节点的R值
%P:记录各节点的P值
%CoopNum:基本合作数，即每个人可以投出的合作数
% -------------------------------------------------------------------------
clc;clear;
Chain_layer_Num=8;    %节点层数
Arc_layer_Num=Chain_layer_Num-1;   %边层数


%图节点
node_sum=0;    %节点总数
node_num=zeros(1,Chain_layer_Num);   %各层节点个数
Max_node_num_of_one_layer=10*ones(1,Chain_layer_Num); %每一层最大节点个数
Min_node_num_of_one_layer=4*ones(1,Chain_layer_Num); %每一层最小节点个数

Graph = cell(1,Chain_layer_Num);
for i=1:Chain_layer_Num
    node_num(i)=randi([Min_node_num_of_one_layer(i),Max_node_num_of_one_layer(i)],1);    %第i层节点个数从10中随机抽取随机整数
    Graph{i}=((node_sum+1):(node_sum+node_num(i)));
    node_sum=node_sum+node_num(i);
end

%边连接
Arc = cell(1,Arc_layer_Num);
for i=1:Arc_layer_Num
    Max_arc_num_of_one_layer=length(Graph{i})*length(Graph{i+1});   %第i层最大边数（设置为全连接时）
    Min_arc_num_of_one_layer=ceil(Max_arc_num_of_one_layer/3);     %第i层最小边数（取为全连接的一半，向上取整）
    Arc_num(i)=randi([Min_arc_num_of_one_layer,Max_arc_num_of_one_layer],1);                  %第i层的真实边数
    Connect_matrix=zeros(Arc_num(i),2);  %第i层的连接矩阵(边数*2矩阵)
    for j=1:Arc_num(i)
        Connect_matrix(j,1)=randi([Graph{i}(1),Graph{i}(1)+length(Graph{i})-1],1); %Node_choose_i_layer
        Connect_matrix(j,2)=randi([Graph{i+1}(1),Graph{i+1}(1)+length(Graph{i+1})-1],1);  %Node_choose_i+1_layer
    end
    Arc{i}=Connect_matrix;
end
        
%R值
R = cell(1,3);
R{1} = rand(3,1);%第一层的R值
R{2} = rand(2,1);
R{3} = rand(2,1);

%改变概率矩阵P
P = cell(1,3); 
P{1} = rand(3,1);%第一层的P值
P{2} = rand(2,1);
P{3} = rand(2,1);


