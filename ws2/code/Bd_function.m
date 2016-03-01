function [num, den] = Bd_function(D, alpha)
    num1 = zeros(1, D(1)+1);
    num1(1) = -alpha(1);
    num1(D(1)+1) = 1;
    den1 = zeros(1, D(1)+1);
    den1(1) = 1;
    den1(D(1)+1) = -alpha(1);

    num2 = zeros(1, D(2)+1);
    num2(1) = -alpha(2);
    num2(D(2)+1) = 1;
    den2 = zeros(1, D(2)+1);
    den2(1) = 1;
    den2(D(2)+1) = -alpha(2);

    num3 = zeros(1, D(3)+1);
    num3(1) = -alpha(3);
    num3(D(3)+1) = 1;
    den3 = zeros(1, D(3)+1);
    den3(1) = 1;
    den3(D(3)+1) = -alpha(3);

    num = conv(num1, num2);
    num = conv(num, num3);
    den = conv(den1, den2);
    den = conv(den, den3);
end
