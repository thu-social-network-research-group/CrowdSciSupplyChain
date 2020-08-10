function [TP, Repu Arcs] = AgentGame3(Graph, Arc, Repu, TP, Payoff, gama, AgentLabel)
%gama:Repu˥��ϵ��
%AgentLabel:�û����ͼ�¼
%GreedRate��̰���û�����ʱ���������
%��Markov��Repu�²��Ĺ���
LayerNum = length(Graph);
Arcs = Arc;%record the state of every Arc
ArcState = [1,2
    3,4];
Repu0 = Repu;%The Repu of last turn
Repu = Repu*gama;
AgentNum = size(Repu, 2);
GreedRate = 0.2;%̰�����Գ̶�
%The game of every arc
for i = 1 : LayerNum - 1
    ArcNumThisLayer = size(Arc{i},1);%The number of arc in this layer
    for j = 1 : ArcNumThisLayer
        BusinessRate = 2*rand(1);%�����������payoffΪ���׵Ľ��,��ÿ�ν��׶�Ϊ�����
        agent1 = Arc{i}(j,1);
        agent2 = Arc{i}(j,2);
        %Generate the policy
        if(AgentLabel(agent1) == 1)
            if(rand(1) < Repu0(1, agent2))
                agent1Policy = 1;%cooperate
                Repu(2, agent1) = Repu(2, agent1) + BusinessRate;%update the Repu
            else
                agent1Policy = 2;%defect
                Repu(3, agent1) = Repu(3, agent1) + BusinessRate;
            end
        elseif(AgentLabel(agent1) == 2)
            %����̰���û�����Business�ϴ�ʱ��������ѡ���ѣ���֮�����ں���
            if(rand(1) < Repu0(1, agent2) - GreedRate*(BusinessRate - 1))
                agent1Policy = 1;%cooperate
                Repu(2, agent1) = Repu(2, agent1) + BusinessRate;%update the Repu
            else
                agent1Policy = 2;%defect
                Repu(3, agent1) = Repu(3, agent1) + BusinessRate;
            end
        end
        
        if(AgentLabel(agent2) == 1)
            if(rand(1) < Repu0(1, agent1))
                agent2Policy = 1;%cooperate
                Repu(2, agent2) = Repu(2, agent2) + BusinessRate;
            else
                agent2Policy = 2;%defect
                Repu(3, agent2) = Repu(3, agent2) + BusinessRate;
            end
        elseif(AgentLabel(agent2) == 2)
            if(rand(1) < Repu0(1, agent1) - GreedRate*(BusinessRate - 1))
                agent2Policy = 1;%cooperate
                Repu(2, agent2) = Repu(2, agent2) + BusinessRate;
            else
                agent2Policy = 2;%defect
                Repu(3, agent2) = Repu(3, agent2) + BusinessRate;
            end
        end
        
        TP(agent1) = TP(agent1) + BusinessRate*Payoff{agent1Policy, agent2Policy}(1);
        TP(agent2) = TP(agent2) + BusinessRate*Payoff{agent1Policy, agent2Policy}(2);
        
        Arcs{i}(j,3) = ArcState(agent1Policy, agent2Policy);
        
    end
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