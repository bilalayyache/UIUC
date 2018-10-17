#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include "g_raph.h"
#define PI 3.14159265

int plotseg(float*, float*, int, char*, char*);
// use a global variable for plabel
float start_time, end_time;
// set labels for horizontal and vertical axises
char* horizontal_label = "TIME (s)";
char* vertical_label = "SINE WAVE";

int main()
{
    // first, we can set a buffer to store the input string and then transfer
    // the buffer string to the float/int number we want
    char* buffer[100];
    float duration, frequency, sample_rate;
    printf("Sine wave plotting program.\n");
    printf("Give entire sine wave duration (in second): ");
    // first, we need to get the duration of the sine wave
    fgets(buffer, 100, stdin);
    sscanf(buffer, "%f%*s", &duration);
    printf("Give sine wave frequency (in Hz): ");
    // then we need to get the frequency of the sine wave
    fgets(buffer, 100, stdin);
    sscanf(buffer, "%f%*s", &frequency);
    float period = 1 / frequency;
    // print the period of the sine wave
    printf("The corresponding period of sine wave is (in second): %f\n", period);
    printf("Give sample rate (in Hz): ");
    // get the sample rate from user
    fgets(buffer, 100, stdin);
    sscanf(buffer, "%f%*s", &sample_rate);

    // by the parameters, we can sample the sine wave and store the value in a array
    int total_sample = duration * sample_rate;
    float samples[total_sample], plot_time[total_sample];
    int index;
    for (index = 0; index < total_sample; index++){
        float current_time = index / sample_rate;
        plot_time[index] = current_time;
        samples[index] = sin(2*PI*current_time/period);
    }

    // from this point, we need the loop to let user change parameters
    while(1){
        printf("Give time range for the plot (t1 t2): ");
        // get time range
        fgets(buffer, 100, stdin);
        sscanf(buffer, "%f%f%*s", &start_time, &end_time);
        // first check whether start time and end time are reasonable
        if (start_time > end_time){
            printf("Input range is not reasonable (t1 must less than t2)\n");
            continue;
        }
        if (start_time < 0){
            printf("start_time must greater than 0\n");
            continue;
        }
        if (end_time - start_time > duration){
            printf("range of the plot is larger than the duration of sine wave\n");
            continue;
        }
        // after gathering all the information, we can use function plotseg to plot
        // for the plot, we need the horizontal data and vertical data
        int start_index = start_time * sample_rate;
        int end_index = end_time * sample_rate;
        int num_sample = end_index - start_index;
        // last, we plot the graph
        plotseg(plot_time+start_index, samples+start_index, num_sample, horizontal_label, vertical_label);
    }
    return 0;
}

void plabel(xpos,ypos) double xpos, ypos;
{
    char temps[100];
    g_move_abs(xpos,ypos);
    sprintf(temps, "Plot with start time %f, end time %f", start_time, end_time);
    g_text(temps);
}
