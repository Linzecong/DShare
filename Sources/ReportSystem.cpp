#include "Headers/ReportSystem.h"
#include "Headers/DataSystem.h"
#include <QFile>
#include <QTextStream>
#include <QPair>



ReportSystem::ReportSystem(QObject *parent) : QObject(parent){
    tcpSocket = new QTcpSocket(this);
    tcpSocket->connectToHost("119.29.15.43",12345);
    connect(tcpSocket,&QTcpSocket::readyRead,this,&ReportSystem::tcpReadMessage);
    connect(tcpSocket,&QTcpSocket::connected,this,&ReportSystem::tcpSendMessage);
    initMap();
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
    m_Statue="";tcpSocket->write(out.toUtf8());
}

void ReportSystem::getallexercise(QString name)
{
    Exercises.clear();
    QString out="@getallexercises@"+name;
    m_Statue="";tcpSocket->write(out.toUtf8());
}

void ReportSystem::als_Top5(int type)
{
    QStringList ALLFood;
    for(int i=0;i<Diets.length();i++){

        if(type==0||type==1)
            if(!Diets[i].Breakfast.isEmpty())
                ALLFood.append(Diets[i].Breakfast);

        if(type==0||type==2)
            if(!Diets[i].Lunch.isEmpty())
                ALLFood.append(Diets[i].Lunch);

        if(type==0||type==3)
            if(!Diets[i].Dinner.isEmpty())
                ALLFood.append(Diets[i].Dinner);

        if(type==0||type==4)
            if(!Diets[i].Snack.isEmpty())
                ALLFood.append(Diets[i].Snack);

        if(type==0||type==5)
            if(!Diets[i].Dessert.isEmpty())
                ALLFood.append(Diets[i].Dessert);

        if(type==0||type==6)
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
    Als_Top5_Name="";
    Als_Top5_Count="";
    for(int i=0;i<map.length();i++){

        Als_Top5_Name+=map[i].first;

        Als_Top5_Count+=QString::number(map[i].second);

        if(i!=4){
            Als_Top5_Name+="@";
            Als_Top5_Count+="@";
        }

        if(i==4)
            break;
    }

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




void ReportSystem::als_Time(int type)
{

    QString fir,sec,thr;

    //0，最近10天，每天一格
    //1，最近30天，每3天一格
    //2，最近60天，每6天一格
    //3，最近90天，每9天一格
    //4，最近半年,每18天一格
    //5，最近一年，每36天一格
    int fnum[10]={0,0,0,0,0,0,0,0,0,0};
    int snum[10]={0,0,0,0,0,0,0,0,0,0};
    int tnum[10]={0,0,0,0,0,0,0,0,0,0};
    QDate currentDate=QDate::currentDate();
    if(type==0){
        QList<QPair<QString,int> > map=getTop3FoodName(9);
        if(map.length()<3){
            Als_Time_Count="";
            Als_Time_Name="";
            m_Statue="als_TimeError";
            emit statueChanged(m_Statue);
            return;
        }
        fir=map[0].first;
        sec=map[1].first;
        thr=map[2].first;
        Als_Time_FoodName=fir+"@"+sec+"@"+thr;
        getTop3FoodCount(9,fnum,snum,tnum,fir,sec,thr);
    }

    if(type==1){
        QList<QPair<QString,int> > map=getTop3FoodName(29);
        if(map.length()<3){
            Als_Time_Count="";
            Als_Time_Name="";
            m_Statue="als_TimeError";
            emit statueChanged(m_Statue);
            return;
        }
        fir=map[0].first;
        sec=map[1].first;
        thr=map[2].first;
        Als_Time_FoodName=fir+"@"+sec+"@"+thr;
        getTop3FoodCount(29,fnum,snum,tnum,fir,sec,thr);
    }

    if(type==2){
        QList<QPair<QString,int> > map=getTop3FoodName(59);
        if(map.length()<3){
            Als_Time_Count="";
            Als_Time_Name="";
            m_Statue="als_TimeError";
            emit statueChanged(m_Statue);
            return;
        }
        fir=map[0].first;
        sec=map[1].first;
        thr=map[2].first;
        Als_Time_FoodName=fir+"@"+sec+"@"+thr;
        getTop3FoodCount(59,fnum,snum,tnum,fir,sec,thr);
    }

    if(type==3){
        QList<QPair<QString,int> > map=getTop3FoodName(89);
        if(map.length()<3){
            Als_Time_Count="";
            Als_Time_Name="";
            m_Statue="als_TimeError";
            emit statueChanged(m_Statue);
            return;
        }
        fir=map[0].first;
        sec=map[1].first;
        thr=map[2].first;
        Als_Time_FoodName=fir+"@"+sec+"@"+thr;
        getTop3FoodCount(89,fnum,snum,tnum,fir,sec,thr);
    }

    if(type==4){
        QList<QPair<QString,int> > map=getTop3FoodName(179);
        if(map.length()<3){
            Als_Time_Count="";
            Als_Time_Name="";
            m_Statue="als_TimeError";
            emit statueChanged(m_Statue);
            return;
        }
        fir=map[0].first;
        sec=map[1].first;
        thr=map[2].first;
        Als_Time_FoodName=fir+"@"+sec+"@"+thr;
        getTop3FoodCount(179,fnum,snum,tnum,fir,sec,thr);
    }

    if(type==5){
        QList<QPair<QString,int> > map=getTop3FoodName(359);
        if(map.length()<3){
            Als_Time_Count="";
            Als_Time_Name="";
            m_Statue="als_TimeError";
            emit statueChanged(m_Statue);
            return;
        }
        fir=map[0].first;
        sec=map[1].first;
        thr=map[2].first;
        Als_Time_FoodName=fir+"@"+sec+"@"+thr;
        getTop3FoodCount(359,fnum,snum,tnum,fir,sec,thr);
    }



    Als_Time_Count="";
    for(int i=0;i<10;i++){
        Als_Time_Count+=QString::number(fnum[9-i]);
        if(i!=9)
            Als_Time_Count+="@";
    }
    Als_Time_Count+="|||";
    for(int i=0;i<10;i++){
        Als_Time_Count+=QString::number(snum[9-i]);
        if(i!=9)
            Als_Time_Count+="@";
    }
    Als_Time_Count+="|||";
    for(int i=0;i<10;i++){
        Als_Time_Count+=QString::number(tnum[9-i]);
        if(i!=9)
            Als_Time_Count+="@";
    }


    Als_Time_Name="";
    if(type==0)for(int i=0;i<10;i++){
        Als_Time_Name+=currentDate.addDays(i-9).toString("MM-dd");
        if(i!=9)
            Als_Time_Name+="@";
    }

    if(type==1)for(int i=0;i<10;i++){
        Als_Time_Name+=currentDate.addDays((3*i)+2-29).toString("MM-dd");
        if(i!=9)
            Als_Time_Name+="@";
    }

    if(type==2)for(int i=0;i<10;i++){
        Als_Time_Name+=currentDate.addDays((6*i)+5-59).toString("MM-dd");
        if(i!=9)
            Als_Time_Name+="@";
    }

    if(type==3)for(int i=0;i<10;i++){
        Als_Time_Name+=currentDate.addDays((9*i)+8-89).toString("MM-dd");
        if(i!=9)
            Als_Time_Name+="@";
    }

    if(type==4)for(int i=0;i<10;i++){
        Als_Time_Name+=currentDate.addDays((18*i)+17-179).toString("MM-dd");
        if(i!=9)
            Als_Time_Name+="@";
    }

    if(type==5)for(int i=0;i<10;i++){
        Als_Time_Name+=currentDate.addDays((36*i)+35-359).toString("MM-dd");
        if(i!=9)
            Als_Time_Name+="@";
    }



    m_Statue="als_TimeDONE";

    emit statueChanged(m_Statue);
}

QString ReportSystem::als_Time_getCount()
{
    return Als_Time_Count;
}

QString ReportSystem::als_Time_getName()
{
    return Als_Time_Name;
}

QString ReportSystem::als_Time_getFoodName()
{
    return Als_Time_FoodName;
}

QList<QPair<QString,int> > ReportSystem::getTop3FoodName(int days,int sort)
{
    QDate currentDate=QDate::currentDate();
    QStringList ALLFood;
    for(int i=0;i<Diets.length();i++){
        QDate dietDate=QDate::fromString(Diets[i].DateTime,"yyyy-MM-dd");
        int day=dietDate.daysTo(currentDate);
        if(day>=0&&day<=days){
            if(!Diets[i].Breakfast.isEmpty())ALLFood.append(Diets[i].Breakfast);
            if(!Diets[i].Lunch.isEmpty())ALLFood.append(Diets[i].Lunch);
            if(!Diets[i].Dinner.isEmpty())ALLFood.append(Diets[i].Dinner);
            if(!Diets[i].Snack.isEmpty())ALLFood.append(Diets[i].Snack);
            if(!Diets[i].Dessert.isEmpty())ALLFood.append(Diets[i].Dessert);
            if(!Diets[i].Others.isEmpty())ALLFood.append(Diets[i].Others);
        }
    }

    QList<QPair<QString,int> > map;

    for(int i=0;i<ALLFood.length();i++){
        if(ALLFood[i]!=""){
            for(int j=0;j<map.length();j++){
                if(map[j].first==ALLFood[i]){
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

    if(sort)
        for(int i=0;i<map.length();i++)
            for(int j=i+1;j<map.length();j++){
                if(map[i].second<map[j].second){
                    QPair<QString,int> temp=map[j];
                    map[j]=map[i];
                    map[i]=temp;
                }
            }

    return map;
}

void ReportSystem::getTop3FoodCount(int days, int *fnum, int *snum, int *tnum,QString fir,QString sec,QString thr){
    QDate currentDate=QDate::currentDate();
    for(int i=0;i<Diets.length();i++){

        QDate dietDate=QDate::fromString(Diets[i].DateTime,"yyyy-MM-dd");
        int day=dietDate.daysTo(currentDate);
        if(day>=0&&day<=days){

            if(days==29){
                if(day>=0&&day<=2)day=0;
                if(day>=3&&day<=5)day=1;
                if(day>=6&&day<=8)day=2;
                if(day>=9&&day<=11)day=3;
                if(day>=12&&day<=14)day=4;
                if(day>=15&&day<=17)day=5;
                if(day>=18&&day<=20)day=6;
                if(day>=21&&day<=23)day=7;
                if(day>=24&&day<=26)day=8;
                if(day>=27&&day<=29)day=9;
            }

            if(days==59){
                if(day>=0&&day<=5)day=0;
                if(day>=6&&day<=11)day=1;
                if(day>=12&&day<=17)day=2;
                if(day>=18&&day<=23)day=3;
                if(day>=24&&day<=29)day=4;
                if(day>=30&&day<=35)day=5;
                if(day>=36&&day<=41)day=6;
                if(day>=42&&day<=47)day=7;
                if(day>=48&&day<=53)day=8;
                if(day>=54&&day<=59)day=9;
            }

            if(days==89){
                if(day>=0&&day<=8)day=0;
                if(day>=9&&day<=17)day=1;
                if(day>=18&&day<=26)day=2;
                if(day>=27&&day<=35)day=3;
                if(day>=36&&day<=44)day=4;
                if(day>=45&&day<=53)day=5;
                if(day>=54&&day<=62)day=6;
                if(day>=63&&day<=71)day=7;
                if(day>=72&&day<=80)day=8;
                if(day>=81&&day<=89)day=9;
            }

            if(days==179){
                if(day>=0&&day<=17)day=0;
                if(day>=18&&day<=35)day=1;
                if(day>=36&&day<=53)day=2;
                if(day>=54&&day<=71)day=3;
                if(day>=72&&day<=89)day=4;
                if(day>=90&&day<=107)day=5;
                if(day>=108&&day<=125)day=6;
                if(day>=126&&day<=143)day=7;
                if(day>=144&&day<=161)day=8;
                if(day>=162&&day<=179)day=9;
            }

            if(days==359){
                if(day>=0&&day<=35)day=0;
                if(day>=36&&day<=71)day=1;
                if(day>=72&&day<=107)day=2;
                if(day>=108&&day<=143)day=3;
                if(day>=144&&day<=179)day=4;
                if(day>=180&&day<=215)day=5;
                if(day>=216&&day<=251)day=6;
                if(day>=252&&day<=287)day=7;
                if(day>=288&&day<=323)day=8;
                if(day>=324&&day<=359)day=9;
            }


            for(int j=0;j<Diets[i].Breakfast.length();j++){
                if(Diets[i].Breakfast[j]==fir)
                    fnum[day]++;
                if(Diets[i].Breakfast[j]==sec)
                    snum[day]++;
                if(Diets[i].Breakfast[j]==thr)
                    tnum[day]++;
            }

            for(int j=0;j<Diets[i].Lunch.length();j++){
                if(Diets[i].Lunch[j]==fir)
                    fnum[day]++;
                if(Diets[i].Lunch[j]==sec)
                    snum[day]++;
                if(Diets[i].Lunch[j]==thr)
                    tnum[day]++;
            }
            for(int j=0;j<Diets[i].Dinner.length();j++){
                if(Diets[i].Dinner[j]==fir)
                    fnum[day]++;
                if(Diets[i].Dinner[j]==sec)
                    snum[day]++;
                if(Diets[i].Dinner[j]==thr)
                    tnum[day]++;
            }
            for(int j=0;j<Diets[i].Snack.length();j++){
                if(Diets[i].Snack[j]==fir)
                    fnum[day]++;
                if(Diets[i].Snack[j]==sec)
                    snum[day]++;
                if(Diets[i].Snack[j]==thr)
                    tnum[day]++;
            }
            for(int j=0;j<Diets[i].Dessert.length();j++){
                if(Diets[i].Dessert[j]==fir)
                    fnum[day]++;
                if(Diets[i].Dessert[j]==sec)
                    snum[day]++;
                if(Diets[i].Dessert[j]==thr)
                    tnum[day]++;
            }
            for(int j=0;j<Diets[i].Others.length();j++){
                if(Diets[i].Others[j]==fir)
                    fnum[day]++;
                if(Diets[i].Others[j]==sec)
                    snum[day]++;
                if(Diets[i].Others[j]==thr)
                    tnum[day]++;
            }
        }
    }
}

void ReportSystem::als_Type(int type, int days)
{

    if(days==0)days=9;
    if(days==1)days=29;
    if(days==2)days=59;
    if(days==3)days=89;
    if(days==4)days=179;
    if(days==5)days=359;

    QList<QPair<QString,int> > map=getTop3FoodName(days,0);

    int num[6]={0,0,0,0,0,0};
    if(type==0){
        for(int i=0;i<map.length();i++){
            num[XZMap[map[i].first]]+=map[i].second;
        }
    }

    if(type==1){
        for(int i=0;i<map.length();i++){
            num[YYMap[map[i].first]]+=map[i].second;
        }
    }

    if(type==2){
        for(int i=0;i<map.length();i++){
            num[YLMap[map[i].first]]+=map[i].second;
        }
    }

    Als_Type_Count="";
    for(int i=1;i<=5;i++){
        Als_Type_Count+=QString::number(num[i]);
        if(i!=5)
            Als_Type_Count+="@";
    }

    m_Statue="als_TypeDONE";
    emit statueChanged(m_Statue);

}


QString ReportSystem::als_Type_getCount(){
    return Als_Type_Count;
}

void ReportSystem::als_Time_Exe(int type)
{
    QDate currentDate=QDate::currentDate();

    int num[10]={0,0,0,0,0,0,0,0,0,0};

    int days=9;
    if(type==0)days=9;
    if(type==1)days=29;
    if(type==2)days=59;
    if(type==3)days=89;
    if(type==4)days=179;
    if(type==5)days=359;



    for(int i=0;i<Exercises.length();i++)
    {
        int day=QDate::fromString(Exercises[i].DateTime,"yyyy-MM-dd").daysTo(currentDate);

        if(day>=0&&day<=days){

            if(days==29){
                if(day>=0&&day<=2)day=0;
                if(day>=3&&day<=5)day=1;
                if(day>=6&&day<=8)day=2;
                if(day>=9&&day<=11)day=3;
                if(day>=12&&day<=14)day=4;
                if(day>=15&&day<=17)day=5;
                if(day>=18&&day<=20)day=6;
                if(day>=21&&day<=23)day=7;
                if(day>=24&&day<=26)day=8;
                if(day>=27&&day<=29)day=9;
            }

            if(days==59){
                if(day>=0&&day<=5)day=0;
                if(day>=6&&day<=11)day=1;
                if(day>=12&&day<=17)day=2;
                if(day>=18&&day<=23)day=3;
                if(day>=24&&day<=29)day=4;
                if(day>=30&&day<=35)day=5;
                if(day>=36&&day<=41)day=6;
                if(day>=42&&day<=47)day=7;
                if(day>=48&&day<=53)day=8;
                if(day>=54&&day<=59)day=9;
            }

            if(days==89){
                if(day>=0&&day<=8)day=0;
                if(day>=9&&day<=17)day=1;
                if(day>=18&&day<=26)day=2;
                if(day>=27&&day<=35)day=3;
                if(day>=36&&day<=44)day=4;
                if(day>=45&&day<=53)day=5;
                if(day>=54&&day<=62)day=6;
                if(day>=63&&day<=71)day=7;
                if(day>=72&&day<=80)day=8;
                if(day>=81&&day<=89)day=9;
            }

            if(days==179){
                if(day>=0&&day<=17)day=0;
                if(day>=18&&day<=35)day=1;
                if(day>=36&&day<=53)day=2;
                if(day>=54&&day<=71)day=3;
                if(day>=72&&day<=89)day=4;
                if(day>=90&&day<=107)day=5;
                if(day>=108&&day<=125)day=6;
                if(day>=126&&day<=143)day=7;
                if(day>=144&&day<=161)day=8;
                if(day>=162&&day<=179)day=9;
            }

            if(days==359){
                if(day>=0&&day<=35)day=0;
                if(day>=36&&day<=71)day=1;
                if(day>=72&&day<=107)day=2;
                if(day>=108&&day<=143)day=3;
                if(day>=144&&day<=179)day=4;
                if(day>=180&&day<=215)day=5;
                if(day>=216&&day<=251)day=6;
                if(day>=252&&day<=287)day=7;
                if(day>=288&&day<=323)day=8;
                if(day>=324&&day<=359)day=9;
            }

            num[day]+=Exercises[i].LastTime;
        }
    }

    Als_Time_Count_Exe="";
    for(int i=0;i<10;i++){
        Als_Time_Count_Exe+=QString::number(num[9-i]);
        if(i!=9)
            Als_Time_Count_Exe+="@";
    }


    Als_Time_Name_Exe="";
    if(type==0)for(int i=0;i<10;i++){
        Als_Time_Name_Exe+=currentDate.addDays(i-9).toString("MM-dd");
        if(i!=9)
            Als_Time_Name_Exe+="@";
    }

    if(type==1)for(int i=0;i<10;i++){
        Als_Time_Name_Exe+=currentDate.addDays((3*i)+2-29).toString("MM-dd");
        if(i!=9)
            Als_Time_Name_Exe+="@";
    }

    if(type==2)for(int i=0;i<10;i++){
        Als_Time_Name_Exe+=currentDate.addDays((6*i)+5-59).toString("MM-dd");
        if(i!=9)
            Als_Time_Name_Exe+="@";
    }

    if(type==3)for(int i=0;i<10;i++){
        Als_Time_Name_Exe+=currentDate.addDays((9*i)+8-89).toString("MM-dd");
        if(i!=9)
            Als_Time_Name_Exe+="@";
    }

    if(type==4)for(int i=0;i<10;i++){
        Als_Time_Name_Exe+=currentDate.addDays((18*i)+17-179).toString("MM-dd");
        if(i!=9)
            Als_Time_Name_Exe+="@";
    }

    if(type==5)for(int i=0;i<10;i++){
        Als_Time_Name_Exe+=currentDate.addDays((36*i)+35-359).toString("MM-dd");
        if(i!=9)
            Als_Time_Name_Exe+="@";
    }



    m_Statue="als_Time_ExeDONE";

    emit statueChanged(m_Statue);


}

QString ReportSystem::als_Time_Exe_getCount()
{
    return Als_Time_Count_Exe;
}

QString ReportSystem::als_Time_Exe_getName()
{
    return Als_Time_Name_Exe;
}








void ReportSystem::tcpReadMessage(){
    QString message =QString::fromUtf8(tcpSocket->readAll());

    if(message=="@getalldiets@DBError@")
        m_Statue="getalldietsDBError";

    if(message=="@getalldiets@FirstSucceed@")
    {
        QString out="@getuniquediets@";
        m_Statue="";tcpSocket->write(out.toUtf8());
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
        m_Statue="";tcpSocket->write(out.toUtf8());
        return;
    }

    if(message.indexOf("@getuniquediets@NoMore@")>=0)
        m_Statue="getalldietsSucceed";








    if(message=="@getallexercises@DBError@")
        m_Statue="getallexercisesDBError";

    if(message=="@getallexercises@FirstSucceed@")
    {
        QString out="@getuniqueexercises@";
        m_Statue="";tcpSocket->write(out.toUtf8());
        return;
    }


    if(message.indexOf("@getuniqueexercises@Succeed@")>=0){
        QStringList inf=message.split("|||");

        Exercise temp;
        temp.DateTime=inf[1];
        temp.Type=inf[2];
        temp.LastTime=inf[3].toInt();

        Exercises.append(temp);

        QString out="@getuniqueexercises@";
        m_Statue="";tcpSocket->write(out.toUtf8());
        return;
    }

    if(message.indexOf("@getuniqueexercises@NoMore@")>=0)
        m_Statue="getallexercisesSucceed";



    emit statueChanged(m_Statue);
}

void ReportSystem::tcpSendMessage(){
    m_Statue="Connected";
    emit statueChanged(m_Statue);
}

