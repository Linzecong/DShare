#ifndef RECORD
#define RECORD
#include<QString>
#include<QImage>
#include"Core.h"

class Meal{
    Time EatTime;
    QList<Food> Foods;

    QImage FoodImage;
    bool HasImage;

    QString Feeling;
    Meal(){}
    ~Meal(){}

};

class Diet{
public:

    Time Day;
    Meal Breakfast;
    Meal Lunch;
    Meal Dinner;
    QList<Meal> Others;

    Diet(){}
    ~Diet(){}

};

class Exercise{
public:
    Time BeginTime;
    Time EndTime;
    int Duration;//分钟

    QString Sport;
    QString Feeling;

    Exercise(){}
    ~Exercise(){}

};




class Record{
public:
    QList<Diet> DietRecord;
    QList<Exercise> ExerciseRecord;

    Record(){}
    ~Record(){}

};



#endif // RECORD

