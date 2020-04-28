function P = calculateP(R, sigma)
% -------------------------------------------------------------------------
% 计算节点改变连接的先决概率P。如果一个节点的R值越高，它越倾向于维持现有的连接，从而越不容易改变策略；
% 反之如果一个节点的R值越低，那么它反而越倾向于积极地改变自己地策略
% 输入参数：
% R: 每一层，每个节点的R值，cell数组
% sigma: sigmoid 函数中的超参数
% 输出参数：
% P: 与 R 的形状完全相同的cell数组，每一个元素代表了对应节点改变现有连接的概率
% -------------------------------------------------------------------------
    layerNum = length(R);  % 层数
    P = cell(1, layerNum);  % 初始化 P
    for i = 1:layerNum  % 遍历每一层
        % 根据R值越大，P越趋向于0；而R值越小，P越趋向于1的特点
        % 这里先暂定使用1 - sigmoid函数
        P{i} = 1 - 1./(1 + exp(-sigma * R{i}));
    end
end