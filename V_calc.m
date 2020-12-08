%更新t时刻各节点的产值V
%以上一时刻产值为均值?，Vsigma为方差做高斯分布
%资金冗余V与payoff有关
function V = V_calc(Graph,R,V,V_sigma, payoff_one_turn)
    mean_payoff = mean(payoff_one_turn);
    for i = 1:length(V)
        for j = 1:length(V{i})
            % V{i}(j) = normrnd(V{i}(j), V_sigma); 
            if max(payoff_one_turn)==0
                temp = 0;
            else %normalized to (0,1)
                temp =  (payoff_one_turn(Graph{i}(j)) - min(payoff_one_turn)) / (max(payoff_one_turn) - min(payoff_one_turn));
            end
            V{i}(j) = normrnd(0.9*V{i}(j) + temp, V_sigma);
            % V{i}(j) = normrnd(V{i}(j), V_sigma)  + temp;
        end
    end
end 
