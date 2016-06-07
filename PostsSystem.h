/*分享系统，包括发送和查看*/

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
    QList<Post> PostList;//保存获取到的分享
    int NowCount;//记录加载了多少个分享

    Q_INVOKABLE void getposts(QString user);//获取关注的用户的分享列表，1有更多
    Q_INVOKABLE void getuserposts(QString user);//获取用户的分享列表，1有更多
    Q_INVOKABLE void getmoreposts(int i);//1有更多

    Q_INVOKABLE int getposthasimage(int i);
    Q_INVOKABLE QString getposthead(int i);
    Q_INVOKABLE QString getpostname(int i);
    Q_INVOKABLE QString getpostpublisher(int i);
    Q_INVOKABLE QString getposttime(int i);
    Q_INVOKABLE QString getpostmessage(int i);
    Q_INVOKABLE QString getpostphoto(int i);//先判断有没有缓存
    Q_INVOKABLE QString getbigpostphotourl(int i);//返回大图地址
    Q_INVOKABLE QString getpostlikers(int i);
    Q_INVOKABLE int getpostID(int i);

    Q_INVOKABLE void sendPost(QString username,QString msg,bool hasimage,QString imgpath);//发送分享
    Q_INVOKABLE QString getbigpostphoto(QString a);//返回大图地址，先判断有没有缓存
    Q_INVOKABLE void likepost(int postid,QString likerid);//点赞分享

    void tcpSendMessage();
    void tcpReadMessage();


    QString m_Statue;
    void setStatue(QString s);
    QString Statue();


signals:
void statueChanged(const QString& Statue);

};

#endif // POSTSSYSTEM_H
