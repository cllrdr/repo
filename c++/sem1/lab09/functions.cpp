#include "header.h"

Dictionary add_w() {
    char eng[l_word];
    char rus[l_word];
    Dictionary item;
    cout << "Введите слово на английском и через пробел на русском:" << endl;
    cin >> eng >> rus;
    cout << "Вы ввели пару для словаря:" << " " << eng << " - " << rus << endl;
    item.eng = new char [strlen(eng) + 1];
    strcpy(item.eng, eng);
    item.rus = new char [strlen(eng) + 1];
    strcpy(item.eng, eng);
    return item;  
}