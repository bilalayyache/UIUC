
#ifndef MXNET_OPERATOR_NEW_FORWARD_H_
#define MXNET_OPERATOR_NEW_FORWARD_H_

#include <mxnet/base.h>

namespace mxnet
{
namespace op
{


template <typename cpu, typename DType>
void forward(mshadow::Tensor<cpu, 4, DType> &y, const mshadow::Tensor<cpu, 4, DType> &x, const mshadow::Tensor<cpu, 4, DType> &k)
{
    /*
    Modify this function to implement the forward pass described in Chapter 16.
    The code in 16 is for a single image.
    We have added an additional dimension to the tensors to support an entire mini-batch
    The goal here is to be correct, not fast (this is the CPU implementation.)
    */

    // find the batch size
    const int B = x.shape_[0];
    // input channel number
    const int C = x.shape_[1];
    // output channel
    const int M = y.shape_[1];
    // input size
    const int H = x.shape_[2];
    const int W = x.shape_[3];
    // mask size
    const int K = k.shape_[3];
    // find the output size
    int H_O = H - K + 1;
    int W_O = W - K + 1;

    // find the result for each batch of input data
    for (int b = 0; b < B; ++b) {
      // for each batch of input (3D input x with size [C, H, W])
      // first loop over each output channel
      for (int m = 0; m < M; ++m){
        // find the value for every points in output image
        for (int h = 0; h < H_O; ++h){
          for (int w = 0; w < W_O; ++w){
            // initialize output value
            y[b][m][h][w] = 0;
            // find the value using input data and mask
            for (int c = 0; c < C; ++c){
              // find convolution by adding number within the mask (filter)
              for(int p = 0; p < K; ++p){
                for (int q = 0; q < K; ++q){
                  y[b][m][h][w] += x[b][c][h + p][w + q] * k[m][c][p][q];
                }
              }
            }
          }
        }
      }
    }

}
}
}

#endif
