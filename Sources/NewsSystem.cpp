#include "Headers/NewsSystem.h"
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
    NewsContent="";
    QString out="@getcontent@"+id;
    tcpSocket->write(out.toUtf8());
}

QString NewsSystem::getNewsContent()
{
    return NewsContent;
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

    emit statueChanged(m_Statue);
}

void NewsSystem::tcpSendMessage()
{
    m_Statue="Connected";
    emit statueChanged(m_Statue);
}
