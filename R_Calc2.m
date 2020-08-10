% -------------------------------------------------------------------------
% ����ڵ�t+1ʱ�̵�Rֵ
% ��ֵȡ������һʱ�̵̿�Rֵ����һʱ�̵������β���?
% ������һ�ڵ�i��R(t+1)=(1-alpha)R(t)+alpha*g(V(t),Vu(t)��Vd(t))
% ����g�����趨Ϊg()~N((a*V+b*Vu+c*Vd),0.1)����ȡ��һʱ�������β����������Ϊ��ֵ�ĸ�˹�ֲ���a,b,cΪ�ɵ�����?
% �������:���ӹ�ϵ����ʱ�̸��ڵ㵯��ֵR����ֵV
% �������:��һʱ�̵���ֵ
% -------------------------------------------------------------------------
function R_new = R_Calc2(Graph,Arc,R,V_list,alpha,a,b,c,R_sigma,gamma)
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

