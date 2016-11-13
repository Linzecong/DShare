#ifndef RECOMMENDSYSTEM_H
#define RECOMMENDSYSTEM_H



#include <QObject>
#include <QtNetwork/QtNetwork>
#include <QMap>
#include "Headers/RecordSystem.h"


class RecommendSystem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString Statue READ Statue WRITE setStatue NOTIFY statueChanged)
public:
    explicit RecommendSystem(QObject *parent = 0);
    ~RecommendSystem();
public:
     QTcpSocket *tcpSocket;

     QString m_Statue;
     void setStatue(QString s);
     QString Statue();


     QString YYRecommend;
     Q_INVOKABLE void recommendYY(QString userid);
     Q_INVOKABLE QString getYYRecommend();

     QString XGRecommend;
     Q_INVOKABLE void recommendXG(QString userid);
     Q_INVOKABLE QString getXGRecommend();

     QString HYRecommend;
     Q_INVOKABLE void recommendHY(QString userid);
     Q_INVOKABLE QString getHYRecommend();


public:
     void tcpReadMessage();
     void tcpSendMessage();

signals:
void statueChanged(const QString& Statue);

};



#endif // RECOMMENDSYSTEM_H
