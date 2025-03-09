#include "header.h"

void choices(int *arr_choices, int n, int& compareCount, int& swapCount) {
    
    int tmp;
    int i_max;
    int innerSwapCount = 1;

    for (int j = n-1; j >= 0; --j) {
            innerSwapCount = 0;
            i_max = 0;
            for (int i = 1; i <= j; ++i) { 
                ++compareCount;
                if (arr_choices[i_max] < arr_choices[i]) {
                    i_max = i;
                }
            }
        if (arr_choices[j] != arr_choices[i_max]) {
            tmp = arr_choices[j];
            arr_choices[j] = arr_choices[i_max];
            arr_choices[i_max] = tmp;
            ++innerSwapCount;
        }
        swapCount = swapCount + innerSwapCount;
    }
    
    return;   
}