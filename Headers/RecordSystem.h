/*记录系统，包括饮食和运动*/

#ifndef RECORDSYSTEM_H
#define RECORDSYSTEM_H
#include <QObject>
#include <QtNetwork/QtNetwork>

struct Exercise{
    QString DateTime;
    QString Type;
    QString BeginTime;
    int LastTime;//min
};

class RecordSystem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString Statue READ Statue WRITE setStatue NOTIFY statueChanged)
public:
    explicit RecordSystem(QObject *parent = 0);
    ~RecordSystem();
    QTimer ConnectTimer;
    void reconnect();
public:
     QTcpSocket *tcpSocket;
     QString Username;
     QString Password;

     QString m_Statue;
     void setStatue(QString s);
     QString Statue();

     QStringList Diets;//6餐内容
     Q_INVOKABLE void getdiet(QString name,QString time);//获取特定时间的饮食数据
     Q_INVOKABLE QString getdietstr(int i);//返回某餐的数据

     QList<Exercise> Exercises;//保存运动内容
     Q_INVOKABLE void getexercise(QString name,QString time);//获取特定时间的运动内容
     Q_INVOKABLE QString getexercisetype(int i);//返回结构体的各种数据
     Q_INVOKABLE QString getexercisebegintime(int i);
     Q_INVOKABLE QString getexerciselasttime(int i);

     Q_INVOKABLE void uploaddiet(QString name,QString diet,int type);//上传饮食数据，注意diet的格式
     Q_INVOKABLE void uploadexercise(QString name,QString exercisetype,QString begintime,int lasttime);//上传运动数据


     QList<QStringList> LocalDiets;//本地已保存的今天的饮食数据
     Q_INVOKABLE void getlocaldiet();//获取内容
     Q_INVOKABLE QString getlocaldietstr(int i,int j);//获取某一餐的某一个食物
     Q_INVOKABLE void savelocaldiet(QString longstr);//保存

     QStringList DietList;
     Q_INVOKABLE void getdietlist();//获取内容
     Q_INVOKABLE QString getdietliststr(int i);//获取内容
     Q_INVOKABLE void savedietlist(QString longstr);

     QStringList SportList;
     Q_INVOKABLE void getsportlist();//获取内容
     Q_INVOKABLE QString getsportliststr(int i);//获取内容
     Q_INVOKABLE void savesportlist(QString longstr);

     Q_INVOKABLE QString getphoto(QString a);//返回大图地址，先判断有没有缓存

public:
     void tcpReadMessage();
     void tcpSendMessage();

signals:
void statueChanged(const QString& Statue);

};

#endif // RECORDSYSTEM_H
