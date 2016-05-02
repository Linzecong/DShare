#ifndef LOGINSYSTEM_H
#define LOGINSYSTEM_H

#include <QObject>
#include <QtNetwork/QtNetwork>
#include<QTimer>


class LoginSystem : public QObject{
    Q_OBJECT
    Q_PROPERTY(QString Statue READ Statue WRITE setStatue NOTIFY statueChanged)


public:
    explicit LoginSystem(QObject *parent = 0);
    ~LoginSystem();


public:
     QTcpSocket *tcpSocket;
     QTimer ConnectTimer;
     QString Username;
     QString Password;

     QString m_Statue;
     void setStatue(QString s);
     QString Statue();

     Q_INVOKABLE void login(QString name,QString pass);

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








#endif // LOGINSYSTEM_H
