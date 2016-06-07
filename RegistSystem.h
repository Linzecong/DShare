/*注册系统*/

#ifndef REGISTSYSTEM_H
#define REGISTSYSTEM_H

#include <QObject>
#include <QtNetwork/QtNetwork>
#include<QTimer>

class RegistSystem : public QObject{
    Q_OBJECT
    Q_PROPERTY(QString Statue READ Statue WRITE setStatue NOTIFY statueChanged)
public:
    explicit RegistSystem(QObject *parent = 0);
    ~RegistSystem();
public:
     QTcpSocket *tcpSocket;
     QString Username;
     QString Password;
     QString Name;

     QString m_Statue;
     void setStatue(QString s);
     QString Statue();

     Q_INVOKABLE void regist(QString id,QString pass,QString name);//注册

public:
     void tcpReadMessage();
     void tcpSendMessage();

signals:
void statueChanged(const QString& Statue);

};

#endif // REGISTSYSTEM_H
