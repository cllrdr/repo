#include <iostream>
#include <fstream>
#include <string>
#include <cstring>
using namespace std;

const int  max_size = 100;
const int l_word = 31;
struct Dictionary {
    char* eng;	// слово по-английски
    char* rus;	// слово по-русски
};

Dictionary add_w();