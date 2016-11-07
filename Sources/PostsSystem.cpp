#include "Headers/PostsSystem.h"
#include "Headers/JavaMethod.h"
#include <QNetworkAccessManager>
#include <QUrl>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QEventLoop>
#include<QDir>
#include<QPixmap>

PostsSystem::PostsSystem(QObject *parent) : QObject(parent){
    //自动连接
    NowCount=0;
    tcpSocket = new QTcpSocket(this);
    tcpSocket->connectToHost("119.29.15.43",8520);
    m_Statue="Connecting";
    emit statueChanged(m_Statue);
    connect(tcpSocket,&QTcpSocket::readyRead,this,&PostsSystem::tcpReadMessage);
    connect(tcpSocket,&QTcpSocket::connected,this,&PostsSystem::tcpSendMessage);
}

PostsSystem::~PostsSystem(){

}

void PostsSystem::getposts(QString user){
    PostList.clear();
    Username=user;
    QString out="@getfriendsposts@"+Username;
    m_Statue="";tcpSocket->write(out.toUtf8());

}

void PostsSystem::getuserposts(QString user){
    PostList.clear();
    Username=user;
    QString out="@getuserposts@"+Username;
    m_Statue="";tcpSocket->write(out.toUtf8());
}

void PostsSystem::getmoreposts(int i){
    QString out="@getmorefriendsposts@"+QString::number(i);
    m_Statue="";tcpSocket->write(out.toUtf8());

}

void PostsSystem::getuniquepost(int postid)
{
    uniquepoststr="";
    QString out="@getuniquepost@|||"+QString::number(postid);
    m_Statue="";tcpSocket->write(out.toUtf8());
}

QString PostsSystem::getuniquepoststr()
{
    return uniquepoststr;
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
    QString nnFileName=PostList[i].HeadURL.left(PostList[i].HeadURL.lastIndexOf('.'));
    if(nnFileName=="")
        return "";


    nnFileName=nnFileName+"_temp.jpg";

    Photoname=nnFileName.right(nnFileName.size()-nnFileName.lastIndexOf('/')-1);
    QString path=java.getSDCardPath();
    path=path+"/DShare/"+Photoname+".dbnum";

    if(tempdir->exists(path)){
        return "file://"+path;
    }
    else{
        QNetworkAccessManager *manager=new QNetworkAccessManager(this);
        QEventLoop eventloop;
        connect(manager, SIGNAL(finished(QNetworkReply*)),&eventloop, SLOT(quit()));
        QNetworkReply *reply=manager->get(QNetworkRequest(QUrl(PostList[i].HeadURL)));
        eventloop.exec();

        if(reply->error() == QNetworkReply::NoError)
        {
            QPixmap currentPicture;
            currentPicture.loadFromData(reply->readAll());
            currentPicture.save(path,"JPG");//保存图片
            return "file://"+path;
        }
        else
            return "";
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

QString PostsSystem::getpostpublisher(int i){
    if(i<PostList.length())
        return PostList[i].PublisherID;
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

QString PostsSystem::getpostphoto(int i){
    #ifdef ANDROID
    if(i<PostList.length()){
        JavaMethod java;
        QDir *tempdir = new QDir;
        QString nnFileName=PostList[i].ImageURL.left(PostList[i].ImageURL.lastIndexOf('.'));

        if(nnFileName=="")
            return "";

        nnFileName=nnFileName+"_temp.jpg";

        Photoname=nnFileName.right(nnFileName.size()-nnFileName.lastIndexOf('/')-1);
        QString path=java.getSDCardPath();
        path=path+"/DShare/"+Photoname+".dbnum";



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
                currentPicture.save(path,"JPG");//保存图片
                return "file://"+path;
            }
            else
                return "";
        }
    }
    #endif
    return "";
}


QString PostsSystem::getbigpostphotourl(int i){
    if(i<PostList.length()){
        return PostList[i].ImageURL;
    }
    return "";
}


QString PostsSystem::getpostlikers(int i){
    if(i<PostList.length())
        return PostList[i].LikersString;
    return "";
}



int PostsSystem::getpostID(int i)
{
    if(i<PostList.length())
        return PostList[i].ID;
    return 0;
}

int PostsSystem::getpostcommentcount(int i)
{
    if(i<PostList.length())
        return PostList[i].CommentCount;
    return -1;
}

void PostsSystem::getcomments(int postid)
{
    CommentList.clear();
    PostID=postid;
    QString out="@getcomments@"+QString::number(PostID);
    m_Statue="";tcpSocket->write(out.toUtf8());
}

QString PostsSystem::getcommentatorname(int i)
{
    if(i<CommentList.length())
        return CommentList[i].CommentatorName;
    return "";
}

QString PostsSystem::getbecommentatorname(int i)
{
    if(i<CommentList.length())
        return CommentList[i].BeCommentatorName;
    return "";
}

QString PostsSystem::getcommentmessage(int i)
{
    if(i<CommentList.length())
        return CommentList[i].Message;
    return "";
}

QString PostsSystem::getcommentatorid(int i)
{
    if(i<CommentList.length())
        return CommentList[i].CommentatorID;
    return "";
}

int PostsSystem::getcommentid(int i)
{
    if(i<CommentList.length())
        return CommentList[i].ID;
    return -1;
}

void PostsSystem::sendComment(int postid, QString commentatorid, QString becommentatorid, QString msg)
{
    QString out="@sendcomment@|||"+QString::number(postid)+"|||"+commentatorid+"|||"+becommentatorid+"|||"+msg;
    m_Statue="";tcpSocket->write(out.toUtf8());
}

void PostsSystem::deleteComment(int commentid)
{
    QString out="@deletecomment@|||"+QString::number(commentid);
    m_Statue="";tcpSocket->write(out.toUtf8());
}

void PostsSystem::sendPost(QString username, QString msg, bool hasimage,QString imgpath=""){

    QString out="@sendpost@|||"+username+"|||"+msg+"|||"+QString::number(hasimage)+"|||"+imgpath;
    m_Statue="";tcpSocket->write(out.toUtf8());
}

QString PostsSystem::getbigpostphoto(QString a){
#ifdef ANDROID
        JavaMethod java;
        QDir *tempdir = new QDir;
        QString nnFileName=a;


        Photoname=nnFileName.right(nnFileName.size()-nnFileName.lastIndexOf('/')-1);
        QString path=java.getSDCardPath();
        path=path+"/DShare/"+Photoname+".dbnum";

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
                currentPicture.save(path,"JPG");//保存图片
                return "file://"+path;
            }
            else
                return "";
        }
#endif
        return "";

}

void PostsSystem::savePhoto(QString url)
{
#ifdef ANDROID
    JavaMethod java;

    QString FileName=url.replace("file://","");


    QString SdcardPath=java.getSDCardPath();
    QString nFileName=SdcardPath+"/DSharePhoto/";
    QDir *tempdir = new QDir;
    bool exist = tempdir->exists(nFileName);
    if(!exist)
        tempdir->mkdir(nFileName);

    QFile file(FileName);
    file.open(QIODevice::ReadOnly);


    QString path=java.getSDCardPath();
    path=path+"/DSharePhoto/"+FileName.replace(SdcardPath+"/DShare/","").replace(".dbnum","");
    QFile LogFile;
    LogFile.setFileName(path);
    LogFile.open(QIODevice::WriteOnly);
    if(LogFile.isOpen()){
        LogFile.write(file.readAll());
        m_Statue="SaveSucceed";
        emit statueChanged(m_Statue);
    }
    else{
        m_Statue="SaveError";
        emit statueChanged(m_Statue);
    }


#endif
}

void PostsSystem::likepost(int postid, QString likerid){
    QString out="@likepost@|||"+QString::number(postid)+"|||"+likerid;
    m_Statue="";tcpSocket->write(out.toUtf8());
}

void PostsSystem::deletepost(int postid){
QString out="@deletepost@|||"+QString::number(postid);
m_Statue="";tcpSocket->write(out.toUtf8());
}

void PostsSystem::setStatue(QString s){
    m_Statue=s;
    emit statueChanged(m_Statue);
}

QString PostsSystem::Statue(){
    return m_Statue;
}

void PostsSystem::tcpReadMessage(){
    QString message =QString::fromUtf8(tcpSocket->readAll());


    if(message=="@deletecomment@Succeed@")
        m_Statue="deletecommentSucceed";

    if(message=="@deletecomment@DBError@")
        m_Statue="deletecommentDBError";

    if(message.indexOf("@getuniquepost@Succeed@")>=0){
        uniquepoststr=message.split("{|}").at(1);
        m_Statue="getuniquepostSucceed";
    }

    if(message=="@getuniquepost@DBError@")
        m_Statue="getuniquepostDBError";


    if(message=="@getfriendsposts@DBError@")
        m_Statue="getfriendspostsDBError";

    if(message=="@getfriendsposts@Succeed@")
        m_Statue="getfriendspostsSucceed";


    if(message=="@getuserposts@DBError@")
        m_Statue="getuserpostsDBError";

    if(message=="@getuserposts@Succeed@")
        m_Statue="getuserpostsSucceed";

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
        temp.ID=inf[8].toInt();
        temp.PublisherID=inf[9];
        temp.CommentCount=inf[10].toInt();

        PostList.append(temp);
        m_Statue="getmorefriendspostsSucceed";
    }

    if(message.indexOf("@getcomments@Succeed@")>=0){
        QStringList inf=message.split("|||");
        for(int i=1;i<inf.length()-1;i++){
        Comment temp;
        QStringList tempstr=inf[i].split("{|}");
        temp.ID=tempstr[0].toInt();
        temp.CommentatorID=tempstr[1];
        temp.CommentatorName=tempstr[2];
        temp.BeCommentatorName=tempstr[3];
        temp.Message=tempstr[4];

        CommentList.append(temp);
        }

        m_Statue="getcommentsSucceed";
    }

    if(message=="@getcomments@DBError@")
        m_Statue="getcommentsDBError";

    if(message=="@getmorefriendsposts@NoMore@")
        m_Statue="getmorefriendspostsNoMore";

    if(message=="@sendpost@DBError@")
        m_Statue="sendpostDBError";

    if(message=="@sendpost@Succeed@")
        m_Statue="sendpostSucceed";

    if(message=="@sendcomment@DBError@")
        m_Statue="sendcommentDBError";

    if(message=="@sendcomment@Succeed@")
        m_Statue="sendcommentSucceed";

    if(message=="@likepost@DBError@")
        m_Statue="likepostDBError";

    if(message=="@likepost@Succeed@")
        m_Statue="likepostSucceed";

    if(message=="@likepost@Liked@")
        m_Statue="likepostLiked";

    if(message=="@deletepost@Succeed@")
        m_Statue="deletepostSucceed";

    if(message=="@deletepost@DBError@")
        m_Statue="deletepostDBError";



    emit statueChanged(m_Statue);
}

void PostsSystem::tcpSendMessage()
{
    m_Statue="Connected";
    emit statueChanged(m_Statue);
}
