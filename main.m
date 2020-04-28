clc;clear
%图节点
Graph = cell(1,3);
Graph{1} = [1,2,3];%第一层节点编号
Graph{2} = [4,5,6];
Graph{3} = [7,8];

%边连接
Arc = cell(1,2);
Arc{1} = [1,4;
    1,5;
    2,6;
    3,5];%第一层到第二层的连接
Arc{2} = [5,7;
    4,8];

%R值
R = cell(1,3);
R{1} = [3,2,1];%第一层的R值
R{2} = [4,5,6];
R{3} = [8,8];

%改变概率矩阵P
P = cell(1,3);
P{1} = zeros(3,1);%第一层的P值
P{2} = zeros(3,1);
P{3} = zeros(2,1);

Arc = UpdateArc(Graph, Arc, R, P, 2);

