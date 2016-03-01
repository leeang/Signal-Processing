function bool = isConjugateSymmetric(X)
    N = length(X);
    X = X(2:N);     % discard the first element
    
    RePart = real(X);
    RePartReverse = fliplr(RePart);

    ImPart = imag(X);
    ImPartReverse = fliplr(ImPart);

    tolerance = eps('single');
    
    bool1 = any(abs(RePart-RePartReverse) > tolerance);
    bool2 = any(abs(ImPart+ImPartReverse) > tolerance);

    bool = ~(bool1 || bool2);
end
