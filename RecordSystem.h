#ifndef RECORDSYSTEM_H
#define RECORDSYSTEM_H

#include <QObject>
#include <QtNetwork/QtNetwork>


struct Exercise{
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


public:
     QTcpSocket *tcpSocket;
     QString Username;
     QString Password;

     QString m_Statue;
     void setStatue(QString s);
     QString Statue();

     QStringList Diets;
     Q_INVOKABLE void getdiet(QString name,QString time);
     Q_INVOKABLE QString getdietstr(int i);

     QList<Exercise> Exercises;
     Q_INVOKABLE void getexercise(QString name,QString time);
     Q_INVOKABLE QString getexercisetype(int i);
     Q_INVOKABLE QString getexercisebegintime(int i);
     Q_INVOKABLE QString getexerciselasttime(int i);

     Q_INVOKABLE void uploaddiet(QString name,QString diet,int type);
     Q_INVOKABLE void uploadexercise(QString name,QString exercisetype,QString begintime,int lasttime);



public:
     void tcpReadMessage();
     void tcpSendMessage();



signals:

void statueChanged(const QString& Statue);
public slots:
};

#endif // RECORDSYSTEM_H
