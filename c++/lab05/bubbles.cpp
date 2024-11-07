#include "header.h"

void bubbles(int *arr_bubbles, int n, int& compareCount, int& swapCount) {

    int tmp;
    int innerSwapCount = 1;

    while (innerSwapCount > 0) {
    innerSwapCount = 0;
    for (int i = 0; i < n-1; ++i) { 
        ++compareCount;
        if (arr_bubbles[i] > arr_bubbles[i+1]) {
            tmp = arr_bubbles[i+1];
            arr_bubbles[i+1] = arr_bubbles[i];
            arr_bubbles[i] = tmp;
            ++innerSwapCount;
        }
    }
    swapCount = swapCount + innerSwapCount;
    }
    
    return;   
}