// TODO: 0. Modify these constants to match the filter you have designed

// length of filter
#define M 47

// buffer size
#define N 512

// input data processing block size
#define L (N-M+1)

#define BUFFER_SIZE     (M-1)
#define REM(INDEX)      ((INDEX) + BUFFER_SIZE) % BUFFER_SIZE
// if an index is negative, a specified position from the end of the array will be returned.
// e.g. given an array x[8], x[REM(-1)] and x[REM(7)] both refer to x[7].
