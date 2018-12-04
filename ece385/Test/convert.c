#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define INPUT_FILE "FinalGameBackground.txt" // Input filename
#define OUTPUT_FILE "FGB_16.txt" // Name of file to output to

void hex_to_binary(char c, char *b);
void convert24_16(char* in, char* out);
void convert_hex_24(char* in, char* out);
void convert16_hex(char* in, char* out);
char binary_to_hex(char* in);

int main()
{
  FILE *input_file = fopen(INPUT_FILE, "r");
  FILE *output_file = fopen(OUTPUT_FILE, "w");
  if(!input_file){
    printf("Unable to open input file!");
    return -1;
  }
  char hex_in[10];
  char binary_out[30];
  char binary_16_out[30];
  char hex_out[10];
  // begin writing output file
  while(fscanf(input_file, "%s\n", hex_in) > 0){
      convert_hex_24(hex_in, binary_out);
      convert24_16(binary_out, binary_16_out);
      convert16_hex(binary_16_out, hex_out);
      fwrite(hex_out, sizeof(char), 4*sizeof(char), output_file);
  }

  fclose(input_file);
  fclose(output_file);

  return 0;
}

// input: 1-bit hex (from 0 to e)
// output: 4-bit binary
void hex_to_binary(char c, char* b)
{
  switch (c - '0'){
    case 0:
      strcpy(b, "0000"); break;
    case 1:
      strcpy(b, "0001"); break;
    case 2:
      strcpy(b, "0010"); break;
    case 3:
      strcpy(b, "0011"); break;
    case 4:
      strcpy(b, "0100"); break;
    case 5:
      strcpy(b, "0101"); break;
    case 6:
      strcpy(b, "0110"); break;
    case 7:
      strcpy(b, "0111"); break;
    case 8:
      strcpy(b, "1000"); break;
    case 9:
      strcpy(b, "1001"); break;
    case 49:
      strcpy(b, "1010"); break;
    case 50:
      strcpy(b, "1011"); break;
    case 51:
      strcpy(b, "1100"); break;
    case 52:
      strcpy(b, "1101"); break;
    case 53:
      strcpy(b, "1110"); break;
    case 54:
      strcpy(b, "1111"); break;
  }
}

// input: 4-bit binary
// output: 1-bit hex
char binary_to_hex(char* in)
{
  char out;
  int number = (in[0]-'0')*8 + (in[1]-'0')*4 + (in[2]-'0')*2 + (in[3]-'0')*1;
  switch(number){
    case 0: out = '0'; break;
    case 1: out = '1'; break;
    case 2: out = '2'; break;
    case 3: out = '3'; break;
    case 4: out = '4'; break;
    case 5: out = '5'; break;
    case 6: out = '6'; break;
    case 7: out = '7'; break;
    case 8: out = '8'; break;
    case 9: out = '9'; break;
    case 10: out = 'a'; break;
    case 11: out = 'b'; break;
    case 12: out = 'c'; break;
    case 13: out = 'd'; break;
    case 14: out = 'e'; break;
    case 15: out = 'f'; break;
  }
  return out;
}

// input : 6-bit Hex
// output : 24-bit binary
void convert_hex_24(char* in, char* out)
{
  int i = 0;
  char temp[10];
  hex_to_binary(in[i], temp);
  strcpy(out, temp);
  for (i = 1; i < 6; i++){
    hex_to_binary(in[i], temp);
    strncat(out, temp, 4);
  }
}

// input: 24-bit binary
// output: 16-bit binbary
void convert24_16(char *in, char* out)
{
  int i;
  for (i = 0; i <= 5; i++){
    out[i] = in[i];
  }
  for (i = 6; i <=10; i++){
    out[i] = in[i+2];
  }
  for (i = 11; i <=15; i++){
    out[i] = in[i+5];
  }
  out[16] = '\0';
}

// input: 16-bit binary
// output: 4-bit hex
void convert16_hex(char* in, char* out)
{
  char temp[10];
  char hex;
  int i, j;
  for (i = 0; i < 4; i++){
    for (j = 0; j < 4; j++){
      temp[j] = in[i*4+j];
    }
    hex = binary_to_hex(temp);
    out[i] = hex;
  }
  out[4] = '\0';
}
