%unction [Graph_new,Arc_new,R_new,Repu_new,TP_new] = RemoveNode(Graph,Arc,R,Repu,TP,TH)
function [Graph_new,Arc_new,R_new] = RemoveNode(Graph,Arc,R,TH)

    %This function aims to remove those node with little R(R<TH)
%TH is the THRESHOLD
Graph_new=Graph;
Arc_new=Arc;
R_new=R;
%Repu_new=Repu;
%TP_new=TP;
count=1;
count_new=1
for i = 1:length(R)
    for j = 1:length(R{i})
        if R{i}(j)<TH
            R_new{i}(j)=[];
            Graph_new{i}(j)=[];
            Graph_new{i}(j)=count_new;
 %           Repu_new(:,count)=66666;
  %          TP_new(:,count)=77777;
            if i==1
                [remove_Arc_row,~]=find(Arc{i}==Graph{i}(j));
                Arc_new{i}(remove_Arc_row,:)=[];
                [change_node_row,~]=find(Arc_new{i}==count);
                Arc_new{i}(change_node_row,1)=count_new;
            elseif i==length(R)
                [remove_Arc_row,~]=find(Arc{i-1}==Graph{i}(j));
                Arc_new{i-1}(remove_Arc_row,:)=[];
                [change_node_row,~]=find(Arc_new{i-1}==count);
                Arc_new{i}(change_node_row,2)=count_new;
            else
                [remove_Arc_row,~]=find(Arc{i}==Graph{i}(j));
                Arc_new{i}(remove_Arc_row,:)=[]; 
                [change_node_row,~]=find(Arc_new{i}==count);
                Arc_new{i}(change_node_row,1)=count_new;
                [remove_Arc_row,~]=find(Arc{i-1}==Graph{i}(j));
                Arc_new{i-1}(remove_Arc_row,:)=[];
                [change_node_row,~]=find(Arc_new{i-1}==count);
                Arc_new{i-1}(change_node_row,2)=count_new;
            end
            count_new=count_new-1; 
        end
        count=count+1;
        count_new=count_new+1;
    end
end


% Total_node_num=Graph{8}(length(Graph{8}));
% New_node_num=Graph_new{8}(length(Graph_new{8}));


% Graph_new{1}=[1234]

% count=1
% for i=1:length(R_new)
%     for j=1:length(R_new{i})
%         if R_new{i}(j)==count
%             Graph_new{i}(j)=count;
%         else

%         end
%         Graph_new{i}(j)=count;


%     end
% end



end
