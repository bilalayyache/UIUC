#include <stdio.h>

int main ()
{
    int i;
    int sample;
    int A;
    int B;

    /* Read the first sample. */
    printf ("Enter the first sample: ");
    /* The expression "scanf (...)" returns the number of      *
     * values converted.  If the human user types a number     *
     * (as expected), the expression's value is 1.  Otherwise, *
     * the human did something wrong, so we end the program.   */
    if (1 != scanf ("%d", &sample)) {
        printf ("Numeric samples only!\n");
        /* Quit indicating failure (anything non-zero, *
         * by convention).                             */
        return 3;
    }


    /* Process the first sample. */
    A = sample;
    B = sample;


    for (i = 2; 10 >= i; i = i + 1) {
        /* Read another sample. */
        printf ("Enter sample #%d: ", i);
        if (1 != scanf ("%d", &sample)) {
            printf ("Numeric samples only!\n");
            /* Quit indicating failure (anything non-zero, *
             * by convention).                             */
            return 3;
        }


        /* Process the next sample. */
        if (A < sample) {
            A = sample;
        }
        if (B > sample) {
            B = sample;
        }
    }


    /* Print the results. */
    printf ("The A value is %d.\n", A);
    printf ("The B value is %d.\n", B);


    /* Program has finished successfully, *
     * so return 0 by convention.         */
    return 0;
}
