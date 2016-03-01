function y = overlapaddreal(B, x, N)
    M = length(B);          % length of filter response

    if N < M
        error('N is less than the length of filter response M.');
    end

    L = N - M + 1;          % x[n] segment length

    N_x = length(x);        % length of x[n]
    kmax = ceil(N_x/L);     % number of data blocks

    x = [x zeros(1, kmax*L - N_x)];     % pad with zeros to make up (kmax * L) elements

    y_matrix = zeros(kmax, kmax*L + M-1);
    for k = 1:kmax
        index_start = (k-1)*L + 1;
        index_end = k * L;
        
        x_k = [x(index_start:index_end) zeros(1, M-1)];
        y_k = filter(B, 1, x_k);
        row = [zeros(1, (k-1)*L) y_k];      % right shift y_k and pad with zeros
        y_matrix(k, 1:length(row)) = row;
    end

    y = sum(y_matrix);
    y = y(1:N_x);
end
