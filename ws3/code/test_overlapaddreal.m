for k=1:10000
    clear;
    
    B = 1:floor(rand()*10)+10;
    N = length(B) + floor(rand()*10);
    x = rand(1, N*2+floor(rand()*100));

    y1 = filter(B, 1, x);
    y2 = overlapaddreal(B, x, N);

    difference = any(abs(y1 - y2) > eps('single'));
    
    if difference
        error('error');
    end
end
