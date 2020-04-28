function Y=Dis_Rand(X,P,Num)
%在给定概率情况下不重复取数的函数
% X：可能取值
% P：取值概率
% Num：拟取数的个数
Y=zeros(Num,1);
for i=1:Num
    P = P/sum(P);
    CP=cumsum(P);
    temp = sum(CP<=rand(1))+1;
    Y(i)=X(temp);
    P(temp) = 0;
end