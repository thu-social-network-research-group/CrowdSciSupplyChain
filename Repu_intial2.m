function Repu = Repu_intial2(Graph)
%非Markov的repu更新情况下，对repu进行初始化
AgentNum = Graph{end}(end);
%Repu = [zeros(1, AgentNum);round(5*rand(2, AgentNum)+1)];
Repu = [zeros(1, AgentNum);9*ones(1, AgentNum);1*ones(1, AgentNum)];
%Repu = [zeros(1, AgentNum);ones(2, AgentNum)];
for i = 1 : AgentNum
    Repu(1, i) = Repu(2, i)/(Repu(2, i) + Repu(3, i));
end
end