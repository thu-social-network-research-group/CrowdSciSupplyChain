% set percentage RV to zero
function [R_new,V_new, ind_i, ind_j] = attack_RV(R_list,V_list,percentage,Graph)
    %随机选取n个元素
    nodenum = length(R_list);
    ind = randperm(nodenum, round(percentage*nodenum));
    R_list(ind) = 0.001;
    V_list(ind) = 0.001;
    %R_list V_list 重新翻回R和V的cell结构
    R_new = Graph;
    V_new = Graph;
    cnt = 0;
    for i = 1:length(Graph)
        for j = 1:length(Graph{i})
            cnt = cnt+1;
            if cnt == ind(1)
                ind_i = i;
                ind_j = j;
            end
            R_new{i}(j) = R_list(cnt);
            V_new{i}(j) = V_list(cnt);
        end
    end
end