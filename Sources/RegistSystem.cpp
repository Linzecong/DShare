#include "Headers/RegistSystem.h"
#include "Headers/JavaMethod.h"

RegistSystem::RegistSystem(QObject *parent) : QObject(parent){
    tcpSocket = new QTcpSocket(this);
    connect(tcpSocket,&QTcpSocket::readyRead,this,&RegistSystem::tcpReadMessage);
    connect(tcpSocket,&QTcpSocket::connected,this,&RegistSystem::tcpSendMessage);
}

void RegistSystem::regist(QString id, QString pass,QString name,QString sex,QString age){
    Username=id;
    Password=pass;
    Name=name;
    Sex=sex;
    Age=age;
    tcpSocket->connectToHost("139.199.197.177",5555);
    m_Statue="Connecting";
    emit statueChanged(m_Statue);
}



RegistSystem::~RegistSystem(){

}

void RegistSystem::setStatue(QString s){
    m_Statue=s;
    emit statueChanged(m_Statue);
}


QString RegistSystem::Statue(){
    return m_Statue;
}

void RegistSystem::tcpReadMessage(){
    QString message =  QString::fromUtf8(tcpSocket->readAll());

    m_Statue="";
    if(message=="@zhuce@DBError@")
        m_Statue="DBError";

    if(message=="@zhuce@ExistUsers@")
        m_Statue="ExistUsers";


    if(message=="@zhuce@Succeed@")
        m_Statue="Succeed";

    tcpSocket->disconnectFromHost();
    emit statueChanged(m_Statue);
}

void RegistSystem::tcpSendMessage(){
    m_Statue="Connected";
    QString out="@zhuce@|||"+Username+"|||"+Password+"|||"+Name+"|||"+Sex+"|||"+Age;
    tcpSocket->write(out.toUtf8());
    m_Statue="Waiting";
    emit statueChanged(m_Statue);
}





