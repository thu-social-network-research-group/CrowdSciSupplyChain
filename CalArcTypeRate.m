function ArcTypeRate = CalArcTypeRate(Arcs)
%Calculate the rate of different type of arc
%(all cooperate--1  all defect--4 one cooperate one defect--2,3)
%input:Arcs
%output:ArcTypeRate:the rate of different type of arc
NumOfType1 = 0;%all cooperate
NumOfType2 = 0;% up cooperate down defect
NumOfType3 = 0;%down cooperate up defect
NumOfType4 = 0;%all defect
ArcTypeRate = zeros(1,3);
LayerNum = length(Arcs);
for i = 1 : LayerNum
    temp = Arcs{i}(:,3);
    NumOfType1 = NumOfType1 + length(find(temp == 1));
    NumOfType2 = NumOfType2 + length(find(temp == 2));
    NumOfType3 = NumOfType3 + length(find(temp == 3));
    NumOfType4 = NumOfType4 + length(find(temp == 4));
end
ArcNum = NumOfType1 + NumOfType2 + NumOfType3 + NumOfType4;
ArcTypeRate(1) = NumOfType1/ArcNum;
ArcTypeRate(2) = (NumOfType2+NumOfType3)/ArcNum;
ArcTypeRate(3) = NumOfType4/ArcNum;
end