
/* Accept N numbers (8bit = uint8 [0-255]) and sort them in ascending order */
 
#include <stdio.h>
#include <stdint.h>

int main() {
	int i, j, a, n;
  uint8_t number[30];
  printf("Enter size of array: ");
  scanf("%d", &n);
  printf("Enter numbers: \n");
  for (i=0; i<n; ++i) {
    scanf("%d", &number[i]);
  }

  for (i=0; i<n; ++i) {
    for (j=i+1; j<n; ++j) {
      if (number[i] > number[j]) {
        a = number[i];
        number[i] = number[j];
        number[j] = a;
      }
    }
  }

  printf("Sorted: \n");
  for (i = 0; i < n; ++i) {
    printf("%d ", number[i]);
  }
  
  printf("\n");
}