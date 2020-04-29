% -------------------------------------------------------------------------
%%%程序功能：建立图（节点、边）的元胞
%%%程序输入：
%节点层数Chain_layer_Num
%%%程序输出：
%Graph:记录网络每层的节点编号
%Arc:记录网络边的连接
% -------------------------------------------------------------------------
function [Graph,Arc] = Graph_create(Chain_layer_Num)
    %图节点
    Graph = cell(1,Chain_layer_Num);
    node_sum=0;    %节点总数
    node_num=zeros(1,Chain_layer_Num);   %各层节点个数
    Max_node_num=10*ones(1,Chain_layer_Num); %每一层最大节点个数
    Min_node_num_=4*ones(1,Chain_layer_Num); %每一层最小节点个数
    
    for i=1:Chain_layer_Num
        node_num(i)=randi([Min_node_num(i),Max_node_num(i)]);    %第i层真实节点个数
        Graph{i}=((node_sum+1):(node_sum+node_num(i)));
        node_sum=node_sum+node_num(i);
    end
    
    %边连接
    Arc_layer_Num=Chain_layer_Num-1;   %边层数
    Arc = cell(1,Arc_layer_Num);
    for i=1:Arc_layer_Num
        Max_arc_num=length(Graph{i})*length(Graph{i+1});   %第i层最大边数（设置为全连接时）
        Min_arc_num=ceil(Max_arc_num/3);     %第i层最小边数（取为全连接的1/3，向上取整）
        Arc_num(i)=randi([Min_arc_num,Max_arc_num],1);                  %第i层的真实边数
        Connect_matrix=zeros(Arc_num(i),2);  %第i层的连接矩阵(边数*2矩阵)
        for j=1:Arc_num(i)
            Connect_matrix(j,1)=randi([Graph{i}(1),Graph{i}(1)+length(Graph{i})-1]); %Node_choose_i_layer
            Connect_matrix(j,2)=randi([Graph{i+1}(1),Graph{i+1}(1)+length(Graph{i+1})-1],1);  %Node_choose_i+1_layer
        end
        Arc{i}=Connect_matrix;
    end    
end
    
    