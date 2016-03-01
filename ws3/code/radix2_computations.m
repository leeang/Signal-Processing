function n = radix2_computations(N, operation)
    if strcmp(operation, 'm')
        n = N/2 .* log2(N);
    elseif strcmp(operation, 'a')
        n = N .* log2(N);
    end
end
