#ifndef REPORTSYSTEM_H
#define REPORTSYSTEM_H


#include <QObject>
#include <QtNetwork/QtNetwork>



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
public:
     QTcpSocket *tcpSocket;

     QString m_Statue;
     void setStatue(QString s);
     QString Statue();



     QList<Diet> Diets;//6餐内容
     Q_INVOKABLE void getalldiet(QString name);//获取特定时间的饮食数据

     QString Als_Top5_Count;
     QString Als_Top5_Name;
     Q_INVOKABLE void als_Top5();//分析吃得最多的前五个食材
     Q_INVOKABLE QString als_Top5_getCount();
     Q_INVOKABLE QString als_Top5_getName();





public:
     void tcpReadMessage();
     void tcpSendMessage();

signals:
void statueChanged(const QString& Statue);

};




#endif // REPORTSYSTEM_H
