
#ifndef MXNET_OPERATOR_NEW_FORWARD_CUH_
#define MXNET_OPERATOR_NEW_FORWARD_CUH_
#define TILE_WIDTH 16
#include <mxnet/base.h>
#include <stdio.h>

namespace mxnet
{
namespace op
{

__constant__ float k_const[7200];

__global__ void forward_kernel(float *y, const float *x, const float *k, const int B, const int M, const int C, const int H, const int W, const int K)
{

    /*
    Modify this function to implement the forward pass described in Chapter 16.
    We have added an additional dimension to the tensors to support an entire mini-batch
    The goal here is to be correct AND fast.
    We have some nice #defs for you below to simplify indexing. Feel free to use them, or create your own.
    */

    const int H_out = H - K + 1;
    const int W_out = W - K + 1;
    const int w_grid = ceil((W_out * 1.0) /TILE_WIDTH);
    const int X_TILE_WIDTH = TILE_WIDTH + K - 1;
    // set the shared memory for this tile and filter
    extern __shared__ float shmem[];
    float* x_shared = &shmem[0];
    float* k_shared = &shmem[X_TILE_WIDTH * X_TILE_WIDTH];

// An example use of these macros:
// float a = y4d(0,0,0,0)
// y4d(0,0,0,0) = a
#define y4d(i3, i2, i1, i0) y[(i3) * (M * H_out * W_out) + (i2) * (H_out * W_out) + (i1) * (W_out) + (i0)]
#define x4d(i3, i2, i1, i0) x[(i3) * (C * H * W) + (i2) * (H * W) + (i1) * (W) + (i0)]
#define k4d(i3, i2, i1, i0) k[(i3) * (C * K * K) + (i2) * (K * K) + (i1) * (K) + (i0)]
#define x_shared2d(i1, i0) x_shared[(i1) * (X_TILE_WIDTH) + (i0)]
// #define x_shared2d(i1, i0) shmem[(i1) * (X_TILE_WIDTH) + (i0)]
#define k_shared2d(i1, i0) k_shared[(i1) * (K) + (i0)]
// #define k_shared2d(i1, i0) shmem[(X_TILE_WIDTH) * (X_TILE_WIDTH) + (i1) * (K) + i0]
#define k_const4d(i3, i2, i1, i0) k_const[(i3) * (C * K * K) + (i2) * (K * K) + (i1) * (K) + (i0)]

    int b = blockIdx.x;
    int m = blockIdx.y;
    int h_start = (blockIdx.z / w_grid) * TILE_WIDTH;
    int w_start = (blockIdx.z % w_grid) * TILE_WIDTH;
    int tx = threadIdx.x;
    int ty = threadIdx.y;
    int h = h_start + ty;
    int w = w_start + tx;

    // // method 1: use shared memory for both x and k
    // float acc = 0.;
    // // if (b < B && m < M && h < H_out && w < W_out){
    // if (b < B && m < M){
    //     for (int c = 0; c < C; c++){
    //         // first, for each input channel, we need load the shared memory
    //         if (tx < K && ty < K) k_shared2d(ty, tx) = k4d(m, c, ty, tx);
    //         __syncthreads();
    //         // since the block size is less than the shared memory size, we need loops to load the shared memory
    //         // for (int i = h; i < h_start+X_TILE_WIDTH; i += TILE_WIDTH){
    //         //     for (int j = w; j < w_start+X_TILE_WIDTH; j += TILE_WIDTH){
    //         //         if (i < H && j < W)
    //         //             x_shared2d(i-h_start, j-w_start) = x4d(b, c, i, j);
    //         //         else
    //         //             x_shared2d(i-h_start, j-w_start) = 0; 
    //         //     }
    //         // }
    //         // if block size is the same as shared memory size
    //         if (h < H && w < W)
    //             x_shared2d(ty, tx) = x4d(b, c, h, w);
    //         else
    //             x_shared2d(ty, tx) = 0;
    //         __syncthreads();
    //         // now begin calculation
    //         if (tx < TILE_WIDTH && ty < TILE_WIDTH){
    //             for (int p = 0; p < K; p++){
    //                 for (int q = 0; q < K; q++){
    //                     acc += x_shared2d(ty + p, tx + q) * k_shared2d(p, q);
    //                     // acc += x_shared2d(ty + p, tx + q) * k4d(m, c, p, q);
    //                 }
    //             }
    //         }
    //         __syncthreads();
    //     }
    //     if (h < H_out && w < W_out)
    //         y4d(b, m, h, w) = acc;
    // }

    // // method 2: use shared memory for x and constant memory for k
    // float acc = 0.;
    // if (b < B && m < M){
    //     for (int c = 0; c < C; c++){
    //         // if block size is the same as shared memory size
    //         if (h < H && w < W)
    //             x_shared2d(ty, tx) = x4d(b, c, h, w);
    //         else
    //             x_shared2d(ty, tx) = 0;
    //         __syncthreads();
    //         // now begin calculation
    //         if (tx < TILE_WIDTH && ty < TILE_WIDTH){
    //             for (int p = 0; p < K; p++){
    //                 for (int q = 0; q < K; q++){
    //                     acc += x_shared2d(ty + p, tx + q) * k_const4d(m, c, p, q);
    //                 }
    //             }
    //         }
    //         __syncthreads();
    //     }
    //     if (h < H_out && w < W_out)
    //         y4d(b, m, h, w) = acc;
    // }


    float acc = 0.;
    if (b < B && m < M && h < H_out && w < W_out){
        for (int c = 0; c < C; c++){
            for (int p = 0; p < K; p++){
                for (int q = 0; q < K; q++){
                    float cur_x = x4d(b, c, h+p, w+q);
                    float cur_k = k4d(m, c, p, q);
                    acc += cur_x * cur_k;
                }
            }
        }
        y4d(b, m, h, w) = acc;
    }


#undef y4d
#undef x4d
#undef k4d
#undef x_shared2d
#undef k_shared2d
#undef k_const4d
}

// __global__ void forward_kernel2(const float *mid, float *y, const int M)
// {
//     // in this kernel, we should sum the second dimension for the mid array and store the result to y

// }


/*
   This function is called by new-inl.h
   Any code you write should be executed by this function.
   For ECE408, we only expect the float version of the operator to be called, so here we specialize with only floats.
*/
template <>
void forward<gpu, float>(mshadow::Tensor<gpu, 4, float> &y, const mshadow::Tensor<gpu, 4, float> &x, const mshadow::Tensor<gpu, 4, float> &w)
{

    // Use mxnet's CHECK_EQ to do assertions.
    // Remove this assertion when you do your implementation!
    // CHECK_EQ(0, 1) << "Remove this line and replace with your implementation";

    // Extract the tensor dimensions into B,M,C,H,W,K
    // ...
    const int B = x.shape_[0];
    const int M = y.shape_[1];
    const int C = x.shape_[1];
    const int H = x.shape_[2];
    const int W = x.shape_[3];
    const int K = w.shape_[3];

    const int H_out = H - K + 1;
    const int W_out = W - K + 1;
    const int w_grid = ceil((W_out * 1.0) /TILE_WIDTH);
    const int h_grid = ceil((H_out * 1.0) /TILE_WIDTH);
    const int X_TILE_WIDTH = TILE_WIDTH + K - 1;
    const int Z = w_grid * h_grid;

    // // set a intermidiate variable to store the partial convolution result
    // mshadow::Tensor<gpu, 5> mid(mshadow::Shape5(B, C, M, H-K, W-K));
    // // tasks:
    // // for the first forward kernel, we should calculate the partial result.
    // // for example, if the input x has size BxCxHxW and filter is MxCxKxK
    // // the result for the first kernel should be a 5D Tensor with size BxCxMx(H-K+1)x(W-K+1)
    // // second kernel will do the summation over the second dimension of the 5D Tensor and get the final answer

    // Set the kernel dimensions
    dim3 gridDim(B, M, Z);
    dim3 blockDim(X_TILE_WIDTH, X_TILE_WIDTH, 1);

    // copy constant memory
    int sizeKernel = M * C * K * K * sizeof(float);
    cudaMemcpyToSymbol(k_const, w.dptr_, sizeKernel);

    // Call the kernel
    size_t shmem_size = sizeof(float) * (X_TILE_WIDTH*X_TILE_WIDTH + K*K);
    // float *shmem = (float *)malloc(shmem_size);
    forward_kernel<<<gridDim, blockDim, shmem_size>>>(y.dptr_,x.dptr_,w.dptr_, B,M,C,H,W,K);
    // free(shmem);
    //forward_kernel<<<gridDim, blockDim, 0, s>>>(y.dptr_,x.dptr_,w.dptr_, B,M,C,H,W,K);
    //s is cudaStream_t

    // Use MSHADOW_CUDA_CALL to check for CUDA runtime errors.
    MSHADOW_CUDA_CALL(cudaDeviceSynchronize());

}

/*
    This tells mxnet how to do an op when it's not a float.
    This is not used in the ECE408 project
*/
template <typename gpu, typename DType>
void forward(mshadow::Tensor<gpu, 4, DType> &y, const mshadow::Tensor<gpu, 4, DType> &x, const mshadow::Tensor<gpu, 4, DType> &w)
{
    CHECK_EQ(0,1) << "Remove this line and replace it with your implementation.";
}
}
}

#endif


// #ifndef MXNET_OPERATOR_NEW_FORWARD_CUH_
// #define MXNET_OPERATOR_NEW_FORWARD_CUH_
// #define TILE_WIDTH 16
// #include <mxnet/base.h>

// namespace mxnet
// {
// namespace op
// {

// __global__ void forward_kernel(float *y, const float *x, const float *k, const int B, const int M, const int C, const int H, const int W, const int K)
// {

//     /*
//     Modify this function to implement the forward pass described in Chapter 16.
//     We have added an additional dimension to the tensors to support an entire mini-batch
//     The goal here is to be correct AND fast.
//     We have some nice #defs for you below to simplify indexing. Feel free to use them, or create your own.
//     */

//     const int H_out = H - K + 1;
//     const int W_out = W - K + 1;
//     const int w_grid = ceil((W_out * 1.0) /TILE_WIDTH);
//     //(void)H_out; // silence declared but never referenced warning. remove this line when you start working
//     //(void)W_out; // silence declared but never referenced warning. remove this line when you start working

// // An example use of these macros:
// // float a = y4d(0,0,0,0)
// // y4d(0,0,0,0) = a
// #define y4d(i3, i2, i1, i0) y[(i3) * (M * H_out * W_out) + (i2) * (H_out * W_out) + (i1) * (W_out) + i0]
// #define x4d(i3, i2, i1, i0) x[(i3) * (C * H * W) + (i2) * (H * W) + (i1) * (W) + i0]
// #define k4d(i3, i2, i1, i0) k[(i3) * (C * K * K) + (i2) * (K * K) + (i1) * (K) + i0]

//     int b = blockIdx.x;
//     int m = blockIdx.y;
//     int h_start = blockIdx.z / w_grid * TILE_WIDTH;
//     int w_start = blockIdx.z % w_grid * TILE_WIDTH;
//     int tx = threadIdx.x;
//     int ty = threadIdx.y;
//     int h = h_start + ty;
//     int w = w_start + tx;

//     float acc = 0.;
//     if (b < B && m < M && h < H_out && w < W_out){
//         for (int c = 0; c < C; c++){
//             for (int p = 0; p < K; p++){
//                 for (int q = 0; q < K; q++){
//                     float cur_x = x4d(b, c, h+p, w+q);
//                     float cur_k = k4d(m, c, p, q);
//                     acc += cur_x * cur_k;
//                 }
//             }
//         }
//         y4d(b, m, h, w) = acc;
//     }


// #undef y4d
// #undef x4d
// #undef k4d
// }

// /* 
//    This function is called by new-inl.h
//    Any code you write should be executed by this function.
//    For ECE408, we only expect the float version of the operator to be called, so here we specialize with only floats.
// */
// template <>
// void forward<gpu, float>(mshadow::Tensor<gpu, 4, float> &y, const mshadow::Tensor<gpu, 4, float> &x, const mshadow::Tensor<gpu, 4, float> &w)
// {

//     // Use mxnet's CHECK_EQ to do assertions.
//     // Remove this assertion when you do your implementation!
//     // CHECK_EQ(0, 1) << "Remove this line and replace with your implementation";

//     // Extract the tensor dimensions into B,M,C,H,W,K
//     // ...
//     const int B = x.shape_[0];
//     const int M = y.shape_[1];
//     const int C = x.shape_[1];
//     const int H = x.shape_[2];
//     const int W = x.shape_[3];
//     const int K = w.shape_[3];

//     const int H_out = H - K + 1;
//     const int W_out = W - K + 1;
//     const int w_grid = ceil((W_out * 1.0) /TILE_WIDTH);
//     const int h_grid = ceil((H_out * 1.0) /TILE_WIDTH);
//     const int Z = w_grid * h_grid;

//     // Set the kernel dimensions
//     dim3 gridDim(B, M, Z);
//     dim3 blockDim(TILE_WIDTH, TILE_WIDTH, 1);

//     // Call the kernel
//     forward_kernel<<<gridDim, blockDim>>>(y.dptr_,x.dptr_,w.dptr_, B,M,C,H,W,K);
//     //forward_kernel<<<gridDim, blockDim, 0, s>>>(y.dptr_,x.dptr_,w.dptr_, B,M,C,H,W,K);
//     //s is cudaStream_t

//     // Use MSHADOW_CUDA_CALL to check for CUDA runtime errors.
//     MSHADOW_CUDA_CALL(cudaDeviceSynchronize());

// }

// /* 
//     This tells mxnet how to do an op when it's not a float.
//     This is not used in the ECE408 project
// */
// template <typename gpu, typename DType>
// void forward(mshadow::Tensor<gpu, 4, DType> &y, const mshadow::Tensor<gpu, 4, DType> &x, const mshadow::Tensor<gpu, 4, DType> &w)
// {
//     CHECK_EQ(0,1) << "Remove this line and replace it with your implementation.";
// }
// }
// }

// #endif