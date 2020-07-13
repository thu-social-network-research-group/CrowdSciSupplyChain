function [TP, Repu Arcs] = AgentGamePure(Graph, Arc, Repu, TP, Payoff)
LayerNum = length(Graph);
Arcs = Arc;%record the state of every Arc
ArcState = [1,2
            3,4];
Repu0 = Repu;%The Repu of last turn
AgentNum = size(Repu, 2);
Repu = zeros(3, AgentNum);%The Repu of this turn
%The game of every arc
for i = 1 : LayerNum - 1
    ArcNumThisLayer = size(Arc{i},1);%The number of arc in this layer
    for j = 1 : ArcNumThisLayer
        agent1 = Arc{i}(j,1);
        agent2 = Arc{i}(j,2);
        %Generate the policy
        if(Repu0(1, agent2) >= 0.5)
            agent1Policy = 1;%cooperate
            Repu(2, agent1) = Repu(2, agent1) + 1;%update the Repu
        else
            agent1Policy = 2;%defect
            Repu(3, agent1) = Repu(3, agent1) + 1;
        end
        
        if( Repu0(1, agent1) >= 0.5)
            agent2Policy = 1;%cooperate
            Repu(2, agent2) = Repu(2, agent2) + 1;
        else
            agent2Policy = 2;%defect
            Repu(3, agent2) = Repu(3, agent2) + 1;
        end
        
        TP(agent1) = TP(agent1) + Payoff{agent1Policy, agent2Policy}(1);
        TP(agent2) = TP(agent2) + Payoff{agent1Policy, agent2Policy}(2);
        
        Arcs{i}(j,3) = ArcState(agent1Policy, agent2Policy);
        
    end
    
    for i = 1 : AgentNum
        NumOfArc = Repu(2, i) + Repu(3, i); %The Arc number of the agent
        if(NumOfArc == 0)
            Repu(1, i) = Repu0(1, i); % if in this turn, the agent has no Arc. We set the cooperate rate as the cooperate of last turn
        else
            Repu(1, i) = Repu(2, i)/NumOfArc;
        end
    end
end