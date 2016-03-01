#include <stdio.h>
#include <math.h>
#include "SPWS3.h"
#include "Params.h"

#define LENGTH 360
#define BLOCK_NUMBER (LENGTH/L + 1)
#define LENGTH_NEW (BLOCK_NUMBER*L)

// input data buffer
fract32 input_data[N] = { 0 };

// output data buffers
fract32 output_buffer0[N] = { 0 };
fract32 output_buffer1[N] = { 0 };
fract32* output_current  = output_buffer0;       // pointer to buffer for processing
fract32* output_playback = output_buffer1;       // pointer to buffer to be played out

float t_vector[LENGTH] = {0.0};
float output_time[LENGTH] = {0.0};
float output_block[LENGTH] = {0.0};

float input[] = { 0.000000, 0.311155, 0.604528, 0.863541, 1.073937, 
        1.224745, 1.309017, 1.324294, 1.272762, 1.161097, 
        1.000000, 0.803458, 0.587785, 0.370501, 0.169131, 
        0.000000, -0.122881, -0.188780, -0.190983, -0.127255, 
        0.000000, 0.183900, 0.413545, 0.674761, 0.951057, 
        1.224745, 1.478148, 1.694795, 1.860547, 1.964555, 
        2.000000, 1.964555, 1.860547, 1.694795, 1.478148, 
        1.224745, 0.951057, 0.674761, 0.413545, 0.183900, 
        -0.000000, -0.127255, -0.190983, -0.188780, -0.122881, 
        -0.000000, 0.169131, 0.370501, 0.587785, 0.803458, 
        1.000000, 1.161097, 1.272762, 1.324294, 1.309017, 
        1.224745, 1.073937, 0.863541, 0.604528, 0.311155, 
        0.000000, -0.311155, -0.604528, -0.863541, -1.073937, 
        -1.224745, -1.309017, -1.324294, -1.272762, -1.161097, 
        -1.000000, -0.803458, -0.587785, -0.370501, -0.169131, 
        0.000000, 0.122881, 0.188780, 0.190983, 0.127255, 
        -0.000000, -0.183900, -0.413545, -0.674761, -0.951057, 
        -1.224745, -1.478148, -1.694795, -1.860547, -1.964555, 
        -2.000000, -1.964555, -1.860547, -1.694795, -1.478148, 
        -1.224745, -0.951057, -0.674761, -0.413545, -0.183900, 
        -0.000000, 0.127255, 0.190983, 0.188780, 0.122881, 
        0.000000, -0.169131, -0.370501, -0.587785, -0.803458, 
        -1.000000, -1.161097, -1.272762, -1.324294, -1.309017, 
        -1.224745, -1.073937, -0.863541, -0.604528, -0.311155, 
        -0.000000, 0.311155, 0.604528, 0.863541, 1.073937, 
        1.224745, 1.309017, 1.324294, 1.272762, 1.161097, 
        1.000000, 0.803458, 0.587785, 0.370501, 0.169131, 
        0.000000, -0.122881, -0.188780, -0.190983, -0.127255, 
        0.000000, 0.183900, 0.413545, 0.674761, 0.951057, 
        1.224745, 1.478148, 1.694795, 1.860547, 1.964555, 
        2.000000, 1.964555, 1.860547, 1.694795, 1.478148, 
        1.224745, 0.951057, 0.674761, 0.413545, 0.183900, 
        -0.000000, -0.127255, -0.190983, -0.188780, -0.122881, 
        -0.000000, 0.169131, 0.370501, 0.587785, 0.803458, 
        1.000000, 1.161097, 1.272762, 1.324294, 1.309017, 
        1.224745, 1.073937, 0.863541, 0.604528, 0.311155, 
        0.000000, -0.311155, -0.604528, -0.863541, -1.073937, 
        -1.224745, -1.309017, -1.324294, -1.272762, -1.161097, 
        -1.000000, -0.803458, -0.587785, -0.370501, -0.169131, 
        -0.000000, 0.122881, 0.188780, 0.190983, 0.127255, 
        0.000000, -0.183900, -0.413545, -0.674761, -0.951057, 
        -1.224745, -1.478148, -1.694795, -1.860547, -1.964555, 
        -2.000000, -1.964555, -1.860547, -1.694795, -1.478148, 
        -1.224745, -0.951057, -0.674761, -0.413545, -0.183900, 
        -0.000000, 0.127255, 0.190983, 0.188780, 0.122881, 
        0.000000, -0.169131, -0.370501, -0.587785, -0.803458, 
        -1.000000, -1.161097, -1.272762, -1.324294, -1.309017, 
        -1.224745, -1.073937, -0.863541, -0.604528, -0.311155, 
        -0.000000, 0.311155, 0.604528, 0.863541, 1.073937, 
        1.224745, 1.309017, 1.324294, 1.272762, 1.161097, 
        1.000000, 0.803458, 0.587785, 0.370501, 0.169131, 
        0.000000, -0.122881, -0.188780, -0.190983, -0.127255, 
        -0.000000, 0.183900, 0.413545, 0.674761, 0.951057, 
        1.224745, 1.478148, 1.694795, 1.860547, 1.964555, 
        2.000000, 1.964555, 1.860547, 1.694795, 1.478148, 
        1.224745, 0.951057, 0.674761, 0.413545, 0.183900, 
        0.000000, -0.127255, -0.190983, -0.188780, -0.122881, 
        -0.000000, 0.169131, 0.370501, 0.587785, 0.803458, 
        1.000000, 1.161097, 1.272762, 1.324294, 1.309017, 
        1.224745, 1.073937, 0.863541, 0.604528, 0.311155, 
        -0.000000, -0.311155, -0.604528, -0.863541, -1.073937, 
        -1.224745, -1.309017, -1.324294, -1.272762, -1.161097, 
        -1.000000, -0.803458, -0.587785, -0.370501, -0.169131, 
        -0.000000, 0.122881, 0.188780, 0.190983, 0.127255, 
        -0.000000, -0.183900, -0.413545, -0.674761, -0.951057, 
        -1.224745, -1.478148, -1.694795, -1.860547, -1.964555, 
        -2.000000, -1.964555, -1.860547, -1.694795, -1.478148, 
        -1.224745, -0.951057, -0.674761, -0.413545, -0.183900, 
        -0.000000, 0.127255, 0.190983, 0.188780, 0.122881, 
        0.000000, -0.169131, -0.370501, -0.587785, -0.803458, 
        -1.000000, -1.161097, -1.272762, -1.324294, -1.309017, 
        -1.224745, -1.073937, -0.863541, -0.604528, -0.311155 };

int main(void) {
    int i;

    printf("L=%d\n", L);
    printf("%d blocks\n", BLOCK_NUMBER);
    printf("%d elements\n", LENGTH_NEW);

    for (i = 0; i < LENGTH; ++i) {
        t_vector[i] = i / 24E3;
    }
    printf("t_vector finished\n");

    // padding zeros
    float input_padding_with_zeros[LENGTH_NEW] = {0.0};
    for (i = 0; i < LENGTH; ++i) {
        input_padding_with_zeros[i] = input[i];
    }
    printf("padding zeros finished\n");

    // process_block
    init_process();
    float output_block_temp[LENGTH_NEW] = {0.0};
    for (int j = 0; j < BLOCK_NUMBER; j++) {
        fract32* temp;
        temp = output_playback;
        output_playback = output_current;
        output_current = temp;

        for (i = 0; i < L; i++) {
            input_data[i] = input_padding_with_zeros[i+j*L] * (1 << 30);
        }
        process_block(output_current);

        temp = output_playback;
        output_playback = output_current;
        output_current = temp;

        for (i = 0; i < L; i++) {
            output_block_temp[i+j*L] = output_playback[i];
        }
    }
    for (i = 0; i < LENGTH; i++) {
        output_block[i] = output_block_temp[i] / (1 << 29);
        // 30 - 1 = 29
        // Note: scaling to avoid overflows in fixed point.
        // See init_process() for more information.
    }
    printf("process_block finished\n");

    // process_time
    for (i = 0; i < LENGTH; ++i) {
        output_time[i] = process_time(input[i]);
    }
    printf("process_time finished\n");

    return 0;
}
