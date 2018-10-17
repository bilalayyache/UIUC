#include <stdio.h>

int
main ()
{
    int i;
    float sample;
    float average = 0;

    for (i = 1; 10 >= i; i = i + 1) {
        /* Read a sample. */
        printf ("Enter sample #%d: ", i);
        if (1 != scanf ("%f", &sample)) {
            printf ("Numeric samples only!\n");
            /* Quit indicating failure (anything non-zero, *
             * by convention).                             */
            return 3;
        }

        /* Process the next sample. */
        average = average + (sample / 10);
    }

    /* Print the results. */
    printf ("The average is %f.\n", average);

    /* Program has finished successfully, *
     * so return 0 by convention.         */
    return 0;
}
