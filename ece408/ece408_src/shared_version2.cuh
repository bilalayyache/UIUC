
#ifndef MXNET_OPERATOR_NEW_FORWARD_CUH_
#define MXNET_OPERATOR_NEW_FORWARD_CUH_
#define TILE_WIDTH 16
// #define X_TILE_WIDTH TILE_WIDTH + K -1
#include <mxnet/base.h>

namespace mxnet
{
namespace op
{

__constant__ float k_const[7200];

__global__ void forward_kernel(float *y, const float *x, const int B, const int M, const int C, const int H, const int W, const int K)
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
    const int X_TILE_WIDTH = TILE_WIDTH + K -1;

// An example use of these macros:
// float a = y4d(0,0,0,0)
// y4d(0,0,0,0) = a
#define y4d(i3, i2, i1, i0) y[(i3) * (M * H_out * W_out) + (i2) * (H_out * W_out) + (i1) * (W_out) + i0]
#define x4d(i3, i2, i1, i0) x[(i3) * (C * H * W) + (i2) * (H * W) + (i1) * (W) + i0]
#define k4d(i3, i2, i1, i0) k[(i3) * (C * K * K) + (i2) * (K * K) + (i1) * (K) + i0]
#define x_shared2d(i1, i0) x_shared[(i1) * (X_TILE_WIDTH) + (i0)]
#define k_const4d(i3, i2, i1, i0) k_const[(i3) * (C*K*K) + (i2) * (K*K) + (i1) * (K) + (i0)]

    int b = blockIdx.x;
    int m = blockIdx.y;
    int h_start = blockIdx.z / w_grid * TILE_WIDTH;
    int w_start = blockIdx.z % w_grid * TILE_WIDTH;
    int ty = threadIdx.y;
    int tx = threadIdx.x;
    int h = h_start + ty;
    int w = w_start + tx;

    // float acc = 0.;
    // if (b < B && m < M && h < H_out && w < W_out){
    //     for (int c = 0; c < C; c++){
    //         for (int p = 0; p < K; p++){
    //             for (int q = 0; q < K; q++){
    //                 float cur_x = x4d(b, c, h+p, w+q);
    //                 // float cur_k = k4d(m, c, p, q);
    //                 float cur_k = k_const4d(m, c, p, q);
    //                 acc += cur_x * cur_k;
    //             }
    //         }
    //     }
    //     y4d(b, m, h, w) = acc;
    // }

    // __shared__ float x_shared[X_TILE_WIDTH][X_TILE_WIDTH]
    extern __shared__ float shmem[];
    float* x_shared = &shmem[0];
    float acc = 0.0;
    if (h < H && w < W){
        for (int c = 0; c < C; ++c){
            x_shared2d(ty, tx) = x4d(b, c, h, w);
            __syncthreads();
            for (int p = 0; p < K; ++p){
                for (int q = 0; q < K; ++q){
                    if (ty+p < TILE_WIDTH && tx+q < TILE_WIDTH) acc += x_shared2d(ty+p, tx+q) * k_const4d(m, c, p, q);
                    else acc += x4d(b, c, h+p, w+q) * k_const4d(m, c, p, q);
                }
            }
            __syncthreads();
        }
    }
    if (h < H_out && w < W_out) y4d(b, m, h, w) = acc;


    // if (b < B && m < M){
    //     for (int c = 0; c < C; ++c){
    //         if (h < H && w < W) x_shared2d(ty, tx) = x4d(b, c, h, w);
    //         else x_shared2d(ty, tx) = 0;
    //         __syncthreads();
    //         if (tx < TILE_WIDTH && ty < TILE_WIDTH){
    //             for (int p = 0; p < K; ++p){
    //                 for (int q = 0; q < K; ++q){
    //                     acc += x_shared2d(ty+p, tx+q) * k_const4d(m, c, p, q);
    //                 }
    //             }
    //         }
    //         __syncthreads();
    //     }
    //     if (h < H_out && w < W_out)
    //         y4d(b, m, h, w) = acc;
    // }



#undef y4d
#undef x4d
#undef k4d
#undef x_shared2d
#undef k_const4d
}
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
    const int Z = w_grid * h_grid;
    const int X_TILE_WIDTH = TILE_WIDTH + K -1;

    // Set the kernel dimensions
    dim3 gridDim(B, M, Z);
    // dim3 blockDim(TILE_WIDTH, TILE_WIDTH, 1);
    dim3 blockDim(TILE_WIDTH, TILE_WIDTH, 1);
    // setup constant memory
    int const_size = M*C*K*K*sizeof(float);
    cudaMemcpyToSymbol(k_const, w.dptr_, const_size);
    size_t shmem_size = sizeof(float)*(X_TILE_WIDTH*X_TILE_WIDTH);
    // Call the kernel
    forward_kernel<<<gridDim, blockDim, shmem_size>>>(y.dptr_,x.dptr_, B,M,C,H,W,K);
    // forward_kernel<<<gridDim, blockDim>>>(y.dptr_,x.dptr_,w.dptr_, B,M,C,H,W,K);
    // forward_kernel<<<gridDim, blockDim>>>(y.dptr_,x.dptr_, B,M,C,H,W,K);
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