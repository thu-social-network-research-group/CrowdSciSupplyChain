function [Graph_new,Arc_new,R_new,V_new,Repu_new,TP_new,AgentLabel_new] = RemoveNode(Graph,Arc,R,V,Repu,TP,AgentLabel,TH)
%This function aims to remove those node with little R(R<TH)
%TH is the THRESHOLD
Graph_new=Graph;
Arc_new=Arc;
R_new=R;
V_new=V;
Repu_new=Repu;
TP_new=TP;
AgentLabel_new=AgentLabel;
count=1;
count_new=1;

% delete
i = 1;
j = 1;
while i <= length(R_new)
    while j <= length(R_new{i})
        if R_new{i}(j)<TH
            R_new{i}(j)=[];
            V_new{i}(j)=[];
            temp = Graph_new{i}(j);
            Graph_new{i}(j)=[];
            Repu_new(:,count)=66666;
            TP_new(:,count)=77777;
            AgentLabel_new(:,count)=88888;
            if i==1
                [remove_Arc_row,~]=find(Arc_new{i}==temp);
                Arc_new{i}(remove_Arc_row,:)=[];
            elseif i==length(R_new)
                [remove_Arc_row,~]=find(Arc_new{i-1}==temp);
                Arc_new{i-1}(remove_Arc_row,:)=[];
            else
                [remove_Arc_row,~]=find(Arc_new{i}==temp);
                Arc_new{i}(remove_Arc_row,:)=[]; 
                [remove_Arc_row,~]=find(Arc_new{i-1}==temp);
                Arc_new{i-1}(remove_Arc_row,:)=[];
            end
            j = j-1;
            count_new=count_new-1; 
        end
        j = j + 1;
        count=count+1;
        count_new=count_new+1;
    end
    i = i + 1;
    j = 1;
end

%Repu,TP,AgentLabel's final Removal
Repu_new(:,Repu_new(1,:) == 66666)=[];
TP_new(TP_new(1,:) == 77777) = [];
AgentLabel_new(AgentLabel_new(1,:) == 88888) = [];

%recount
count_new=0;
for i=1:length(Graph_new)
    for j=1:length(Graph_new{i})
        count_new = count_new + 1;
        if Graph_new{i}(j) == count_new
        else 
            temp = Graph_new{i}(j);
            Graph_new{i}(j) = count_new;
            if i==1
                [change_node_row,~]=find(Arc_new{i}==temp);
                Arc_new{i}(change_node_row,1)=count_new;
            elseif i==length(R)
                [change_node_row,~]=find(Arc_new{i-1}==temp);
                Arc_new{i}(change_node_row,2)=count_new;
            else
                [change_node_row,~]=find(Arc_new{i}==temp);
                Arc_new{i}(change_node_row,1)=count_new;
                [change_node_row,~]=find(Arc_new{i-1}==temp);
                Arc_new{i-1}(change_node_row,2)=count_new;
            end
        end
    end
end
%%%%暂时的解决方法
if length(Arc_new)==8
    Arc_new{7}(:,2) = Arc_new{8}(:,2);
    Arc_new(8)=[];
end

end
