function [Graph_new,Arc_new,R_new,Reward_new,B_new] = RemoveNode(Graph,Arc,R,Reword,B,TH)
%This function aims to remove those node with little R(R<TH)
%TH is the THRESHOLD
Graph_new=Graph;
Arc_new=Arc;
R_new=R;
Reward_new=Reword;
B_new=B;
for i = 1:length(R)
    for j = 1:length(R{i})
        if R{i}(j)<TH
            R{i}(j)=[];
            Graph_new{i}(j)=[];
            Reward_new{i}(j)=[];
            B_new{i}(j)=[];
            if i==1
                [remove_Arc_row,~]=find(Arc{i}==Graph{i}(j));
                Arc_new{i}(remove_Arc_row,:)=[];
            elseif i==length(R)
                [remove_Arc_row,~]=find(Arc{i-1}==Graph{i}(j));
                Arc_new{i-1}(remove_Arc_row,:)=[];
            else
                [remove_Arc_row,~]=find(Arc{i}==Graph{i}(j));
                Arc_new{i}(remove_Arc_row,:)=[]; 
                [remove_Arc_row,~]=find(Arc{i-1}==Graph{i}(j));
                Arc_new{i-1}(remove_Arc_row,:)=[];
            end 
        end
    end
end
end
