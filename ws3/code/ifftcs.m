function x = ifftcs(X)
    if ~isConjugateSymmetric(X)
        error('input is not conjugate symmetric');
    end

    N = length(X) / 2;
    
    if N ~= round(N)
        error('input is not a length-2N sequence');
    end

    index = 1:N;

    X0(index) = X(index) + X(index + N);
    W = exp(1j * pi / N) .^ (index-1);
    X1(index) = W .* (X(index) - X(index + N));

    Q = X0 + 1j * X1;

    q = ifft(Q);

    x(index*2-1) = 0.5 * real(q(index));
    x(index*2) = 0.5 * imag(q(index));
end
