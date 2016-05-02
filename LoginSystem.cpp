#include "LoginSystem.h"

void LoginSystem::login(QString name, QString pass)
{
    ConnectTimer.start(1000);
    Username=name;
    Password=pass;
    tcpSocket->connectToHost("119.29.15.43",6666);
    m_Statue="Connecting";
    emit statueChanged(m_Statue);
}

LoginSystem::LoginSystem(QObject *parent) : QObject(parent)
{
    tcpSocket = new QTcpSocket(this);
    connect(tcpSocket,&QTcpSocket::readyRead,this,&LoginSystem::tcpReadMessage);
    connect(tcpSocket,&QTcpSocket::connected,this,&LoginSystem::tcpSendMessage);
    connect(&ConnectTimer,&QTimer::timeout,this,&LoginSystem::tcpTimeOut);
    m_Statue="InitOK";

}

LoginSystem::~LoginSystem(){

}

void LoginSystem::setStatue(QString s)
{
    m_Statue=s;
    emit statueChanged(m_Statue);
}

QString LoginSystem::Statue()
{
    return m_Statue;
}

void LoginSystem::tcpReadMessage()
{
    QString message =  QString::fromUtf8(tcpSocket->readAll());
    if(message=="@denglu@DBError@")
        m_Statue="DBError";


    if(message=="@denglu@WrongPassword@")
         m_Statue="WrongPassword";


    if(message=="@denglu@NoUsers@")
        m_Statue="NoUsers";


    if(message=="@denglu@Succeed@")
        m_Statue="Succeed";

    ConnectTimer.stop();
    tcpSocket->disconnectFromHost();
    emit statueChanged(m_Statue);

}

void LoginSystem::tcpSendMessage()
{
    m_Statue="Connected";
    QString out="@denglu@|||"+Username+"|||"+Password;
    tcpSocket->write(out.toUtf8());
    m_Statue="Waiting";
    emit statueChanged(m_Statue);
}

