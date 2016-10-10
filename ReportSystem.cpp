#include "ReportSystem.h"

#include <QFile>
#include <QTextStream>
#include <QPair>

ReportSystem::ReportSystem(QObject *parent) : QObject(parent){
    tcpSocket = new QTcpSocket(this);
    tcpSocket->connectToHost("119.29.15.43",12345);
    connect(tcpSocket,&QTcpSocket::readyRead,this,&ReportSystem::tcpReadMessage);
    connect(tcpSocket,&QTcpSocket::connected,this,&ReportSystem::tcpSendMessage);
}

ReportSystem::~ReportSystem(){

}

void ReportSystem::setStatue(QString s){
    m_Statue=s;
    emit statueChanged(m_Statue);
}

QString ReportSystem::Statue(){
    return m_Statue;
}

void ReportSystem::getalldiet(QString name)
{
    Diets.clear();
    QString out="@getalldiets@"+name;
    tcpSocket->write(out.toUtf8());
}

void ReportSystem::als_Top5()
{
    QStringList ALLFood;
    for(int i=0;i<Diets.length();i++){
        if(!Diets[i].Breakfast.isEmpty())
            ALLFood.append(Diets[i].Breakfast);
        if(!Diets[i].Lunch.isEmpty())
            ALLFood.append(Diets[i].Lunch);
        if(!Diets[i].Dinner.isEmpty())
            ALLFood.append(Diets[i].Dinner);
        if(!Diets[i].Snack.isEmpty())
            ALLFood.append(Diets[i].Snack);
        if(!Diets[i].Dessert.isEmpty())
            ALLFood.append(Diets[i].Dessert);
        if(!Diets[i].Others.isEmpty())
            ALLFood.append(Diets[i].Others);
    }


    QList<QPair<QString,int> > map;


    for(int i=0;i<ALLFood.length();i++){
        if(ALLFood[i]!="")
        {

            for(int j=0;j<map.length();j++){
                if(map[j].first==ALLFood[i])
                {
                    map[j].second+=1;
                    break;
                }

                if(j==map.length()-1){
                    QPair<QString,int> temp;
                    temp.first=ALLFood[i];
                    temp.second=1;
                    map.append(temp);
                    break;
                }
            }

            if(map.empty()){
                QPair<QString,int> temp;
                temp.first=ALLFood[i];
                temp.second=1;
                map.append(temp);
            }
        }
    }

    for(int i=0;i<map.length();i++)
        for(int j=i+1;j<map.length();j++){
            if(map[i].second<map[j].second)
            {
                QPair<QString,int> temp=map[j];
                map[j]=map[i];
                map[i]=temp;
            }
        }

    Als_Top5_Name=map[0].first+"@"+map[1].first+"@"+map[2].first+"@"+map[3].first+"@"+map[4].first;
    Als_Top5_Count=QString::number(map[0].second)+"@"+QString::number(map[1].second)+"@"+QString::number(map[2].second)+"@"+QString::number(map[3].second)+"@"+QString::number(map[4].second);



    m_Statue="als_Top5DONE";
    emit statueChanged(m_Statue);
}

QString ReportSystem::als_Top5_getCount()
{
    return Als_Top5_Count;
}

QString ReportSystem::als_Top5_getName()
{
    return Als_Top5_Name;
}





void ReportSystem::tcpReadMessage(){
    QString message =QString::fromUtf8(tcpSocket->readAll());

    if(message=="@getalldiets@DBError@")
        m_Statue="getalldietsDBError";

    if(message=="@getalldiets@FirstSucceed@")
    {
        QString out="@getuniquediets@";
        tcpSocket->write(out.toUtf8());
        return;
    }


    if(message.indexOf("@getuniquediets@Succeed@")>=0){
        QStringList inf=message.split("|||");

        Diet temp;
        temp.DateTime=inf[1];
        temp.Breakfast=inf[2].split("、");
        temp.Lunch=inf[3].split("、");
        temp.Dinner=inf[4].split("、");
        temp.Snack=inf[5].split("、");
        temp.Dessert=inf[6].split("、");
        temp.Others=inf[7].split("、");
        Diets.append(temp);

        QString out="@getuniquediets@";
        tcpSocket->write(out.toUtf8());
        return;
    }

    if(message.indexOf("@getuniquediets@NoMore@")>=0)
        m_Statue="getalldietsSucceed";



    emit statueChanged(m_Statue);
}

void ReportSystem::tcpSendMessage(){
    m_Statue="Connected";
    emit statueChanged(m_Statue);
}

