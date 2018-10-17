/****************************************************************************
                         testfft2.c

  Original author: James W. Beauchamp
  Date: August 19, 2016
  Description: Program to calculate FFT of complex wave

  Revised: 2/11/2018

 ***************************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "macro.h"
#define P printf

int fft2(float*, float*, int, float, int);

int main()
{
  int i, n, N, k, K, m, Nhop1;
  double twpi = 8.*atan(1.);
  float A;

  m = 2;
  N = pow(2.,(double)(m+1));
  Nhop1 = 100;
  P("m = %d, N = %d, Nhop1 = %d, \n\n", m, N, Nhop1);

  float sig[N], real[N], imag[N], mag[N];

/* compute signal */

  P("signal values: \n");
  A = 1.;
  i = 0;
  for(n=0; n<N; n++)
  {
    sig[n] = A*cos(twpi*n/N) + A/3.*cos(3.*twpi*n/N);
    if (n == 0){
      sig[n] = 1.0;
    }
    else{
      sig[n] = 0.0;
    }
    real[n] = sig[n];
    imag[n] = 0.;
    // if(n%Nhop1==0)
    // {
    //   P("sig[%d] = %.3f, ", n, sig[n]);
    //   if((i+1)%4==0) P("\n");
    //   i++;
    // }
  }
  P("before FTT, the signal is:\n");
  for(n=0; n<N; n++)
  {
    P("sig[%d] = %.3f, real[%d] = %.3f, imag[%d] = %.3f\n", n, sig[n], n, real[n], n, imag[n]);
  }
  P("\n\n");


/* compute FFT spectrum */
  P("N = %d, 2/N = %.3f\n", N, (float)2./N);
  fft2(real, imag, m, 2./N, 0);
  P("fft values: \n");
  for(k=0; k<N; k++)
  {
    P("real[%d] = %.6f, imag[%d] = %.6f, ", k, real[k], k, imag[k]);
    mag[k] = sqrt(sq(real[k]) + sq(imag[k]));
    P("mag[%d] = %.6f\n", k, mag[k]);
  }

} /* end main() */
