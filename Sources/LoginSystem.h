/*登录系统*/

#ifndef LOGINSYSTEM_H
#define LOGINSYSTEM_H
#include <QObject>
#include <QtNetwork/QtNetwork>
#include<QTimer>

class LoginSystem : public QObject{
    Q_OBJECT
    Q_PROPERTY(QString Statue READ Statue WRITE setStatue NOTIFY statueChanged)
public:
    explicit LoginSystem(QObject *parent = 0);
    ~LoginSystem();
public:
     QTcpSocket *tcpSocket;
     QString Username;
     QString Password;
     QString m_Statue;
     void setStatue(QString s);
     QString Statue();

     Q_INVOKABLE void login(QString name,QString pass);//登录
     Q_INVOKABLE QString getusername();//自动登录时用
     Q_INVOKABLE QString getpassword();
     Q_INVOKABLE void saveusernamepassword(QString username, QString pass);//自动登录，保存用户名和密码

     Q_INVOKABLE QString getisfirst();//判断是否第一次使用软件（游客登录）

     Q_INVOKABLE QString getlocalversion();//获取本地版本

     QString Version;
     Q_INVOKABLE QString getnetversion();//获取版本

     Q_INVOKABLE void savelocalversion();//获取版本

     Q_INVOKABLE void saveisfirst();


public:
     void tcpReadMessage();
     void tcpSendMessage();

signals:
void statueChanged(const QString& Statue);

};








#endif // LOGINSYSTEM_H
