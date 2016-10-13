#include "Headers/LoginSystem.h"
#include "Headers/JavaMethod.h"

void LoginSystem::login(QString name, QString pass){
    Username=name;
    Password=pass;
    tcpSocket->connectToHost("119.29.15.43",6666);
    m_Statue="Connecting";

}

QString LoginSystem::getusername(){
#ifdef ANDROID
    JavaMethod java;
    QString longstr;

    QString path=java.getSDCardPath();

    path=path+"/DShare/db.dbnum";

    QFile LogFile;

    LogFile.setFileName(path);
    LogFile.open(QIODevice::ReadOnly);
    if(LogFile.isOpen()){
        QTextStream LogTextStream(&LogFile);
        LogTextStream>>longstr;
        return longstr;
    }
    else{
        //生成文件夹
        QString SdcardPath=java.getSDCardPath();
        QString nFileName=SdcardPath+"/DShare/";
        QDir *tempdir = new QDir;
        bool exist = tempdir->exists(nFileName);
        if(!exist)
            tempdir->mkdir(nFileName);
        return "NO";
    }

#endif
}

QString LoginSystem::getpassword(){
#ifdef ANDROID
    JavaMethod java;
    QString longstr;

    QString path=java.getSDCardPath();

    path=path+"/DShare/db.dbnum";

    QFile LogFile;

    LogFile.setFileName(path);
    LogFile.open(QIODevice::ReadOnly);
    if(LogFile.isOpen()){
        QTextStream LogTextStream(&LogFile);
        LogTextStream>>longstr;
        LogTextStream>>longstr;
        return longstr;

    }
    else{
        return "NO";
    }
#endif
}

void LoginSystem::saveusernamepassword(QString username,QString pass){
#ifdef ANDROID
    JavaMethod java;
    QString path=java.getSDCardPath();
    path=path+"/DShare/db.dbnum";
    QFile LogFile;
    QTextStream LogTextStream(&LogFile);
    LogFile.setFileName(path);
    LogFile.open(QIODevice::WriteOnly);
    if(LogFile.isOpen())
        LogTextStream<<username<<endl<<pass;
    else{
        m_Statue="SDCardError";
        emit statueChanged(m_Statue);
    }
#endif
}

LoginSystem::LoginSystem(QObject *parent) : QObject(parent){
    tcpSocket = new QTcpSocket(this);
    connect(tcpSocket,&QTcpSocket::readyRead,this,&LoginSystem::tcpReadMessage);
    connect(tcpSocket,&QTcpSocket::connected,this,&LoginSystem::tcpSendMessage);
    m_Statue="InitOK";

}

LoginSystem::~LoginSystem(){

}

void LoginSystem::setStatue(QString s){
    m_Statue=s;
    emit statueChanged(m_Statue);
}

QString LoginSystem::Statue(){
    return m_Statue;
}

void LoginSystem::tcpReadMessage(){
    QString message =  QString::fromUtf8(tcpSocket->readAll());
    if(message=="@denglu@DBError@")
        m_Statue="DBError";

    if(message=="@denglu@WrongPassword@")
        m_Statue="WrongPassword";


    if(message=="@denglu@NoUsers@")
        m_Statue="NoUsers";

    if(message=="@denglu@Succeed@")
        m_Statue="Succeed";

    tcpSocket->disconnectFromHost();
    emit statueChanged(m_Statue);

}

void LoginSystem::tcpSendMessage(){
    m_Statue="Connected";
    QString out="@denglu@|||"+Username+"|||"+Password;
    tcpSocket->write(out.toUtf8());
    m_Statue="Waiting";

}

