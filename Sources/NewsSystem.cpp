#include "Headers/NewsSystem.h"
#include "Headers/JavaMethod.h"
#include <QNetworkAccessManager>
#include <QUrl>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QEventLoop>
#include<QDir>
#include<QPixmap>

NewsSystem::NewsSystem(QObject *parent) : QObject(parent){
    //自动连接
    tcpSocket = new QTcpSocket(this);
    tcpSocket->connectToHost("119.29.15.43",4567);
    m_Statue="Connecting";
    emit statueChanged(m_Statue);
    connect(tcpSocket,&QTcpSocket::readyRead,this,&NewsSystem::tcpReadMessage);
    connect(tcpSocket,&QTcpSocket::connected,this,&NewsSystem::tcpSendMessage);
}

NewsSystem::~NewsSystem(){

}


void NewsSystem::setStatue(QString s){
    m_Statue=s;
    emit statueChanged(m_Statue);
}

QString NewsSystem::Statue(){
    return m_Statue;
}

void NewsSystem::getNews(int count)
{
    m_Statue="";
    NewsList="";
    QString out="@getnews@"+QString::number(count);
    tcpSocket->write(out.toUtf8());
}

QString NewsSystem::getNewsList()
{
    return NewsList;
}

void NewsSystem::getContent(QString id)
{
    m_Statue="";
    NewsContent="";
    QString out="@getcontent@"+id;
    tcpSocket->write(out.toUtf8());
}

QString NewsSystem::getNewsContent()
{
    return NewsContent;
}

void NewsSystem::likeNews(QString id)
{
    m_Statue="";
    QString out="@likenews@"+id;
    tcpSocket->write(out.toUtf8());
}

void NewsSystem::dislikeNews(QString id)
{
    m_Statue="";
    QString out="@dislikenews@"+id;
    tcpSocket->write(out.toUtf8());
}

bool NewsSystem::saveMarked(QString str)
{
#ifdef ANDROID
    JavaMethod java;
    QString path=java.getSDCardPath();
    path=path+"/DShare/markdb.dbnum";
    QFile LogFile;
    QTextStream LogTextStream(&LogFile);
    LogFile.setFileName(path);
    LogFile.open(QIODevice::WriteOnly);
    if(LogFile.isOpen())
        LogTextStream<<str<<endl;
    else
        return false;
    return true;

#endif
}

QString NewsSystem::loadMarked()
{
#ifdef ANDROID
    JavaMethod java;
    QString longstr;

    QString path=java.getSDCardPath();

    path=path+"/DShare/markdb.dbnum";

    QFile LogFile;

    LogFile.setFileName(path);
    LogFile.open(QIODevice::ReadOnly);
    if(LogFile.isOpen()){
        QTextStream LogTextStream(&LogFile);
        LogTextStream>>longstr;
        return longstr;
    }
    else{
        return "";
    }

#endif
}

void NewsSystem::getcomments(QString postid)
{
    CommentList.clear();

    QString out="@getcomments@"+postid;
    tcpSocket->write(out.toUtf8());
}

QString NewsSystem::getcommentatorname(int i)
{
    if(i<CommentList.length())
        return CommentList[i].CommentatorName;
    return "";
}

QString NewsSystem::getbecommentatorname(int i)
{
    if(i<CommentList.length())
        return CommentList[i].BeCommentatorName;
    return "";
}

QString NewsSystem::getcommentmessage(int i)
{
    if(i<CommentList.length())
        return CommentList[i].Message;
    return "";
}

QString NewsSystem::getcommentatorid(int i)
{
    if(i<CommentList.length())
        return CommentList[i].CommentatorID;
    return "";
}

int NewsSystem::getcommentid(int i)
{
    if(i<CommentList.length())
        return CommentList[i].ID;
    return -1;
}

void NewsSystem::sendComment(QString postid, QString commentatorid, QString becommentatorid, QString msg)
{
    QString out="@sendcomment@|||"+postid+"|||"+commentatorid+"|||"+becommentatorid+"|||"+msg;
    m_Statue="";
    tcpSocket->write(out.toUtf8());
}

void NewsSystem::deleteComment(int commentid)
{
    QString out="@deletecomment@|||"+QString::number(commentid);
    m_Statue="";tcpSocket->write(out.toUtf8());
}


void NewsSystem::tcpReadMessage(){
    QString message =QString::fromUtf8(tcpSocket->readAll());

    if(message=="@getnews@DBError@")
        m_Statue="getnewsDBError";

    if(message.indexOf("@getnews@Succeed@")>=0){
        NewsList=message.split("@")[3];
        m_Statue="getnewsSucceed";
    }

    if(message=="@getcontent@DBError@")
        m_Statue="getcontentDBError";

    if(message.indexOf("@getcontent@Succeed@")>=0){
        NewsContent=message;
        m_Statue="getcontentSucceed";
    }

    if(message=="@deletecomment@Succeed@")
        m_Statue="deletecommentSucceed";

    if(message=="@deletecomment@DBError@")
        m_Statue="deletecommentDBError";

    if(message.indexOf("@getcomments@Succeed@")>=0){
        QStringList inf=message.split("|||");
        for(int i=1;i<inf.length()-1;i++){
        NewsComment temp;
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

    if(message=="@sendcomment@DBError@")
        m_Statue="sendcommentDBError";

    if(message=="@sendcomment@Succeed@")
        m_Statue="sendcommentSucceed";

    emit statueChanged(m_Statue);
}

void NewsSystem::tcpSendMessage()
{
    m_Statue="Connected";
    emit statueChanged(m_Statue);
}
