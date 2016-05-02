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
     QTimer ConnectTimer;
     QString Username;
     QString Password;
     QString Name;

     QString m_Statue;
     void setStatue(QString s);
     QString Statue();

     Q_INVOKABLE void regist(QString id,QString pass,QString name);

public:
     void tcpReadMessage();
     void tcpSendMessage();

     void tcpTimeOut(){
         static int i=0;
         if(i++==10){
             tcpSocket->disconnectFromHost();
             ConnectTimer.stop();
             m_Statue="ConnectFail";
             emit statueChanged(m_Statue);
             i=0;
         }
     }

signals:
void statueChanged(const QString& Statue);
public slots:
};

#endif // REGISTSYSTEM_H
