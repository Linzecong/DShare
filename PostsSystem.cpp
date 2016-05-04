#include "PostsSystem.h"
#include "JavaMethod.h"
#include <QNetworkAccessManager>
#include <QUrl>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QEventLoop>
#include<QDir>
#include<QPixmap>
PostsSystem::PostsSystem(QObject *parent) : QObject(parent)
{
    NowCount=0;
    tcpSocket = new QTcpSocket(this);
    tcpSocket->connectToHost("119.29.15.43",8520);
    m_Statue="Connecting";
    emit statueChanged(m_Statue);

    connect(tcpSocket,&QTcpSocket::readyRead,this,&PostsSystem::tcpReadMessage);

    connect(tcpSocket,&QTcpSocket::connected,this,&PostsSystem::tcpSendMessage);
    connect(&ConnectTimer,&QTimer::timeout,this,&PostsSystem::tcpTimeOut);

}

PostsSystem::~PostsSystem(){

}

void PostsSystem::getposts(QString user)
{
    PostList.clear();
    Username=user;
    QString out="@getfriendsposts@"+Username;
    tcpSocket->write(out.toUtf8());

}

void PostsSystem::getmoreposts(int i){
    QString out="@getmorefriendsposts@"+QString::number(i);
    tcpSocket->write(out.toUtf8());

}

int PostsSystem::getposthasimage(int i){
    if(i<PostList.length())
        return PostList[i].HasImage;
    return 0;
}

QString PostsSystem::getposthead(int i){
#ifdef ANDROID
    if(i<PostList.length()){
        JavaMethod java;
        QDir *tempdir = new QDir;
        QString nnFileName=PostList[i].HeadURL;

        Photoname=nnFileName.right(nnFileName.size()-nnFileName.lastIndexOf('/')-1);
        QString path=java.getSDCardPath();
        path=path+"/projectapp/"+Photoname;

        if(tempdir->exists(path)){
            return "file://"+path;
        }
        else{


            QNetworkAccessManager *manager=new QNetworkAccessManager(this);
            QEventLoop eventloop;
            connect(manager, SIGNAL(finished(QNetworkReply*)),&eventloop, SLOT(quit()));
            QNetworkReply *reply=manager->get(QNetworkRequest(QUrl(nnFileName)));
            eventloop.exec();

            if(reply->error() == QNetworkReply::NoError)
            {
                QPixmap currentPicture;
                currentPicture.loadFromData(reply->readAll());
                currentPicture.save(path);//保存图片
            }


            return "file://"+path;
        }
    }
#endif
    return "";
}

QString PostsSystem::getpostname(int i){
    if(i<PostList.length())
        return PostList[i].Publisher;
    return "";
}

QString PostsSystem::getposttime(int i){
    if(i<PostList.length())
        return PostList[i].PostTime;
    return "";
}

QString PostsSystem::getpostmessage(int i){
    if(i<PostList.length())
        return PostList[i].Message;
    return "";
}

QString PostsSystem::getpostphoto(int i)
{
    #ifdef ANDROID
    if(i<PostList.length()){
        JavaMethod java;
        QDir *tempdir = new QDir;
        QString nnFileName=PostList[i].ImageURL.left(PostList[i].ImageURL.lastIndexOf('.'));
        nnFileName=nnFileName+"_temp.jpg";

        Photoname=nnFileName.right(nnFileName.size()-nnFileName.lastIndexOf('/')-1);
        QString path=java.getSDCardPath();
        path=path+"/projectapp/"+Photoname;

        if(tempdir->exists(path)){
            return "file://"+path;
        }
        else{


            QNetworkAccessManager *manager=new QNetworkAccessManager(this);
            QEventLoop eventloop;
            connect(manager, SIGNAL(finished(QNetworkReply*)),&eventloop, SLOT(quit()));
            QNetworkReply *reply=manager->get(QNetworkRequest(QUrl(nnFileName)));
            eventloop.exec();

            if(reply->error() == QNetworkReply::NoError)
            {
                QPixmap currentPicture;
                currentPicture.loadFromData(reply->readAll());
                currentPicture.save(path);//保存图片
            }


            return "file://"+path;
        }


    }
    #endif
    return "";
}

QString PostsSystem::getbigpostphotourl(int i)
{
    if(i<PostList.length()){
        return PostList[i].ImageURL;
    }
    return "";
}


QString PostsSystem::getpostlikers(int i){
    if(i<PostList.length())
        return PostList[i].LikersString;
}

void PostsSystem::sendPost(QString username, QString msg, bool hasimage,QString imgpath=""){

    QString out="@sendpost@|||"+username+"|||"+msg+"|||"+QString::number(hasimage)+"|||"+imgpath;
    tcpSocket->write(out.toUtf8());
}

QString PostsSystem::getbigpostphoto(QString a)
{

#ifdef ANDROID
        JavaMethod java;
        QDir *tempdir = new QDir;
        QString nnFileName=a;


        Photoname=nnFileName.right(nnFileName.size()-nnFileName.lastIndexOf('/')-1);
        QString path=java.getSDCardPath();
        path=path+"/projectapp/"+Photoname;

        if(tempdir->exists(path)){
            return "file://"+path;
        }
        else{


            QNetworkAccessManager *manager=new QNetworkAccessManager(this);
            QEventLoop eventloop;
            connect(manager, SIGNAL(finished(QNetworkReply*)),&eventloop, SLOT(quit()));
            QNetworkReply *reply=manager->get(QNetworkRequest(QUrl(nnFileName)));
            eventloop.exec();

            if(reply->error() == QNetworkReply::NoError)
            {
                QPixmap currentPicture;
                currentPicture.loadFromData(reply->readAll());
                currentPicture.save(path);//保存图片
            }


            return "file://"+path;
        }
#endif
        return "";

}

void PostsSystem::setStatue(QString s)
{
    m_Statue=s;
    emit statueChanged(m_Statue);
}

QString PostsSystem::Statue()
{
    return m_Statue;
}

void PostsSystem::tcpReadMessage()
{


    QString message =QString::fromUtf8(tcpSocket->readAll());

    if(message=="@getfriendsposts@DBError@")
        m_Statue="getfriendspostsDBError";

    if(message=="@getfriendsposts@Succeed@")
        m_Statue="getfriendspostsSucceed";



    if(message.indexOf("@getmorefriendsposts@Succeed@")>=0){
        QStringList inf=message.split("|||");
        Post temp;
        temp.Publisher=inf[1];
        temp.HeadURL=inf[2];
        temp.Message=inf[3];
        temp.HasImage=inf[4].toInt();
        temp.LikersString=inf[5];
        temp.ImageURL=inf[6];
        temp.PostTime=inf[7];
        PostList.append(temp);
        m_Statue="getmorefriendspostsSucceed";
    }

    if(message=="@getmorefriendsposts@NoMore@")
        m_Statue="getmorefriendspostsNoMore";

    if(message=="@sendpost@DBError@")
        m_Statue="sendpostDBError";

    if(message=="@sendpost@Succeed@")
        m_Statue="sendpostSucceed";

    ConnectTimer.stop();
    emit statueChanged(m_Statue);
}

void PostsSystem::tcpSendMessage()
{
    m_Statue="Connected";
    ConnectTimer.stop();
    emit statueChanged(m_Statue);
}
