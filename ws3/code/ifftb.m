function x = ifftb(X)
    tmp = fft(X);
    tmp = tmp / length(X);
    tmp = fliplr(tmp);              % flip array left to right
    x = circshift(tmp, 1, 2);       % shift by 1 in the 2nd dimension (right shift by 1)
end
