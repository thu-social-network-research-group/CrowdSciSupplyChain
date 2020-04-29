%按照序号顺序排列各节点R值、V值(展开为长向量)
function [R_list,V_list] = calc_RV_list(R,V)
    R_list=[];V_list=[];
    for i = 1:length(R)
        for j = 1:length(R{i})
            R_list=[R_list,R{i},(j)];
            V_list=[V_list,V{i},(j)];
        end
    end
end