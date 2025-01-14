#include <iostream>
#include <string.h>

int main() {

    int hrs;
    int min;
    char phase[13];
    char hours[11];
    char minutes[13];

// ввод часов и минут
    std::cout << "Введите часы:" << std::endl;
    std::cin >> hrs;
    std::cout << "Введите минуты:" << std::endl;
    std::cin >> min;

// проверка значений
    if ( (hrs < 0 or hrs > 23) or (min < 0 or min > 59)) {
        std::cout << "Некорректные значения времени" << std::endl;
        return 0;
    }
    
// полночь полдень
    std::cout << "Введенное время на чистом и прекрасном русском языке:" << std::endl;

    if (hrs == 0 and min == 0) {
        std::cout << "Полдень" << std::endl;
        return 0;
    }
    if (hrs == 12 and min == 0) {
        std::cout << "Полночь" << std::endl;
        return 0;
    }

// выбор времени суток
    if (hrs >= 0 and hrs < 5) { strcpy(phase,"ночи");}
    else if (hrs >= 5 and hrs < 12) { strcpy(phase, "утра");}
    else if (hrs >= 12 and hrs < 18) { strcpy(phase, "дня");}
    else { strcpy(phase, "вечера");}

// падежи часов
    if ((hrs%12) == 1) { strcpy(hours, "час");}
    else if ((hrs%12) <= 4 and (hrs%12) > 1) { strcpy(hours, "часа");}
    else { strcpy(hours, "часов");}

// случай для 0 минут
    if (min == 0) {
        std::cout << hrs%12 << " " << hours << " " << phase << " " << "ровно" << std::endl;
        return 0;
    }

// падежи минут
    if ((min%10) == 1) { strcpy(minutes, "минута");}
    else if ((min%10) > 1 and (min%10) <= 4) { strcpy(minutes, "минуты");}
//    else (((min%10) > 5 and (min%10) <= 9) or (min%10)==0) { strcpy(minutes, "минут");}
    else { strcpy(minutes, "минут");}
    if (min >= 11 and min <= 19) { strcpy(minutes, "минут");}

// случай для 12 часов дня

    if (hrs == 12) {
        std::cout << hrs << " " << hours << " " << min << " " << minutes << " " << phase << std::endl;
        return 0;
    }

// общий случай
    std::cout << hrs%12 << " " << hours << " " << min << " " << minutes << " " << phase << std::endl;

    return 0;
}