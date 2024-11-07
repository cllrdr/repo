#include "header.h"

void printDynamicArray(int n, const int *arr) {
    for (int i = 0; i < n; i++) {
            printf("%d ", *(arr + i)); // разыменование указателя
    }
}

int main() {

    int n = 5;
    int compareCount, swapCount;
    int *arr, *arr_bubbles, *arr_choices;
    arr = new int[n];
    arr_bubbles = new int[n];
    arr_choices = new int[n];

    // цикл инициализации массива
    for (int i = 0; i < n; i++) {
        arr[i] = rnd(1, 9);
    }

    printf("Размер массива: %d\n", n);
    printf("Заданный массив: ");
    printDynamicArray(n, arr);
    printf("\n");
    printf("\n");

    for (int i = 0; i < n; i++) {
    arr_bubbles[i] = arr[i];
    arr_choices[i] = arr[i];
    }

    bubbles(arr_bubbles, n, compareCount = 0, swapCount = 0);
    printf("Пузырьки по возрастанию \n");
    printf("Кол-во сравнений: %d\n", compareCount);
    printf("Кол-во перестановок: %d\n", swapCount);
    printf("Сортированный массив: ");
    printDynamicArray(n, arr_bubbles);
    printf("\n");
    choices(arr_choices, n, compareCount = 0, swapCount = 0);
    printf("Сравнения по возрастанию\n");
    printf("Кол-во сравнений: %d\n", compareCount);
    printf("Кол-во перестановок: %d\n", swapCount);
    printf("Сортированный массив: ");
    printDynamicArray(n, arr_choices);
    printf("\n\n");

    for (int i = 0; i < n; i++) {
    arr_bubbles[i] = -1 * arr_bubbles[i];
    arr_choices[i] = -1 * arr_choices[i];
    }

    bubbles(arr_bubbles, n, compareCount = 0, swapCount = 0);
    for (int i = 0; i < n; i++) {arr_bubbles[i] = -1 * arr_bubbles[i];}
    printf("Пузырьки по убыванию\n");
    printf("Кол-во сравнений: %d\n", compareCount);
    printf("Кол-во перестановок: %d\n", swapCount);
    printf("Сортированный массив: ");
    printDynamicArray(n, arr_bubbles);
    printf("\n");

    choices(arr_choices, n, compareCount = 0, swapCount = 0);
    for (int i = 0; i < n; i++) {arr_choices[i] = -1 * arr_choices[i];}
    printf("Сравнения по убыванию\n");
    printf("Кол-во сравнений: %d\n", compareCount);
    printf("Кол-во перестановок: %d\n", swapCount);
    printf("Сортированный массив: ");
    printDynamicArray(n, arr_choices);
    printf("\n\n");

    return 0;
}