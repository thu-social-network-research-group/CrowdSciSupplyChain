% -------------------------------------------------------------------------
% è®¡ç®—èŠ‚ç‚¹t+1æ—¶åˆ»çš„Rå€¼ã?
% è¯¥å?å–å†³äºŽä¸Šä¸?—¶åˆ»çš„Rå€¼å’Œä¸Šä¸€æ—¶åˆ»çš„ä¸Šä¸‹æ¸¸äº§é‡ã€?
% å³å¯¹ä»»ä¸€èŠ‚ç‚¹iï¼ŒR(t+1)=(1-alpha)R(t)+alpha*g(V(t),Vu(t)ï¼ŒVd(t))
% å…¶ä¸­gå‡½æ•°è®¾å®šä¸ºg()~N((a*V+b*Vu+c*Vd),0.1)     å³å–ä¸?¸ªä»¥ä¸Šä¸‹æ¸¸äº§é‡çº¿æ?ç»„åˆä¸ºå‡å€¼çš„é«˜æ–¯åˆ†å¸ƒï¼Œa,b,cä¸ºå¯è°ƒå‚æ•?
% è¾“å…¥å‚æ•°:è¿žæŽ¥å…³ç³»ã€?æœ¬æ—¶åˆ»å„èŠ‚ç‚¹å¼¹æ?å€¼ï¼Œäº§å?  
% è¾“å‡ºå‚æ•°:ä¸‹ä¸€æ—¶åˆ»å¼¹æ?å€?
% -------------------------------------------------------------------------
function R_new = R_calc(Graph,Arc,R,V_list,alpha,a,b,c,R_sigma,gamma,payoff_one_turn)
    R_new = R;
    g = R;
    for i = 1:length(R)
        for j = 1:length(R{i})
            temp = a*V_list(Graph{i}(j))+b*calc_parents_V(Graph,Arc,V_list,i,j)+c*calc_childs_V(Graph,Arc,V_list,i,j); 
            temp = exp(-temp);
            temp = temp + payoff_one_turn(Graph{i}(j))/ max(payoff_one_turn);
            g{i}(j) = gamma*normrnd(temp, 1/R{i}(j)*R_sigma);%
            R_new{i}(j) = max(0.001, (1-alpha)*R{i}(j)+alpha*g{i}(j));
        end
    end   
end