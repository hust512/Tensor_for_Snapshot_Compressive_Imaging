% 利用SCI的mask生成投影矩阵和对应的y
function [Phi,y] = generate_without_optimization(L,N,frames,s,mask,captured,orig)
    % mask n×n×8 (对角化后为8N×8N)
    % captured n×n
    % Phi L×8N
    % captured_out L×1
    
    % 预处理，将mask中的0转化为1，这里因为mask中0和1个数大致相同，可以先对0/1个数不做考虑
    captured = captured(:);
    captured = 2*(captured-mean(captured));
    mask(mask==0) = -1;
    
    % 生成Phi及其对应的y
    [Phi,y] = buildSCI(L,N,s,frames,mask,captured);
    
    % 用于测试，实际会删掉
    Phi = reshape(Phi,[L,N*frames]);
    y = Phi*orig(:)/sqrt(L);
    Phi = reshape(Phi,[L,N,frames]);
    
    expectation = mean(Phi(:)) % 期望 0
    variance = sum(Phi(:).*Phi(:))/(L*N*frames) % 方差 1
end