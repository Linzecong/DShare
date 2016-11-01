#include "Headers/RecordSystem.h"
#include "Headers/JavaMethod.h"
#include <QFile>
#include <QTextStream>
#include <QPixmap>
RecordSystem::RecordSystem(QObject *parent) : QObject(parent){
    tcpSocket = new QTcpSocket(this);
    tcpSocket->connectToHost("119.29.15.43",6789);
    connect(tcpSocket,&QTcpSocket::readyRead,this,&RecordSystem::tcpReadMessage);
    connect(tcpSocket,&QTcpSocket::connected,this,&RecordSystem::tcpSendMessage);
}

RecordSystem::~RecordSystem(){

}

void RecordSystem::setStatue(QString s){
    m_Statue=s;
    emit statueChanged(m_Statue);
}

QString RecordSystem::Statue(){
    return m_Statue;
}

void RecordSystem::getdiet(QString name, QString time){
    Diets.clear();
    QString out="@getdiets@"+name+"@"+time;
    tcpSocket->write(out.toUtf8());
}

QString RecordSystem::getdietstr(int i){
    if(i<Diets.length())
        return Diets[i];
    return "";
}

void RecordSystem::getexercise(QString name, QString time){
    Exercises.clear();
    QString out="@getexercises@"+name+"@"+time;
    tcpSocket->write(out.toUtf8());
}

QString RecordSystem::getexercisetype(int i){
    if(i<Exercises.length())
        return Exercises[i].Type;
    return "";
}

QString RecordSystem::getexercisebegintime(int i){
    if(i<Exercises.length())
        return Exercises[i].BeginTime;
    return "";
}

QString RecordSystem::getexerciselasttime(int i){
    if(i<Exercises.length()){
        return QString::number(Exercises[i].LastTime/60)+"小时"+QString::number(Exercises[i].LastTime%60)+"分钟";
    }
    return "";
}

void RecordSystem::uploaddiet(QString name, QString diet, int type){
    QString out="@uploaddiet@"+name+"@"+diet+"@"+QString::number(type);
    tcpSocket->write(out.toUtf8());
}

void RecordSystem::uploadexercise(QString name, QString exercisetype, QString begintime, int lasttime){
    QString out="@uploadexercise@"+name+"@"+exercisetype+"@"+begintime+"@"+QString::number(lasttime);
    tcpSocket->write(out.toUtf8());

}

void RecordSystem::getlocaldiet(){
#ifdef ANDROID
    JavaMethod java;
    QString longstr;
    QString time="asd";
    QString path=java.getSDCardPath();
    path=path+"/DShare/diet.dbnum";
    QFile LogFile;
    LogFile.setFileName(path);
    LogFile.open(QIODevice::ReadOnly);
    if(LogFile.isOpen()){
        QTextStream LogTextStream(&LogFile);
        LogTextStream>>longstr>>time;
        int maxj=0;

        m_Statue=time;
        emit statueChanged(m_Statue);

        if(time!=QString::number(QDate::currentDate().dayOfYear()))
            maxj=1000;
        QStringList temp=longstr.split("|||");
        for(int i=1;i<7;i++){
            QStringList tempnull;

            QStringList inf=temp[i].split("{|}");
            for(int j=0;j<inf.length()-1;j++){
                tempnull.append(inf[j]);
            }

            maxj=maxj>(inf.length()-1)?maxj:(inf.length()-1);
            LocalDiets.append(tempnull);
        }
        if(maxj==1000)
            m_Statue="getlocaldietSucceedOD";
        else
            m_Statue="getlocaldietSucceed";
        emit statueChanged(m_Statue);
    }
    else{
        m_Statue="getlocaldietError";
        emit statueChanged(m_Statue);
    }

#endif  
}

QString RecordSystem::getlocaldietstr(int i, int j){
    if(LocalDiets[i].length()>j){

        return LocalDiets[i][j];
    }
    else
        return "";
}

void RecordSystem::savelocaldiet(QString longstr){
#ifdef ANDROID
    JavaMethod java;

    QString path=java.getSDCardPath();

    path=path+"/DShare/diet.dbnum";

    QFile LogFile;
    QTextStream LogTextStream(&LogFile);

    LogFile.setFileName(path);
    LogFile.open(QIODevice::WriteOnly);
    if(LogFile.isOpen())
        LogTextStream<<longstr<<endl<<QDate::currentDate().dayOfYear();
#endif

}

void RecordSystem::getdietlist(){
#ifdef ANDROID
    JavaMethod java;
    QString longstr;
    QString path=java.getSDCardPath();
    path=path+"/DShare/dietlist.dbnum";
    QFile LogFile;
    LogFile.setFileName(path);
    LogFile.open(QIODevice::ReadOnly);
    if(LogFile.isOpen()){
        QTextStream LogTextStream(&LogFile);
        while(!LogTextStream.atEnd()){
            LogTextStream>>longstr;
            DietList.append(longstr);
        }

        m_Statue="getdietlistSucceed";
        emit statueChanged(m_Statue);
    }
    else{
        m_Statue="getdietlistError";
        emit statueChanged(m_Statue);
    }
#endif
}

QString RecordSystem::getdietliststr(int i){
if(DietList.length()>i){

    return DietList[i];
}
else
    return "";

}

void RecordSystem::savedietlist(QString longstr)
{
#ifdef ANDROID
    JavaMethod java;

    QString path=java.getSDCardPath();

    path=path+"/DShare/dietlist.dbnum";

    QFile LogFile;
    QTextStream LogTextStream(&LogFile);

    LogFile.setFileName(path);
    LogFile.open(QIODevice::WriteOnly);
    if(LogFile.isOpen())
        LogTextStream<<longstr;
#endif
}

void RecordSystem::getsportlist()
{
#ifdef ANDROID
    JavaMethod java;
    QString longstr;
    QString path=java.getSDCardPath();
    path=path+"/DShare/sportlist.dbnum";
    QFile LogFile;
    LogFile.setFileName(path);
    LogFile.open(QIODevice::ReadOnly);
    if(LogFile.isOpen()){
        QTextStream LogTextStream(&LogFile);
        while(!LogTextStream.atEnd()){
            LogTextStream>>longstr;
            SportList.append(longstr);
        }

        m_Statue="getsportlistSucceed";
        emit statueChanged(m_Statue);
    }
    else{
        m_Statue="getsportlistError";
        emit statueChanged(m_Statue);
    }

#endif
}

QString RecordSystem::getsportliststr(int i)
{
    if(SportList.length()>i){

        return SportList[i];
    }
    else
        return "";
}

void RecordSystem::savesportlist(QString longstr)
{
#ifdef ANDROID
    JavaMethod java;

    QString path=java.getSDCardPath();

    path=path+"/DShare/sportlist.dbnum";

    QFile LogFile;
    QTextStream LogTextStream(&LogFile);

    LogFile.setFileName(path);
    LogFile.open(QIODevice::WriteOnly);
    if(LogFile.isOpen())
        LogTextStream<<longstr;
#endif
}

QString RecordSystem::getphoto(QString a)
{
#ifdef ANDROID
        JavaMethod java;
        QDir *tempdir = new QDir;

        QString path=java.getSDCardPath();
        path=path+"/DShare/"+a+".dbnum";

        if(tempdir->exists(path)){
            return "file://"+path;
        }
        else{


            QNetworkAccessManager *manager=new QNetworkAccessManager(this);
            QEventLoop eventloop;
            connect(manager, SIGNAL(finished(QNetworkReply*)),&eventloop, SLOT(quit()));
            QNetworkReply *reply=manager->get(QNetworkRequest(QUrl("http://119.29.15.43/projectimage/"+a)));
            eventloop.exec();

            if(reply->error() == QNetworkReply::NoError)
            {
                QPixmap currentPicture;
                currentPicture.loadFromData(reply->readAll());
                currentPicture.save(path,"JPG");//保存图片
                return "file://"+path;
            }
            else
                return "";

        }
#endif
        return "";
}

void RecordSystem::tcpReadMessage(){
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

void RecordSystem::tcpSendMessage(){
    m_Statue="Connected";
    emit statueChanged(m_Statue);
}
