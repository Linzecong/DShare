#ifndef USERSYSTEM_H
#define USERSYSTEM_H

#include <QObject>

class UserSystem:public QObject{
public:
    QString Username;
    QString Password;
    MainUser* User;

    QTcpSocket *tcpSocket;
    QTimer ConnectTimer;

    void setError(){Error=ConnentionFail;}
    void setOK(){Error=OK;}
    void tcpReadMessage();
    void tcpTimeOut(){
        static int i=0;
        if(i++==10){
            Error=ConnentionFail;
            tcpSocket->disconnectFromHost();
            ConnectTimer.stop();
            i=0;
        }
    }

public:
    UserSystem(QString user, QString pass, MainUser *us);
    ~UserSystem(){}
public:
    enum ErrorType{NoUser,ConnentionFail,OK,Connecting}Error;
public:

    bool getData();

    MainUser* getUser();


    bool upDatePostCollections();
    // void upDateNewsCollections();


};

#endif // USERSYSTEM_H
