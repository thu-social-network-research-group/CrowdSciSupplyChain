function AgentLabel = AgentLabel_intial(Graph, GreedAgentRate)
%GreedAgentRate:̰���û��ı���
AgentNum = Graph{end}(end);
AgentLabel = ones(1, AgentNum);
for i = 1 : AgentNum
    if(rand(1) < GreedAgentRate)
    	AgentLabel(i) = 2;
    end
end
end