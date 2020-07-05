function Repu = Repu_intial(Graph)
AgentNum = Graph{end}(end);
Repu = [rand(1, AgentNum);zeros(2, AgentNum)];
end