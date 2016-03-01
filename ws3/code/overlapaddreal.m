function y = overlapaddreal(B, x, N)
    M = length(B);          % length of filter response

    if N < M
        error('N is less than the length of filter response M.');
    end

    L = N - M + 1;          % x[n] segment length

    N_x = length(x);        % length of x[n]
    kmax = ceil(N_x/L);     % number of data blocks
    
    B = [B zeros(1, N-M)];
    H = fft(B);

    x = [x zeros(1, kmax*L - N_x)];
    % append zeros to make up (kmax * L) elements

    y = zeros(1, kmax*L);
    y_k_buffer = zeros(1, M-1);
    
    overlap_index = 1:M-1;

    for k = 1:kmax
        index_start = (k-1)*L + 1;
        index_end = k * L;

        x_k = [x(index_start:index_end) zeros(1, M-1)];
        % append M-1 zeros

        X_k = fft(x_k);
        
        Y_k(1:N/2+1) = X_k(1:N/2+1) .* H(1:N/2+1);
        Y_k(N/2+2:N) = conj(Y_k(N/2:-1:2));
        % Y_k = X_k .* H;
        
        y_k = ifft(Y_k);
        % y_k = filter(B, 1, x_k);

        y_k(overlap_index) = y_k(overlap_index) + y_k_buffer(overlap_index);
        % add overlapped M-1 points together

        y(index_start:index_end) = y_k(1:L);
        % output first L points to y
        
        y_k_buffer(overlap_index) = y_k(overlap_index+L);
        % store last M-1 points for next round
    end

    y = y(1:N_x);
    % keep the lengths of x and y equal
end
