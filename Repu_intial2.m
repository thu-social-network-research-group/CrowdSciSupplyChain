function Repu = Repu_intial2(Graph)
%��Markov��repu��������£���repu���г�ʼ��
AgentNum = Graph{end}(end);
%Repu = [zeros(1, AgentNum);round(5*rand(2, AgentNum)+1)];
Repu = [zeros(1, AgentNum);9*ones(1, AgentNum);1*ones(1, AgentNum)];
%Repu = [zeros(1, AgentNum);ones(2, AgentNum)];
for i = 1 : AgentNum
    Repu(1, i) = Repu(2, i)/(Repu(2, i) + Repu(3, i));
end
end