function Y=Dis_Rand(X,P,Num)
%�ڸ�����������²��ظ�ȡ���ĺ���
% X������ȡֵ
% P��ȡֵ����
% Num����ȡ���ĸ���
Y=zeros(Num,1);
for i=1:Num
    P = P/sum(P);
    CP=cumsum(P);
    temp = sum(CP<=rand(1))+1;
    Y(i)=X(temp);
    P(temp) = 0;
end