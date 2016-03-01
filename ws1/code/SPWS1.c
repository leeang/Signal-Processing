#include <stdio.h>
#include <math.h>

#define N	256
#define PI	3.1415926

float a = 0.12;
float Omega_1 = 0.25 * PI;
float Omega_2 = 1.9 * PI;

float alpha_1st = 0.597991;
float alpha_2nd = 0.470126;

float t_12[N];
float t_48[N];
float t_ds[N/4];

float x_12Hz[N];
float x_2[N];
float x_48Hz[N];

float y_1st[N];
float y_2nd_intermediate[N];
float y_2nd[N];
float y_2_1st[N];
float y_2_2nd_intermediate[N];
float y_2_2nd[N];
float y_ds[N/4];

// print the values of an array in order to compare with the MATLAB variables.
int print_array(const float *array, int length) {
    for (int i = 0; i < length; i++) {
        printf("%f\t", *(array+i));
    }
    printf("\n");
    return 0;
}

int main(void) {
    int i;
    
    float T_1 = 1 / 1.2;
    float T_2 = 1 / 4.8;

    float t;
    for (i = 0; i < N; i++) {
        t = T_1 * i;
        x_12Hz[i] = exp(-a * t) * cos(Omega_1 * t) + 0.1 * sin(Omega_2 * t);
        // In this case, we do not think type casting is useful primarily because the arguments and returns value of exp(), sin(), cos() function are all double floating point.
        t_12[i] = t;

        t = T_2 * i;
        x_2[i] = 0.1 * sin(Omega_2 * t);
        x_48Hz[i] = exp(-a * t) * cos(Omega_1 * t) + x_2[i];
        t_48[i] = t;
    }
    // print_array(x_12Hz, N);
    // print_array(x_48Hz, N);
    printf("Signal Generated.\n");

    // y 1st order
    y_1st[0] = (1 - alpha_1st) / 2 * x_48Hz[0];
    for (i = 1; i < N; i++) {
        y_1st[i] = (1 - alpha_1st) / 2 * (x_48Hz[i] + x_48Hz[i-1]) + alpha_1st * y_1st[i-1];
    }
    // print_array(y_1st, N);

    // y 2nd order
    y_2nd_intermediate[0] = (1 - alpha_2nd) / 2 * x_48Hz[0];
    for (i = 1; i < N; i++) {
        y_2nd_intermediate[i] = (1 - alpha_2nd) / 2 * (x_48Hz[i] + x_48Hz[i-1]) + alpha_2nd * y_2nd_intermediate[i-1];
    }
    y_2nd[0] = (1 - alpha_2nd) / 2 * y_2nd_intermediate[0];
    for (i = 1; i < N; i++) {
        y_2nd[i] = (1 - alpha_2nd) / 2 * (y_2nd_intermediate[i] + y_2nd_intermediate[i-1]) + alpha_2nd * y_2nd[i-1];
    }
    // print_array(y_2nd, N);
    printf("e) done.\n");

    // y 1st order
    y_2_1st[0] = (1 - alpha_1st) / 2 * x_2[0];
    for (i = 1; i < N; i++) {
        y_2_1st[i] = (1 - alpha_1st) / 2 * (x_2[i] + x_2[i-1]) + alpha_1st * y_2_1st[i-1];
    }
    // print_array(y_2_1st, N);

    // y 2nd order
    y_2_2nd_intermediate[0] = (1 - alpha_2nd) / 2 * x_2[0];
    for (i = 1; i < N; i++) {
        y_2_2nd_intermediate[i] = (1 - alpha_2nd) / 2 * (x_2[i] + x_2[i-1]) + alpha_2nd * y_2_2nd_intermediate[i-1];
    }
    y_2_2nd[0] = (1 - alpha_2nd) / 2 * y_2_2nd_intermediate[0];
    for (i = 1; i < N; i++) {
        y_2_2nd[i] = (1 - alpha_2nd) / 2 * (y_2_2nd_intermediate[i] + y_2_2nd_intermediate[i-1]) + alpha_2nd * y_2_2nd[i-1];
    }
    // print_array(y_2_2nd, N);
    printf("f) done.\n");

    // down sample
    for (i = 0; i < N/4; i++) {
        y_ds[i] = y_2nd[i*4];
        t_ds[i] = t_48[i*4];
    }
    // print_array(y_ds, N/4);
    printf("g) done.\n");

    return 0;
}
