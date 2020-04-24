/****************************************************************************
        Group 2: Biplav, Deivy, Leila, Victor

* @file    merge_sort_iterative.c 
*
* This file contains the implementation of the Napoleon Cipher.
*
* Usage:
*     0) Start Xilinx SDK. Connect Zybo to computer via USB.
*     1) Go to Xilinx > Program FPGA > Program
*     2) Open SDK Terminal
*     2.1) Press '+' > Select COM-port > Keep default values under 'Advanced Settings' > ok
*     3) Right-click on 'Napoleon_Cipher'-folder > Run as > 1 Launch on Hardware (system debugger)
*     4) Go to SDK Terminal > encode/decode your message
****************************************************************************/

#include "merge-sort.h"


void mergeSort(SortInt inputNums[MAX_NUMBERS], SortInt num)
{
    //printf("mergeSort %d %d \n",start,end); 
    int start = 0;
    int end = (int)num - 1;
    if(start == end)
        return;
    int mid = (end + start ) / 2;
    int loop=0;

    for(loop=1; loop <= end; loop*=2)
    {
       int inner_loop=0; 
       for(inner_loop=0; inner_loop < end; inner_loop += 2*loop)
       {
            int tmp_start = inner_loop;
            int tmp_mid = min(inner_loop + loop -1, end);
            int tmp_end = min(tmp_mid + loop, end);
            //printf("mergeSort %d %d %d\n",tmp_start,tmp_mid,tmp_end); 
            mergeJoin(inputNums,tmp_start,tmp_mid,tmp_end);
       }
    }
}

void mergeJoin(SortInt inputNums[MAX_NUMBERS], int start,int mid, int end)
{
    int tmp_index = 0;
    int tmp_max = (end - start);
    int tmp[MAX_NUMBERS] = {'\0'}; // this can be optimized, instead of MAX_NUMBERS, tmp_max can be used
    int mid_index = mid + 1;
    int start_index = start;
    if(start == end)
        return;
    while (tmp_index <= tmp_max )
    {
    if(start_index <= mid && mid_index <= end)
    {
        if(inputNums[start_index] < inputNums[mid_index])
        {
            tmp[tmp_index++] = inputNums[start_index++];  
        }
        else
        {
            tmp[tmp_index++] = inputNums[mid_index++];
        }
    }
    else
    {
        if(mid_index > end)
        {
            tmp[tmp_index++] = inputNums[start_index++];  
        }
        else
        {
            tmp[tmp_index++] = inputNums[mid_index++];
        }
    }
    }
    tmp_index = 0;
    for(start_index = start; start_index <= end; start_index++)
    {
        inputNums[start_index] = tmp[tmp_index++];
    //printf("merge join %d[%d] ",inputNums[start_index],start_index); 
    }

}

/***************************************************************************
* Main function to either decode or encode text
* @param    None
* @return    None
****************************************************************************/
/*
int main() {
    int numbers[MAX_NUMBERS] = {'\0'};
    int totalNum = 0;
    int loop=0;
    while (1) {
        char temp='\0';   // temp is to capture return (enter) keyboard entry
        while ( 1 )  
        {
        totalNum = 0;
            printf("\n****Merge Sort****\nEnter number of integer for sort (2-200), enter 0 for quit: "); 
            scanf("%d%c", &totalNum, &temp); 
            //scanf("%d", &totalNum); 
            if(totalNum == 0)
            {
                return 0;
            }

            if(totalNum > 200 || totalNum < 2)
            {
                printf("\n Invalid number \n"); 
                continue;
            }
            break;
        }
        for(loop = 0; loop < totalNum ; loop++)
        {
            printf("\nEnter %d%s number:",loop+1,
                        (loop+1)%10==1 ?"st": (loop+1)%10==2 ?"nd":(loop+1)%10==3?"rd":"th"); 
            scanf("%d%c", &numbers[loop], &temp); 
            //scanf("%d",&numbers[loop]); 
            //printf("%d ",numbers[loop]); 
        }
        printf("\nOriginal numbers are:  "); 
        for(loop = 0; loop < totalNum ; loop++)
        {
            printf("%d ",numbers[loop]); 
        }
        //return 0;
        mergeSort(numbers,0,totalNum-1);
        printf("\nSorted numbers are:  "); 
        for(loop = 0; loop < totalNum ; loop++)
        {
		fprintf(stderr,"%d ",numbers[loop]); 
	}
	fprintf(stderr,"\n"); 
    }
    return 0;
//    cleanup_platform();
}
*/

