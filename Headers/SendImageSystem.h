/*发送图片系统*/

#ifndef SENDIMAGESYSTEM_H
#define SENDIMAGESYSTEM_H
#include <QObject>
#include <QtNetwork/QtNetwork>
#include<QTimer>

class SendImageSystem : public QObject{
    Q_OBJECT
    Q_PROPERTY(QString Statue READ Statue WRITE setStatue NOTIFY statueChanged)
public:
    explicit SendImageSystem(QObject *parent = 0);

    QTcpSocket *tcpSocket;
    QFile* localFile;

    qint64 totalBytes;//数据总大小
    qint64 bytesWritten;//已经发送数据大小
    qint64 bytesToWrite;//剩余数据大小
    qint64 loadSize;//每次发送数据的大小
    QString fileName;//保存文件路径
    QString fileID;//保存文件标识符
    QByteArray outBlock;//数据缓冲区，即存放每次要发送的数据

    Q_INVOKABLE void sendImage(QString name,QString id);//发送图片
    Q_INVOKABLE void sendHead(QString name,QString id);//发送头像

    QString m_Statue;
    void setStatue(QString s);
    QString Statue();
public:
     void tcpReadMessage();
     void tcpSendMessage();

signals:
void statueChanged(const QString& Statue);

};

#endif // SENDIMAGESYSTEM_H
