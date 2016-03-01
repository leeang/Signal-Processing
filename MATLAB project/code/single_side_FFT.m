function [frequency_range, X] = single_side_FFT(x, F_s)
	N = length(x);
	X = fft(x);
	X = abs(X);

	X = X(1:ceil(N/2));
	frequency_range = (0:ceil(N/2)-1) / N * F_s;
end
