function Repu = Repu_intial2(Graph)
%非Markov的repu更新情况下，对repu进行初始化
AgentNum = Graph{end}(end);
Repu = [zeros(1, AgentNum);round(5*rand(2, AgentNum)+1)];
for i = 1 : AgentNum
    Repu(1, i) = Repu(2, i)/(Repu(2, i) + Repu(3, i));
end
end