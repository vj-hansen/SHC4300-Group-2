#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "merge-sort.h"

int main() {
    int numbers[MAX_NUMBERS] = {'\0'};
    int totalNum = 0;
    int loop=0;
    FILE* fp = fopen ("result.dat","w+");
    FILE* inputFile = fopen ("testCases.dat","r");
    while (!feof(inputFile)) {
        char temp='\0';
        totalNum = 0;
        fscanf(inputFile,"%d%c", &totalNum, &temp);
        if(totalNum == 0) {
            continue;
        }

        if(totalNum > 200 || totalNum < 2) {
            printf("\n Invalid number \n");
            continue;
        }
        for(loop = 0; loop < totalNum ; loop++) {
            fscanf(inputFile,"%d%c", &numbers[loop], &temp);
        }

        mergeSort(numbers,0,totalNum-1);
        for(loop = 0; loop < totalNum ; loop++) {
            fprintf(fp,"%d ",numbers[loop]); 
        }
        fprintf(fp,"\n"); 
    }
    fclose(fp);
    fclose(inputFile);
    if (system("diff -w result.dat outcomes.dat")) {
        fprintf(stdout, "*******************************************\n");
        fprintf(stdout, "FAIL: Output DOES NOT match the golden output\n");
        fprintf(stdout, "*******************************************\n");
        return 1;
    }
    else {
        fprintf(stdout, "*******************************************\n");
        fprintf(stdout, "PASS: Output Matches the golden output\n");
        fprintf(stdout, "*******************************************\n");
    }
    return 0;
}