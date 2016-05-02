#include "RecordSystem.h"

RecordSystem::RecordSystem(QObject *parent) : QObject(parent)
{
    tcpSocket = new QTcpSocket(this);
    tcpSocket->connectToHost("119.29.15.43",6789);
    m_Statue="Connecting";
    emit statueChanged(m_Statue);

    connect(tcpSocket,&QTcpSocket::readyRead,this,&RecordSystem::tcpReadMessage);

    connect(tcpSocket,&QTcpSocket::connected,this,&RecordSystem::tcpSendMessage);

}

RecordSystem::~RecordSystem()
{

}

void RecordSystem::setStatue(QString s)
{
    m_Statue=s;
    emit statueChanged(m_Statue);
}

QString RecordSystem::Statue()
{
return m_Statue;
}

void RecordSystem::getdiet(QString name, QString time)
{
    Diets.clear();
    QString out="@getdiets@"+name+"@"+time;
    tcpSocket->write(out.toUtf8());
}

QString RecordSystem::getdietstr(int i)
{
    if(i<Diets.length())
        return Diets[i];
    return "";
}

void RecordSystem::getexercise(QString name, QString time)
{
    Exercises.clear();
    QString out="@getexercises@"+name+"@"+time;
    tcpSocket->write(out.toUtf8());
}

QString RecordSystem::getexercisetype(int i)
{
    if(i<Exercises.length())
        return Exercises[i].Type;
    return "";
}

QString RecordSystem::getexercisebegintime(int i)
{
    if(i<Exercises.length())
        return Exercises[i].BeginTime;
    return "";
}

QString RecordSystem::getexerciselasttime(int i)
{
    if(i<Exercises.length()){
        return QString::number(Exercises[i].LastTime/60)+"小时"+QString::number(Exercises[i].LastTime%60)+"分钟";
    }
    return "";
}

void RecordSystem::uploaddiet(QString name, QString diet, int type)
{
    QString out="@uploaddiet@"+name+"@"+diet+"@"+QString::number(type);

    tcpSocket->write(out.toUtf8());
}

void RecordSystem::uploadexercise(QString name, QString exercisetype, QString begintime, int lasttime)
{
    QString out="@uploadexercise@"+name+"@"+exercisetype+"@"+begintime+"@"+QString::number(lasttime);

    tcpSocket->write(out.toUtf8());

}




void RecordSystem::tcpReadMessage()
{
    QString message =QString::fromUtf8(tcpSocket->readAll());

    if(message=="@getdiets@DBError@")
        m_Statue="getdietsDBError";

    if(message=="@getdiets@Succeed@")
        m_Statue="getdietsSucceed";

    if(message=="@uploaddiet@DBError@")
        m_Statue="uploaddietDBError";

    if(message=="@uploaddiet@Succeed@")
        m_Statue="uploaddietSucceed";

    if(message=="@uploadexercise@DBError@")
        m_Statue="uploadexerciseDBError";

    if(message=="@uploadexercise@Succeed@")
        m_Statue="uploadexerciseSucceed";



    if(message.indexOf("@getdiets@Succeed@")>=0){
        QStringList inf=message.split("|||");
        for(int i=1;i<inf.length();i++){
            if(inf[i]=="")
                inf[i]="暂无数据";
        Diets.append(inf[i]);
        }
        m_Statue="getdietsSucceed";
    }


    if(message=="@getexercises@DBError@")
        m_Statue="getexercisesDBError";

    if(message.indexOf("@getexercises@Succeed@")>=0){
        QStringList inf=message.split("|||");
        for(int i=1;i<inf.length()-1;i++){
            QStringList tempinf=inf[i].split("{|}");
            Exercise temp;
            temp.Type=tempinf[0];
            temp.BeginTime=tempinf[1];
            temp.LastTime=tempinf[2].toInt();
            Exercises.append(temp);
        }
        m_Statue="getexercisesSucceed";
    }

    emit statueChanged(m_Statue);
}

void RecordSystem::tcpSendMessage()
{
    m_Statue="Connected";
    emit statueChanged(m_Statue);
}
