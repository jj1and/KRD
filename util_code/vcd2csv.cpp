#include <iostream>
#include <fstream>
#include <string>

using namespace std;

int main(int argc, char const *argv[])
{
    const char *FILE_NAME = "";
    const int search_num = 0;

    int *column;
    int *column_width;
    string *column_delimeter;

    fstream ifs(FILE_NAME);
    if (!ifs)
    {
      cerr << "Failed to open file" << endl;
    }
    
    int column_num;
    int end_time;
    string read_str;
    while (getline(ifs, read_str))
    {
      if(read_str._Starts_with("$var")) {
        
      }
      else if (read_str._Starts_with("#"))
      {
        
      }
    }
    

    return 0;
}
