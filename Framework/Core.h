#ifndef CORE_H
#define CORE_H

#include<QString>
#include<QImage>
#include<QTime>

const int MD[]={0,31,28,31,30,31,30,31,31,30,31,30,31};

class Time{
public:
    enum StringType{SYear,SMonth,SHour};
    int Year;
    int Month;
    int Day;
    int Hour;
    int Minute;
    int Second;


    QString toString(StringType type);
    QString interval(Time Now,Time Before);


    //    Time operator+ (Time a);
    //    Time operator- (Time a);
    static Time fromString(QString a);

    //    Time(int Y,int Mon,int D,int H,int Min,int S);
    Time();
    ~Time(){}
   // static Time nowTime();

};

QString Time::toString(Time::StringType type){
    switch(type){
    case Time::SYear:
        return QString::number(Year)+"年"+QString::number(Month)+"月"+QString::number(Day)+"日"+QString::number(Hour)+"："+QString::number(Minute)+"："+QString::number(Second);
    case Time::SMonth:
        return QString::number(Month)+"月"+QString::number(Day)+"日";
    case Time::SHour:
        return QString::number(Hour)+"："+QString::number(Minute)+"："+QString::number(Second);
    }
    return "NULL";
}

QString Time::interval(Time Now, Time Before){
    if(Now.Year-Before.Year>1)
        return QString::number(Now.Year-Before.Year)+"年前";
    else
        return QString::number(Now.Month+12-Before.Month)+"个月前";

    if(Now.Month-Before.Month>1)
        return QString::number(Now.Month-Before.Month)+"个月前";
    else
    {
        if(Before.Year%4==0&&Before.Month==2)
            return QString::number(Now.Day+(29-Before.Day))+"天前";
        else
            return QString::number(Now.Day+(MD[Before.Month]-Before.Day))+"天前";
    }


    if(Now.Day-Before.Day>1)
        return QString::number(Now.Day-Before.Day)+"天前";
    else
        return QString::number(Now.Hour-(24-Before.Hour))+"天前";

    if(Now.Hour-Before.Hour>1)
        return QString::number(Now.Hour-Before.Hour)+"小时前";
    else
        return QString::number(Now.Minute-(60-Before.Minute))+"小时前";

    if(Now.Minute-Before.Minute>1)
        return QString::number(Now.Minute-Before.Minute)+"分钟前";
    else
        return QString::number(Now.Hour-(24-Before.Hour))+"分钟前";


    return QString::number(Now.Second-Before.Second)+"秒前";

}

Time Time::fromString(QString a){
    Time temp;

    temp.Year=a.left(a.indexOf("年")).toInt();
    temp.Month=a.mid(a.indexOf("年"),a.indexOf("月")).toInt();
    temp.Day=a.mid(a.indexOf("月"),a.indexOf("日")).toInt();
    a=a.mid(a.indexOf("日"));
    temp.Hour=a.split(":").at(0).toInt();
    temp.Minute=a.split(":").at(1).toInt();
    temp.Second=a.split(":").at(2).toInt();

    return temp;

}

Time::Time(){

}





class Location{
public:
    static QStringList CountryList;
    static QStringList ProvinceList;
    static QStringList CityList;


    QString Country;
    QString Province;
    QString City;


};

class Food{
public:
    static QStringList RichInList;
    static QStringList PropertyList;
    static QStringList HelpfulForList;
    static QList<Food> FoodList;

    int ID;
    QString Name;
    QString Des;

    QList<QImage> Pictures;

    QStringList Amities;//相生
    QStringList AmityReasons;

    QStringList Unamities;//相克
    QStringList UnamityReasons;

    QList<int> RichIn;//富含
    QList<int> Properties;//食物性状
    QList<int> HelpfulFor;//适用人群



};












#endif // CORE_H



