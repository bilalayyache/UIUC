/*
prog3 program
Written by Yichi Zhang, 10/05/2018
*/

#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <sys/fcntl.h>
#include "g_raph.h"
#include "sndhdr.h"
#include "macro.h"
#include "byteorder.h"
#include "wavhdr.h"
#define SND ".snd"
#define WAV ".wav"
#define P printf


int plotseg(float*, float*, int, char*, char*);
int fft2(float*, float*, int, float, int);
// set labels for horizontal and vertical axises
char* horizontal_label = "TIME (s)";
char* vertical_label = "Amplitude";
char* input_file;
float start_time, end_time;
char* title_graph;

int main(int argc, char **argv)
{
  int sr, nisamps, nosamps, nchans, samptype, sampsize, nbr;
  int fdi, byte_reverse, ibyte_reverse, obyte_reverse;
  int i, start_index, end_index;
  char *dotpos, *infile, *ifiletype;
  short int sampval;
  float duri;

  if(argc < 2)
  {
    P("Usage: %s <infile>\n", argv[0]);
    fflush(stdout);
    exit(0);
  }

/* open input sound file */
  infile = argv[1];
  input_file = argv[1];
  fdi = open(infile, O_RDONLY);

  if(fdi < 0)
  {
    fprintf(stderr,"error: can not read input file %s\n", infile);
    fflush(stdout);
    exit(1);
  }

/* determine if input file is a .snd or .wav file */
  if((dotpos = strrchr(infile, '.')) == NULL )
  {
    fprintf(stderr,"error: input file name lacks soundfile type suffix.\n");
    exit(1);
  }
  if(!strcmp(dotpos,SND))
  {
    /* read header of input file */
    readSndHdr(fdi,&sr,&nchans,&nisamps,&samptype);
    if(samptype == SND_FORMAT_LINEAR_16)
    {
      ifiletype = SND;
      duri = nisamps/(float)(sr*nchans);
      P("Input file header data: \n");
      P("   Type: %s, SR=%d, nchans=%d, nsamps=%d, dur=%.3f sec\n",
            ifiletype, sr, nchans, nisamps, duri);
/* SND data is big-endian, so if the host is not big-endian,
   byte-reverse the data. */
      ibyte_reverse = (byte_order() != big_endian);
    }
    else
    {
      fprintf(stderr,"error: sound data is not in 16-bit integer format.\n");
      exit(1);
    }
  }
  else if(!strcmp(dotpos,WAV))
  {
    /* read header of input file */
    readWavHdr(fdi,&sr,&nchans,&nisamps,&sampsize);
    if(sampsize == 16)
    {
      ifiletype = WAV;
      duri = nisamps/(float)(sr*nchans);
      P("Input file header data: \n");
      P("   Type: %s, SR=%d, nchans=%d, nsamps=%d, dur=%.3f sec\n",
            ifiletype, sr, nchans, nisamps, duri);
/* WAVE data is little-endian, so if the host is not little-endian,
   byte-reverse the data. */
      ibyte_reverse = (byte_order() != little_endian);
    }
    else
    {
      fprintf(stderr,"error: sound data is not in 16-bit integer format.\n");
      exit(1);
    }
  }
  else
  {
    fprintf(stderr,"error: input file name does not end in .snd or .wav\n");
    exit(1);
  }

  // begin analysis of the signal
  // first get the input signal
  // set up an array to store the input signal
  float input_signal[nisamps], plot_time[nisamps];
  int index;
  for(index = 0; index < nisamps; index++)
  {
    // first, we read the signal from the input
    read(fdi,&sampval,sizeof(short));
    // check if we need to do the byte swap
    if(ibyte_reverse==1){
      byteswap2(&sampval);
    }
    input_signal[index] = (float)sampval;
    // find the time index for this sample in order to plot
    plot_time[index] = (float)index / sr;
  }

  // float duration, frequency, sample_rate;
  char buffer[200];
  printf("Input wave plotting program.\n");
  printf("The input file has a duration of %f seconds.\n", duri);

  while(1)
  {
    printf("Give the time to plot (in seconds, within 0 to %.3f): ", duri);

    fgets(buffer, 100, stdin);
    sscanf(buffer, "%f%f%*s", &start_time, &end_time);
    if(start_time < 0){
      printf("Start time must be non-negative, set start time to 0\n");
      start_time = 0;
    }
    if(end_time > duri){
      printf("End time must be less or equal to the duration of the input, set end time to %.3f\n", duri);
      end_time = duri;
    }
    // find the time interval of the plot
    float user_duration = end_time - start_time;
    // from the start time and end time endtered by user, we need to find the index of the signal
    start_index = start_time * sr;
    end_index = end_time * sr;
    int num_sample = end_index - start_index;

    // now we will construct the tau array
    float tau[num_sample];
    for(index = 0; index < num_sample; index++){
      tau[index] = index/(float)sr;
    }
    float autocorrelation[num_sample];
    // now we use the loop to find the autocorrelation for each tau value
    for(index = 0; index < num_sample; index++){
      float sum = 0.0;
      int t;
      // printf("reach here\n");
      // for each tau value, we need to add up all x(t)*x(t+tau) for t range from t1 to t2-tau
      // in discrete domain, the index t here is range from start_index to end_index - tau *sr
      for(t = 0; t < num_sample-index; t++){
        sum += input_signal[start_index+t] * input_signal[start_index+t+index];
      }
      autocorrelation[index] = sum / num_sample;
    }
    // after we find out the autocorrelation, we need to normalize it to plot
    for(index = 1; index < num_sample; index++){
      autocorrelation[index] = autocorrelation[index] / autocorrelation[0];
    }
    autocorrelation[0] = 1.0;
    // we find the first local maxima here
    int local_maxima = 0;
    float maxima = 0.0;
    float local_maxima_time = 0.0;
    for(index = 1; index < num_sample-1; index++){
      if(autocorrelation[index] > autocorrelation[index-1]
          && autocorrelation[index] > autocorrelation[index+1]
            && autocorrelation[index] > maxima){
        local_maxima = index;
        maxima = autocorrelation[index];
      }
    }
    local_maxima_time = local_maxima / (float)sr;
    P("the autocorrelation has local maxima at time %f\n", local_maxima_time);
    // last, we plot the graph
    title_graph = "signal vs time";
    plotseg(plot_time+start_index, input_signal+start_index, num_sample, horizontal_label, vertical_label);
    title_graph = "Autocorrelation of input signal between user input time interval";
    plotseg(tau, autocorrelation, num_sample, "Tau", "Autocorrelation");
    P("Do you want to exit the program? (Y/N) ");
    fgets(buffer, 100, stdin);
    char flag;
    sscanf(buffer, "%c%*s", &flag);
    if(flag == 'Y' || flag == 'y'){
      return 0;
    }
  }
  return 0;
}

void plabel(xpos,ypos) double xpos, ypos;
{
    char temps[100];
    g_move_abs(xpos,ypos);
    sprintf(temps, "%s", title_graph);
    g_text(temps);
}
