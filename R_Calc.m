% -------------------------------------------------------------------------
% 计算节点t+1时刻的R值。
% 该值取决于上一时刻的R值和上一时刻的上下游产量。
% 即对任一节点i，R(t+1)=(1-alpha)R(t)+alpha*g(V(t),Vu(t)，Vd(t))
% 其中g函数设定为g()~N((a*V+b*Vu+c*Vd),0.1)     即取一个以上下游产量线性组合为均值的高斯分布，a,b,c为可调参数
% 输入参数:连接关系、本时刻各节点弹性值，产值  
% 输出参数:下一时刻弹性值
% -------------------------------------------------------------------------
function R_new = R_calc(Graph,Arc,R,V)
    R_new = R;
    g = R;
    alpha = 0.1;  %弱连接系数
    a = 1/3; b = 1/3; c = 1/3; %产值线性组合参数
    sigma = 0.1;  %高斯分布方差
    gama = 10;    %调节g大小的参数
    for i = 1:length(R)
        for j = 1:length(R{i})
            temp = a*V{i}(j)+b*sum(find_parent_node(Graph,Arc,i,j))+c*sum(find_child_node(Graph,Arc,i,j)); 
            g{i}(j) = gama*normrnd(temp, sigma);
            R_new{i}(j) = (1-alpha)*R{i}(j)+alpha*g{i}(j);
        end
    end   
end