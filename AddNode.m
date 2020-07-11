% -------------------------------------------------------------------------
%程序功能：
%       加入新的节点，初始化其R值和V值
%程序输入：
%      Graph,Arc,R,V
%      K:增加节点所在层数
%程序输出：
%       Graph:记录网络每层的节点编号
%       Arc:记录网络边的连接

% -------------------------------------------------------------------------
function [Graph_new,Arc_new,R_new,V_new,Repu_new,Tp_new] = AddNode(Graph,Arc,R,V,Repu,TP,K)

alpha = 0.1;  %弱连接系数
a = 1/3; b = 1/3; c = 1/3; %产量线性组合参数
R_sigma = 0.1;  %R高斯分布方差
gamma = 10;    %调节g大小的参数
V_sigma = 0.01; %V高斯分布方差



New_node_R_initial = betarnd(2,5);
New_node_V_initial = betarnd(2,5)*randi([3,10]);   
New_node_V = normrnd(New_node_V_initial, 0.1)

start_flag=randi([1,length(Graph{K})]);  %第start_flag之后插入 
add_node_number = Graph{K}(start_flag)+1;

%%Graph更新
Graph{K}=[Graph{K},Graph{K}(length(Graph{K}))+1];%本层更新
for i = K + 1 : length(Graph)
    for j = 1 : length(Graph{i})
        Graph{i}(j) = Graph{i}(j);
    end
end

%%Arc更新
for i = 1 : length(Arc)
    for j = 1 : length(Arc{i})
        for k = 1 : 2
            if Arc{i}(j,k)>=add_node_number
                Arc{i}(j,k)=Arc{i}(j,k)+1              
            end
        end
    end
end

for i = K-1 : length(Arc)
    for j = 1 : length(Arc{i})
        if Arc{i}(j,1) = add_node_number+1
            Arc{i}=[Arc{i}(1:j-1,:); [add_node_number,Arc{i}(j,2)]  ;Arc{i}(1:j,:)
        end
        if Arc{i}(j,2) = add_node_number+1
            Arc{i}=[Arc{i}(1:j-1,:); [Arc{i}(j,1),add_node_number]  ;Arc{i}(1:j,:)
        end
    end
end


friend_Num=3;
friend_list = Graph{K+1};
real_friend_list = friend_list(randperm(length(Graph{K+1}),friend_Num));
%Arc{K}=[Arc{K}(1:max(find(Arc{K}==(add_node_number+1))),:);[add_node_number,real_friend_list'];Arc{i}(max(find(Arc{1}==2))+1:end,:))',real_friend_list]
Arc{K}=[Arc{K}(1:max(find(Arc{1}==2)),:);[add_node_number*ones(1,length(real_friend_list))',real_friend_list'];Arc{K}(max(find(Arc{K}==add_node_number+1))+1:length(Arc{K}),:)];

friend_list_pre = Graph{K-1};
real_friend_list_pre = friend_list_pre(randperm(length(Graph{K-1}),friend_Num));
for i = 1:length(real_friend_list_pre)
    Arc{K-1}=[Arc{K-1}(1:max(find(Arc{K-1}==real_friend_list_pre(i))),:);[real_friend_list_pre(i),add_node_number];Arc{K-1}(max(find(Arc{K-1}==real_friend_list_pre(i)))+1,:length(Arc{K-1}),:)];  
end


%V更新
V{K}=[V{K}(1:start_flag),New_node_V,V{K}(start_flag+1:length(Graph{K}))];
R{K}=[R{K}(1:start_flag),New_node_R_initial,R{K}(start_flag+1:length(Graph{K}))];
[R_list,V_list] = calc_RV_list(R,V) ;
R = R_Calc(Graph,Arc,R,V_list,alpha,a,b,c,R_sigma,gamma);

Graph_new=Graph;
Arc_new=Arc;
R_new=R;
V_new=V;

end



% for j = start_flag:(Graph{K}+1)
%     Graph
    
    

% end

% R{K}=[R{K}(1:start_flag),New,R{K}(6:15)]

% for i = K : length(Graph)
%     for j = start_flag : Graph{i}
%         Graph

    
% end

% end

% function [Graph,Arc] = Graph_Create(Chain_layer_Num,CoopNum,Max_node,Min_node)
%     %图节点
%     Graph = cell(1,Chain_layer_Num);
%     node_sum=0;    %节点总数
%     node_num=zeros(1,Chain_layer_Num);   %各层节点个数
%     Max_node_num =Max_node*ones(1,Chain_layer_Num); %每一层最大节点个数                （可调）
%     Min_node_num =Min_node*ones(1,Chain_layer_Num); %每一层最小节点个数                 （可调）
    
%     for i=1:Chain_layer_Num
%         node_num(i)=randi([Min_node_num(i),Max_node_num(i)]);    %第i层真实节点个数
%         Graph{i}=((node_sum+1):(node_sum+node_num(i)));
%         node_sum=node_sum+node_num(i);
%     end
    
%     %边连接
%     Arc_layer_Num=Chain_layer_Num-1;   %边层数
%     Arc = cell(1,Arc_layer_Num);
%     for i = 1:Arc_layer_Num
%         All_Connect_matrix=[];
%         for j = 1:length(Graph{i})
%             Max_friends_Num=min(CoopNum,length(Graph{i+1}));     %每个节点最大连接数
%             Min_friends_Num = ceil(0.2* Max_friends_Num);                        %每个节点最小连接数
%             friend_Num=randi([Min_friends_Num,Max_friends_Num]);  
%             Connect_matrix=zeros(friend_Num,2);
%             Connect_matrix(:,1)=Graph{i}(j);
%             friend_list = Graph{i+1};
%             real_friend_list = friend_list(randperm(length(Graph{i+1}),friend_Num));
%             Connect_matrix(:,2)=real_friend_list';
%             All_Connect_matrix=[All_Connect_matrix;Connect_matrix];
%         end
%         next_layer_choosen_nodes=All_Connect_matrix(:,2);
%         next_list_len=length(next_layer_choosen_nodes);
%         next_every_num=zeros(1,length(Graph{i+1}));
%         delete_list=[];
%         for u=1: next_list_len
%             for t=1:length(Graph{i+1})
%                 if next_layer_choosen_nodes(u)==Graph{i+1}(t)
%                     next_every_num(t)=next_every_num(t)+1;
%                     if next_every_num(t)>CoopNum
%                         delete_list=[delete_list,u];
%                         next_every_num(t)=next_every_num(t)-1;
%                     end
%                 end
%             end
%         end
%         All_Connect_matrix(delete_list,:)=[];
        
        
% %         for t= 1: length(Graph{i+1})
% %             next_num=
% %             if sum(All_Connect_matrix==Graph{i+1}(t))>CoopNum
% %                 
% %                 
% %                 
% %             end
%         Arc{i}=All_Connect_matrix;
%     end
% end      