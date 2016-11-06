#ifndef NEWSSYSTEM_H
#define NEWSSYSTEM_H

#include <QObject>
#include <QtNetwork/QtNetwork>



class NewsSystem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString Statue READ Statue WRITE setStatue NOTIFY statueChanged)
public:
    explicit NewsSystem(QObject *parent = 0);
    ~NewsSystem();
public:
     QTcpSocket *tcpSocket;

     QString m_Statue;
     void setStatue(QString s);
     QString Statue();


     QString NewsList;
     Q_INVOKABLE void getNews(int count);//分析一定时间内运动时间分布
     Q_INVOKABLE QString getNewsList();


     QString NewsContent;
     Q_INVOKABLE void getContent(QString id);//分析一定时间内运动时间分布
     Q_INVOKABLE QString getNewsContent();

public:
     void tcpReadMessage();
     void tcpSendMessage();

signals:
void statueChanged(const QString& Statue);

};




#endif // REPORTSYSTEM_H
