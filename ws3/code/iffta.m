function x = iffta(X)
    X_conj = conj(X);
    x_conj = fft(X_conj);
    x = conj(x_conj);
    x = x / length(X);
end
