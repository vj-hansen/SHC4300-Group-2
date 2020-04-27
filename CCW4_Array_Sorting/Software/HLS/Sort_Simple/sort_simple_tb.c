#include <stdlib.h>
#include <stdio.h>
#include "sort_simple_head.h"

// Test Bench
int main(){

    int numbers[MAX_NUMBERS] = {'\0'};
    int i;
    int arr_length = 0; 

    // Open files
    FILE *inputFile = fopen("unsorted.dat","r");
    FILE *outputFile = fopen("sorted_result.dat","w");
    
    if (!inputFile) {
        printf("Problem with opening unsorted.dat file\n");
        return 0;
    }
    
    // Print unsorted array
    printf("\nUnsorted numbers are: \n");  
    for (i=0; i<MAX_NUMBERS; i++) {
        if (fscanf(inputFile, "%d", &numbers[i]) != 1) {
            arr_length = i; // get lenght of the array
            break;
        }
        printf("%d ", numbers[i]);
    }

    // Call sorting and merging function
    Sort(numbers, arr_length);
    
    // Print and store sorted array into file
    printf("\r\nSorted numbers are: \n"); 
    for(i = 0; i < arr_length ; i++) {
        fprintf(outputFile, "%d \n", numbers[i]);
        printf("%d ",numbers[i]); 
    }

    // Close the files and exit the program
    fclose(inputFile);
    fclose(outputFile);
    printf("\n\n");
    
    // Only fow Vivado HLS to werify the correct behavior
    if (system("diff -w sorted_result.dat sorted_defined.dat")) {
        fprintf(stdout, "**** FAIL: Output DOES NOT Matches Predefined Output ****\n");
        return 1;
    }
    else{
        fprintf(stdout, "**** PASS: Output Matches Predefined Output ****\n");
    }
    
   
    return 0;
}
