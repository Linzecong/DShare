#ifndef REPORTSYSTEM_H
#define REPORTSYSTEM_H

#include <QObject>
#include <QtNetwork/QtNetwork>
#include <QMap>
#include "Headers/RecordSystem.h"
struct Diet{
    QString DateTime;
    QStringList Breakfast;
    QStringList Lunch;
    QStringList Dinner;
    QStringList Snack;
    QStringList Dessert;
    QStringList Others;
};


class ReportSystem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString Statue READ Statue WRITE setStatue NOTIFY statueChanged)
public:
    explicit ReportSystem(QObject *parent = 0);
    ~ReportSystem();
    QTimer ConnectTimer;
    void reconnect();
public:
     QTcpSocket *tcpSocket;

     QString m_Statue;
     void setStatue(QString s);
     QString Statue();

     QMap<QString,int> XZMap;
     QMap<QString,int> YYMap;
     QMap<QString,int> YLMap;
     void initMap();

     QList<Diet> Diets;//6餐内容
     Q_INVOKABLE void getalldiet(QString name);//获取特定时间的饮食数据

     QList<Exercise> Exercises;//6餐内容
     Q_INVOKABLE void getallexercise(QString name);//获取特定时间的运动数据

     QString Als_Top5_Count;
     QString Als_Top5_Name;
     Q_INVOKABLE void als_Top5(int type);//分析吃得最多的前五个食材
     Q_INVOKABLE QString als_Top5_getCount();
     Q_INVOKABLE QString als_Top5_getName();


     QString Als_Time_Count;
     QString Als_Time_Name;
     QString Als_Time_FoodName;
     Q_INVOKABLE void als_Time(int type);//分析一定时间内吃得最多的前五个食材
     Q_INVOKABLE QString als_Time_getCount();
     Q_INVOKABLE QString als_Time_getName();
     Q_INVOKABLE QString als_Time_getFoodName();
     QList<QPair<QString, int> > getTop3FoodName(int days, int sort=1);
     void getTop3FoodCount(int days, int* fnum, int* snum, int* tnum, QString fir, QString sec, QString thr);


     QString Als_Type_Count;
     Q_INVOKABLE void als_Type(int type,int days);//分析性状吃得最多的前五个食材
     Q_INVOKABLE QString als_Type_getCount();




     QString Als_Time_Count_Exe;
     QString Als_Time_Name_Exe;

     Q_INVOKABLE void als_Time_Exe(int type);//分析一定时间内运动时间分布
     Q_INVOKABLE QString als_Time_Exe_getCount();
     Q_INVOKABLE QString als_Time_Exe_getName();




public:
     void tcpReadMessage();
     void tcpSendMessage();

signals:
void statueChanged(const QString& Statue);

};




#endif // REPORTSYSTEM_H
