// Main Functions
#include "sort_simple_head.h"

void Sort(int numbers[MAX_NUMBERS], int arr_length)
{
    if(arr_length == 0){
        return;
    }
    int i, j, temp;
    for (i = 0; i < arr_length; ++i) {
        for (j = i + 1; j < arr_length; ++j) {
            if (numbers[i] > numbers[j]) {
                temp =  numbers[i];
                numbers[i] = numbers[j];
                numbers[j] = temp;
            }
        }
    }
}