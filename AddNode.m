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
New_node_V = normrnd(New_node_V_initial, 0.1);

start_flag = randi([1,length(Graph{K})]);  % insert after No.start_flag 
add_node_number = Graph{K}(start_flag)+1;

%%Repu, TP update
Repu_new = Repu;
TP_new = TP;
if add_node_number == length(Repu_new)
    Repu_new = [Repu_new,zeros(3,1)];
    TP_new = [TP_new,0];
else
    Repu_new = [Repu_new(:,1:add_node_number),zeros(3,1), Repu_new(:,add_node_number+1:end)];
    TP_new = [TP_new(1:add_node_number),0,TP_new(add_node_number+1:end)];
end

%%Graph update
Graph{K} = [Graph{K},Graph{K}(length(Graph{K}))+1];%本层更新
for i = K + 1 : length(Graph)
    for j = 1 : length(Graph{i})
        Graph{i}(j) = Graph{i}(j)+1;
    end
end

%%Arc update
for i = 1 : length(Arc)
    for j = 1 : length(Arc{i})
        for k = 1 : 2
            if Arc{i}(j,k) >= add_node_number % change the number after add_node_number
                Arc{i}(j,k) = Arc{i}(j,k)+1;              
            end
        end
    end
end

% intial the arc of the add_node_number
friend_Num=3;
friend_list = Graph{K+1};
real_friend_list = friend_list(randperm(length(Graph{K+1}),friend_Num));
if add_node_number == max(Graph{K})
    Arc{K} = [Arc{K};[add_node_number*ones(1,length(real_friend_list))',real_friend_list']];
else
    Arc{K} = [Arc{K}(1:max(find(Arc{K}==add_node_number-1)),:);
            [add_node_number*ones(1,length(real_friend_list))',real_friend_list'];
            Arc{K}(min(find(Arc{K}==add_node_number+1)):length(Arc{K}),:)];
end

if K > 1
    friend_list_pre = Graph{K-1};
    real_friend_list_pre = friend_list_pre(randperm(length(Graph{K-1}),friend_Num));
    for i = 1:length(real_friend_list_pre)
        Arc{K-1} = [Arc{K-1}(1:max(find(Arc{K-1}==real_friend_list_pre(i))),:);
                    [real_friend_list_pre(i),add_node_number];
                    Arc{K-1}(max(find(Arc{K-1}==real_friend_list_pre(i)))+1:length(Arc{K-1}),:)];  
    end
end


%V update
if start_flag == length(V{K})
    V{K} = [V{K}, New_node_V];
    R{K} = [R{K}, New_node_R_initial];
else
    V{K} = [V{K}(1:start_flag), New_node_V, V{K}(start_flag+1:end)];
    R{K} = [R{K}(1:start_flag), New_node_R_initial, R{K}(start_flag+1:end)];
end

[R_list,V_list] = calc_RV_list(R,V) ;
R = R_Calc(Graph,Arc,R,V_list,alpha,a,b,c,R_sigma,gamma);

Graph_new=Graph;
Arc_new=Arc;
R_new=R;
V_new=V;
end

 
