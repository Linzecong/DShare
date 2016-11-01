#include "Headers/SendImageSystem.h"
#include "Headers/JavaMethod.h"
#include <QBuffer>
#include <QImage>
#include<QDir>
#include<QDateTime>
SendImageSystem::SendImageSystem(QObject *parent) : QObject(parent){
    loadSize=4*1024;
    totalBytes=0;
    bytesWritten=0;
    bytesToWrite=0;
    tcpSocket = new QTcpSocket(this);
    connect(tcpSocket,&QTcpSocket::connected,this,&SendImageSystem::tcpSendMessage);
    connect(tcpSocket,&QTcpSocket::readyRead,this,&SendImageSystem::tcpReadMessage);
}

void SendImageSystem::sendImage(QString name,QString id){
    bytesWritten=0;
    tcpSocket->connectToHost("119.29.15.43",1234);
    fileName=name;
    fileID=id+".jpg";
    m_Statue="Connecting";
    emit statueChanged(m_Statue);

    //用于record删除图片
#ifdef ANDROID
    QString filename=id+".jpg";
    QString tempname=id+"_temp.jpg";

        JavaMethod java;
        QDir *tempdir = new QDir;

        QString path=java.getSDCardPath();
        path=path+"/DShare/"+filename+".dbnum";

        if(tempdir->exists(path)){
            QFile::remove(path);
        }

        path=java.getSDCardPath();
        path=path+"/DShare/"+tempname+".dbnum";

        if(tempdir->exists(path)){
            QFile::remove(path);
        }

#endif


}

void SendImageSystem::sendHead(QString name,QString id){
    bytesWritten=0;
    tcpSocket->connectToHost("119.29.15.43",1235);
    fileName=name;
    fileID=id+"$$"+QDateTime::currentDateTime().toString("yyyyMMddhhmmss")+".jpg";
    m_Statue="Connecting";
    emit statueChanged(m_Statue);
}


void SendImageSystem::setStatue(QString s){
    m_Statue=s;
    emit statueChanged(m_Statue);
}

QString SendImageSystem::Statue(){
    return m_Statue;
}

void SendImageSystem::tcpReadMessage(){
    QString message =  QString::fromUtf8(tcpSocket->readAll());
    if(message=="@sendimage@DBError@")
        m_Statue="DBError";

    if(message=="@sendimage@Error@")
        m_Statue="Error";

    if(message=="@sendimage@Succeed@")
        m_Statue="Succeed";

    if(message=="@sendimage@Wait@")
        m_Statue="Wait";

    tcpSocket->disconnectFromHost();
    emit statueChanged(m_Statue);
}

void SendImageSystem::tcpSendMessage(){
    //先压缩图片
    JavaMethod java;
    QString SdcardPath=java.getSDCardPath();
    QImage img;
    img.load(fileName);
    QString nFileName=SdcardPath+"/DShare/";
    QDir *tempdir = new QDir;
    bool exist = tempdir->exists(nFileName);
    if(!exist)
        tempdir->mkdir(nFileName);

    if(img.width()>1920||img.height()>1080){
        nFileName=nFileName+"123temp.jpg";
        img.save(nFileName,"JPG",20);
        m_Statue=nFileName;
        emit statueChanged(m_Statue);
    }
    else{
        nFileName=nFileName+"123temp.jpg";
        img.save(nFileName,"JPG",50);
    }

    localFile=new QFile(nFileName);
    if(!localFile->open(QFile::ReadOnly))
    {
        qDebug()<<"openfileerror!";
        m_Statue="Error";
        emit statueChanged(m_Statue);
        //localFile->remove();
        return;

    }

    totalBytes=localFile->size();//文件总大小

    QDataStream sendOut(&outBlock,QIODevice::WriteOnly);
    sendOut.setVersion(QDataStream::Qt_4_6);
    //QString currentFileName=fileName.right(fileName.size()-fileName.lastIndexOf('/')-1);
    QString currentFileName=fileID;
    sendOut<<qint64(0)<<qint64(0)<<qint64(0)<<currentFileName;//依次写入总大小信息空间，文件名大小信息空间，文件名
    totalBytes+=outBlock.size(); //这里的总大小是文件名大小等信息和实际文件大小的总和
    sendOut.device()->seek(0);
    sendOut<<totalBytes<<qint64((outBlock.size()-sizeof(qint64)*3))<<qint64(1234); //返回outBolock的开始，用实际的大小信息代替两个qint64(0)空间
    bytesToWrite=totalBytes-tcpSocket->write(outBlock);//发送完头数据后剩余数据的大小
    bytesWritten+=outBlock.size();//已经发送数据的大小

    outBlock.resize(0);

    m_Statue="Sending...";
    emit statueChanged(m_Statue);

    while(bytesToWrite>0)//如果已经发送了数据
    {

        outBlock=localFile->read(qMin(bytesToWrite,loadSize));
        //每次发送loadSize大小的数据，这里设置为4KB，如果剩余的数据不足4KB，
        //就发送剩余数据的大小
        bytesToWrite-=(int)tcpSocket->write(outBlock);//发送完一次数据后还剩余数据的大小
        outBlock.resize(0);//清空发送缓冲区
        bytesWritten+=(int)loadSize;//已经发送数据的大小
    }
    localFile->remove();
    localFile->close();//如果没有发送任何数据，则关闭文件

}
