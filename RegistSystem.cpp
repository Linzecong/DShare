#include "RegistSystem.h"

RegistSystem::RegistSystem(QObject *parent) : QObject(parent)
{
    tcpSocket = new QTcpSocket(this);
    connect(tcpSocket,&QTcpSocket::readyRead,this,&RegistSystem::tcpReadMessage);
    connect(tcpSocket,&QTcpSocket::connected,this,&RegistSystem::tcpSendMessage);
    connect(&ConnectTimer,&QTimer::timeout,this,&RegistSystem::tcpTimeOut);
    m_Statue="InitOK";
}

void RegistSystem::regist(QString id, QString pass,QString name)
{
    ConnectTimer.start(1000);
    Username=id;
    Password=pass;
    Name=name;
    tcpSocket->connectToHost("119.29.15.43",5555);
    m_Statue="Connecting";
    emit statueChanged(m_Statue);
}
RegistSystem::~RegistSystem(){

}

void RegistSystem::setStatue(QString s)
{
    m_Statue=s;
    emit statueChanged(m_Statue);
}


QString RegistSystem::Statue()
{
    return m_Statue;
}

void RegistSystem::tcpReadMessage()
{
    QString message =  QString::fromUtf8(tcpSocket->readAll());
    if(message=="@zhuce@DBError@")
        m_Statue="DBError";

    if(message=="@zhuce@ExistUsers@")
        m_Statue="ExistUsers";


    if(message=="@zhuce@Succeed@")
        m_Statue="Succeed";

    ConnectTimer.stop();
    tcpSocket->disconnectFromHost();
    emit statueChanged(m_Statue);

}

void RegistSystem::tcpSendMessage()
{
    m_Statue="Connected";
    QString out="@zhuce@|||"+Username+"|||"+Password+"|||"+Name;
    tcpSocket->write(out.toUtf8());
    m_Statue="Waiting";
    emit statueChanged(m_Statue);
}





