#ifndef DATASYSTEM_H
#define DATASYSTEM_H

#include <QObject>
#include <QtNetwork/QtNetwork>
#include<QTimer>
#include<QStringList>

class DataSystem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString Statue READ Statue WRITE setStatue NOTIFY statueChanged)
public:
    explicit DataSystem(QObject *parent = 0);



public:
     QTcpSocket *tcpSocket;
     QTimer ConnectTimer;


     QString m_Statue;
     void setStatue(QString s);
     QString Statue();

     QString Name;
     Q_INVOKABLE void getNameByID(QString userid);//获取用户昵称
     Q_INVOKABLE QString getName();//返回用户昵称

     Q_INVOKABLE void changeName(QString userid,QString newname);
     Q_INVOKABLE void addFollowing(QString userid,QString friendid);
     Q_INVOKABLE void deleteFollowing(QString userid,QString friendid);

     QStringList FollowingIDList;
     QStringList FollowingNameList;
     Q_INVOKABLE void getFollowings(QString userid);
     Q_INVOKABLE QString getFollowingID(int i);
     Q_INVOKABLE QString getFollowingName(int i);


     QStringList FollowerIDList;
     QStringList FollowerNameList;
     Q_INVOKABLE void getFollowers(QString userid);
     Q_INVOKABLE QString getFollowerID(int i);
     Q_INVOKABLE QString getFollowerName(int i);

     QStringList SearchIDList;
     QStringList SearchNameList;
     Q_INVOKABLE void searchUser(QString str);
     Q_INVOKABLE QString getsearchUserID(int i);
     Q_INVOKABLE QString getsearchUserName(int i);

     Q_INVOKABLE void checkin(QString userid);
     Q_INVOKABLE void getcheckinday(QString userid);
     Q_INVOKABLE int getcheckinday();
     int checkinday;

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

#endif // DATASYSTEM_H
