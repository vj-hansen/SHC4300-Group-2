#include <stdint.h>
#define MAX_NUMBERS 200
#define min(x,y) x>y?y:x
#define SortInt uint8_t
void mergeSort(SortInt inputNums[MAX_NUMBERS], SortInt num);
void mergeJoin(SortInt inputNums[MAX_NUMBERS], int start,int mid, int end);

