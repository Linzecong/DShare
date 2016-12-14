#include "Headers/RecommendSystem.h"

#include <QFile>
#include <QTextStream>
#include <QPair>


RecommendSystem::RecommendSystem(QObject *parent) : QObject(parent){
    tcpSocket = new QTcpSocket(this);
    tcpSocket->connectToHost("119.29.15.43",24567);
    connect(tcpSocket,&QTcpSocket::readyRead,this,&RecommendSystem::tcpReadMessage);
    connect(tcpSocket,&QTcpSocket::connected,this,&RecommendSystem::tcpSendMessage);
    connect(&ConnectTimer,&QTimer::timeout,this,&RecommendSystem::reconnect);

}

RecommendSystem::~RecommendSystem(){

}
void RecommendSystem::reconnect()
{
    if(tcpSocket->state()==QAbstractSocket::UnconnectedState)
        tcpSocket->connectToHost("119.29.15.43",24567);
}
void RecommendSystem::setStatue(QString s){
    m_Statue=s;
    emit statueChanged(m_Statue);
}

QString RecommendSystem::Statue(){
    return m_Statue;
}

void RecommendSystem::recommendXG(QString userid)
{
    QString out="@recommendxg@"+userid;
    m_Statue="";tcpSocket->write(out.toUtf8());
}

QString RecommendSystem::getXGRecommend()
{
    return XGRecommend;
}

void RecommendSystem::recommendYY(QString userid)
{
    QString out="@recommendyy@"+userid;
    m_Statue="";tcpSocket->write(out.toUtf8());
}

QString RecommendSystem::getYYRecommend()
{
    return YYRecommend;
}

void RecommendSystem::recommendHY(QString userid)
{
    QString out="@recommendhy@"+userid;
    m_Statue="";tcpSocket->write(out.toUtf8());
}

QString RecommendSystem::getHYRecommend()
{
    return HYRecommend;
}


void RecommendSystem::tcpReadMessage(){
    QString message =QString::fromUtf8(tcpSocket->readAll());

    if(message=="@recommendxg@DBError@")
        m_Statue="recommendxgDBError";

    if(message.indexOf("@recommendxg@Succeed@")>=0){
        XGRecommend=message.split("@")[3];
        m_Statue="recommendxgSucceed";
    }

    if(message=="@recommendyy@DBError@")
        m_Statue="recommendyyDBError";

    if(message.indexOf("@recommendyy@Succeed@")>=0){
        YYRecommend=message.split("@")[3];
        m_Statue="recommendyySucceed";
    }

    if(message=="@recommendhy@DBError@")
        m_Statue="recommendhyDBError";

    if(message.indexOf("@recommendhy@Succeed@")>=0){
        HYRecommend=message.split("@")[3];
        m_Statue="recommendhySucceed";
    }



    emit statueChanged(m_Statue);
}

void RecommendSystem::tcpSendMessage(){
    ConnectTimer.start(1000);
    m_Statue="Connected";
    emit statueChanged(m_Statue);
}

