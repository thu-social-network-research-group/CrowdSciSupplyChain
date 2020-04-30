% -------------------------------------------------------------------------
%程序功能：
%       建立图（节点、边）的元胞
%程序输入：
%      节点层数Chain_layer_Num
%程序输出：
%       Graph:记录网络每层的节点编号
%       Arc:记录网络边的连接
% -------------------------------------------------------------------------
function [Graph,Arc] = Graph_create(Chain_layer_Num,CoopNum,Max_node,Min_node)
    %图节点
    Graph = cell(1,Chain_layer_Num);
    node_sum=0;    %节点总数
    node_num=zeros(1,Chain_layer_Num);   %各层节点个数
    Max_node_num =Max_node*ones(1,Chain_layer_Num); %每一层最大节点个数                （可调）
    Min_node_num =Min_node*ones(1,Chain_layer_Num); %每一层最小节点个数                 （可调）
    
    for i=1:Chain_layer_Num
        node_num(i)=randi([Min_node_num(i),Max_node_num(i)]);    %第i层真实节点个数
        Graph{i}=((node_sum+1):(node_sum+node_num(i)));
        node_sum=node_sum+node_num(i);
    end
    
    %边连接
    Arc_layer_Num=Chain_layer_Num-1;   %边层数
    Arc = cell(1,Arc_layer_Num);
    for i = 1:Arc_layer_Num
        All_Connect_matrix=[];
        for j = 1:length(Graph{i})
            Max_friends_Num=min(CoopNum,length(Graph{i+1}));     %每个节点最大连接数
            Min_friends_Num = ceil(0.2* Max_friends_Num);                        %每个节点最小连接数
            friend_Num=randi([Min_friends_Num,min(Max_friends_Num)]);  
            Connect_matrix=zeros(friend_Num,2);
            Connect_matrix(:,1)=Graph{i}(j);
            friend_list = Graph{i+1};
            real_friend_list = friend_list(randperm(length(Graph{i+1}),friend_Num));
            Connect_matrix(:,2)=real_friend_list';
            All_Connect_matrix=[All_Connect_matrix;Connect_matrix];
        end
        Arc{i}=All_Connect_matrix;
    end
end        
            
%             
%             V{i}(j) = normrnd(V{i}(j), 0.01*R{i}(j)); 
%     end
%     Arc_num=zeros(1,Arc_layer_Num);
%     for i=1:Arc_layer_Num
%         Max_arc_num=length(Graph{i})*length(Graph{i+1});   %第i层最大边数（设置为全连接时）
%         Min_arc_num=ceil(Max_arc_num/3);     %第i层最小边数（取为全连接的1/3，向上取整）
%         Arc_num(i)=randi([Min_arc_num,Max_arc_num]);                  %第i层的边数
%         Connect_matrix=zeros(Arc_num(i),2);  %第i层的连接矩阵(边数*2矩阵)
%         for j=1:Arc_num(i)
%             Connect_matrix(j,1)=randi([Graph{i}(1),Graph{i}(1)+length(Graph{i})-1]); %Node_choose_i_layer
%             Connect_matrix(j,2)=randi([Graph{i+1}(1),Graph{i+1}(1)+length(Graph{i+1})-1],1);  %Node_choose_i+1_layer
%         end
%         Connect_matrix= unique(Connect_matrix,'rows','stable');                %去除重复边
%         for k=Graph{i}:
%         choose_friends = Connect_matrix(randperm(length(t),CoopNum));
%         Arc{i}=choose_friends;
%         Arc_num = length(Arc{i}) ;                                              %修正第i层边数
%     end    

    
    