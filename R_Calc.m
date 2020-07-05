% -------------------------------------------------------------------------
% 计算节点t+1时刻的R值
% 该值取决于上一时刻刻的R值和上一时刻的上下游产量?
% 即对任一节点i，R(t+1)=(1-alpha)R(t)+alpha*g(V(t),Vu(t)，Vd(t))
% 其中g函数设定为g()~N((a*V+b*Vu+c*Vd),0.1)，即取上一时刻上下游产量线性组合为均值的高斯分布，a,b,c为可调参数?
% 输入参数:连接关系、本时刻各节点弹性值R，产值V
% 输出参数:下一时刻弹性值
% -------------------------------------------------------------------------
function R_new = R_calc(Graph,Arc,R,V_list,alpha,a,b,c,R_sigma,gamma)
    R_new = R;
    g = R;
    for i = 1:length(R)
        for j = 1:length(R{i})
            temp = a*V_list(Graph{i}(j))+b*calc_parents_V(Graph,Arc,V_list,i,j)+c*calc_childs_V(Graph,Arc,V_list,i,j); 
            g{i}(j) = gamma*normrnd(temp, R_sigma);
            R_new{i}(j) = max(0, (1-alpha)*R{i}(j)+alpha*g{i}(j));
        end
    end   
end