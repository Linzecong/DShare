#ifndef NEWS
#define NEWS
#include<QString>
#include"Core.h"

class News{
public:
    double ID;
    QString Title;
    QString Des;
    QString Content;
    Time CollectTime;
    QString Sourse;
    News(){}
    ~News(){}


};

#endif // NEWS

