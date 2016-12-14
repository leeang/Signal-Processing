clear;
clc;

syms in1 in2;
syms out;

syms P11 P12 P21 P22;
syms lambda;

P = [P11, P12; P21, P22];
phi = [in1; in2];

den = (lambda + transpose(phi) * P * phi)

syms den_sym;
num = P * phi * transpose(phi) * P
P = (P - num/den_sym) / lambda

syms gain0 gain1;
syms err;

P_sym = [P11, P12; P21, P22];
gain = [gain0; gain1];
gain = gain + P_sym * phi * err
