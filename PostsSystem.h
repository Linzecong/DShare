#ifndef POSTSSYSTEM_H
#define POSTSSYSTEM_H

#include <QObject>
#include "Framework/Post.h"
#include <QtNetwork/QtNetwork>
#include<QTimer>

class PostsSystem:public QObject{
    Q_OBJECT
    Q_PROPERTY(QString Statue READ Statue WRITE setStatue NOTIFY statueChanged)
public:
    explicit PostsSystem(QObject *parent = 0);
    ~PostsSystem();

public:
    QString Username;
    QString Photoname;

    QTcpSocket *tcpSocket;
    QTimer ConnectTimer;
    QList<Post> PostList;
    int NowCount;

    Q_INVOKABLE void getposts(QString user);//1有更多

    Q_INVOKABLE void getmoreposts(int i);//1有更多

    Q_INVOKABLE int getposthasimage(int i);
    Q_INVOKABLE QString getposthead(int i);
    Q_INVOKABLE QString getpostname(int i);
    Q_INVOKABLE QString getposttime(int i);
    Q_INVOKABLE QString getpostmessage(int i);
    Q_INVOKABLE QString getpostphoto(int i);
    Q_INVOKABLE QString getbigpostphotourl(int i);
    Q_INVOKABLE QString getpostlikers(int i);
    Q_INVOKABLE void sendPost(QString username,QString msg,bool hasimage,QString imgpath);
    Q_INVOKABLE QString getbigpostphoto(QString a);

    void tcpSendMessage();
    void tcpReadMessage();
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




    QString m_Statue;
    void setStatue(QString s);
    QString Statue();


signals:
void statueChanged(const QString& Statue);
public slots:


};

#endif // POSTSSYSTEM_H
