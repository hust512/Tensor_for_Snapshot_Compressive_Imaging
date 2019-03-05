function [Phi,y] = generate_without_optimization(L,N,frames,s,mask,captured)
    % mask n×n×8 (对角化后为8N×8N)
    % captured n×n
    % Phi L×8N
    % captured_out L×1
    
    % 预处理，将mask中的0转化为1，这里因为mask中0和1个数大致相同，可以先对0/1个数不做考虑
    captured = captured(:);
    captured = 2*(captured-mean(captured));
    mask(mask==0) = -1;
    
    nonzero_num = frames*N/s;
    % 生成Phi及其对应的y
    Phi = zeros(L,N,frames);
    y = zeros(L,1);
    real_s = 0;
    for i=1:L
        s_i = 0;
        selecteds = [];
        while s_i<nonzero_num
            selected = unidrnd(N);
            if ismember(selected,selecteds)
                continue;
            else
                selecteds = [selecteds,selected];
            end
            Phi(i,:,:) = Phi(i,:,:) + map2vec(N,frames,selected,mask);
            y(i) = y(i) + captured(selected);
            real_s = real_s + 8;
            s_i = s_i + 8;
        end
        real_s = real_s - 8;
    end
    real_s = L*frames*N/(real_s);
    
    Phi = sqrt(real_s)*Phi;
    
    expectation = mean(Phi(:)) % 期望 0
    variance = sum(Phi(:).*Phi(:))/(L*N*frames) % 方差 1
end