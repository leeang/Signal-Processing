function phi = find_phi(s2_tilde)
    F_s = 32.768E3;         % sampling frequency
    F_c = 12.288E3;         % carrier frequency

    N = length(s2_tilde);

    t = 1/F_s * (0:N-1)';
    omegat = 2 * pi * F_c * t;

    phi_vector = (0:0.01:1) * pi;

    tmp = zeros(1, length(phi_vector));

    for k = 1:length(phi_vector)
        v_c = cos(omegat + phi_vector(k));
        y = s2_tilde .* v_c;
        [~, Y] = single_side_FFT(y, F_s);
        tmp(k) = Y(75);     % spike at 96.99Hz
    end

    [~, index] = max(tmp);
    phi = phi_vector(index);
end
