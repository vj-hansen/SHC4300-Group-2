#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "merge-sort.h"

int main() {
    SortInt numbers[MAX_NUMBERS] = {'\0'};
    SortInt totalNum = 0;
    SortInt loop=0;
    FILE* fp = fopen ("result.dat","w+");
    FILE* inputFile = fopen ("testCases.dat","r");
    while (!feof(inputFile)) {
        char temp='\0';   // temp is to capture return (enter) keyboard entry
        totalNum = 0;
        //printf("\n****Merge Sort****\nEnter number of integer for sort (2-200), enter 0 for quit: ");
        fscanf(inputFile,"%hhu%c", &totalNum, &temp);
        //scanf("%d", &totalNum);
        if(totalNum == 0)
        {
            continue;
        }

        //printf("\n number= %d\n",totalNum);
        if(totalNum > 200 || totalNum < 2)
        {
            printf("\n Invalid number \n");
            continue;
        }
        for(loop = 0; loop < totalNum ; loop++)
        {
            //printf("\nEnter %d%s number:",loop+1,
                        //(loop+1)%10==1 ?"st": (loop+1)%10==2 ?"nd":(loop+1)%10==3?"rd":"th");
            fscanf(inputFile,"%hhu%c", &numbers[loop], &temp);
            //scanf("%d",&numbers[loop]); 
            //printf("%d loop %d ",numbers[loop],loop); 
        }
        /*
        printf("\nOriginal numbers are:  "); 
        for(loop = 0; loop < totalNum ; loop++)
        {
            printf("%d ",numbers[loop]); 
        }
        //return 0;
        */
        mergeSort(numbers,totalNum);
        //printf("\nSorted numbers are:  ");
        for(loop = 0; loop < totalNum ; loop++)
        {
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
    else
    {
        fprintf(stdout, "*******************************************\n");
        fprintf(stdout, "PASS: Output Matches the golden output\n");
        fprintf(stdout, "*******************************************\n");
    }
    return 0;
}
