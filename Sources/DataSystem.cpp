#include "Headers/DataSystem.h"
#include "Headers/JavaMethod.h"
#include<QPixmap>
#include<QDateTime>

DataSystem::DataSystem(QObject *parent) : QObject(parent){

    //初始化时直接连接到服务器
    tcpSocket = new QTcpSocket(this);
    connect(tcpSocket,&QTcpSocket::readyRead,this,&DataSystem::tcpReadMessage);
    connect(tcpSocket,&QTcpSocket::connected,this,&DataSystem::tcpSendMessage);
    tcpSocket->connectToHost("119.29.15.43",8889);

}

void DataSystem::setStatue(QString s){
    m_Statue=s;
    emit statueChanged(m_Statue);
}

QString DataSystem::Statue(){
    return m_Statue;
}

void DataSystem::getNameByID(QString userid){
    QString out="@getname@|||"+userid;
    m_Statue="";tcpSocket->write(out.toUtf8());

}

QString DataSystem::getName(){
    return Name;
}

void DataSystem::getHeadByID(QString userid)
{
    QString out="@gethead@|||"+userid;
    m_Statue="";tcpSocket->write(out.toUtf8());
}

QString DataSystem::getHead()
{
#ifdef ANDROID
    JavaMethod java;
    QDir *tempdir = new QDir;
    QString nnFileName=HeadURL.left(HeadURL.lastIndexOf('.'));
    nnFileName=nnFileName+"_temp.jpg";

    QString Photoname=nnFileName.right(nnFileName.size()-nnFileName.lastIndexOf('/')-1);
    QString path=java.getSDCardPath();
    path=path+"/DShare/"+Photoname+".dbnum";

    if(tempdir->exists(path)){
        return "file://"+path;
    }
    else{
        QNetworkAccessManager *manager=new QNetworkAccessManager(this);
        QEventLoop eventloop;
        connect(manager, SIGNAL(finished(QNetworkReply*)),&eventloop, SLOT(quit()));
        QNetworkReply *reply=manager->get(QNetworkRequest(QUrl(HeadURL)));
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
}



void DataSystem::changeName(QString userid, QString newname){
    QString out="@changename@|||"+userid+"|||"+newname;
    m_Statue="";tcpSocket->write(out.toUtf8());
}

void DataSystem::changePassword(QString userid, QString newpassword){
    QString out="@changepassword@|||"+userid+"|||"+newpassword;
    m_Statue="";tcpSocket->write(out.toUtf8());
}

void DataSystem::addFollowing(QString userid, QString friendid){
    QString out="@addfollowing@|||"+userid+"|||"+friendid;
    m_Statue="";tcpSocket->write(out.toUtf8());


}

void DataSystem::deleteFollowing(QString userid, QString friendid){
    QString out="@deletefollowing@|||"+userid+"|||"+friendid;
    m_Statue="";tcpSocket->write(out.toUtf8());

}

void DataSystem::getFollowings(QString userid){
    FollowingIDList.clear();
    FollowingNameList.clear();
    QString out="@getfollowings@|||"+userid;
    m_Statue="";tcpSocket->write(out.toUtf8());

}
QString DataSystem::getFollowingID(int i){
    if(i>=FollowingIDList.length()||i<0)
        return "";
    else
        return FollowingIDList[i];
}
QString DataSystem::getFollowingName(int i){
    if(i>=FollowingNameList.length()||i<0)
        return "";
    else
        return FollowingNameList[i];
}

void DataSystem::getFollowers(QString userid){
    FollowerIDList.clear();
    FollowerNameList.clear();
    QString out="@getfollowers@|||"+userid;
    m_Statue="";tcpSocket->write(out.toUtf8());

}

QString DataSystem::getFollowerID(int i){
    if(i>=FollowerIDList.length()||i<0)
        return "";
    else
        return FollowerIDList[i];
}

QString DataSystem::getFollowerName(int i){
    if(i>=FollowerNameList.length()||i<0)
        return "";
    else
        return FollowerNameList[i];
}

void DataSystem::getNotices(QString userid)
{
    NoticeSenderList.clear();
    NoticeTypeList.clear();
    NoticeTimeList.clear();
    NoticePostList.clear();
    NoticeIsReadList.clear();
    QString out="@getnotices@|||"+userid;
    m_Statue="";tcpSocket->write(out.toUtf8());
}

QString DataSystem::getNoticeSender(int i)
{
    if(i>=NoticeSenderList.length()||i<0)
        return "";
    else
        return NoticeSenderList[i];
}

QString DataSystem::getNoticeType(int i)
{
    if(i>=NoticeTypeList.length()||i<0)
        return "";
    else
        return NoticeTypeList[i];
}

QString DataSystem::getNoticeTime(int i)
{
    if(i>=NoticeTimeList.length()||i<0)
        return "";
    else
        return NoticeTimeList[i];
}

int DataSystem::getNoticePost(int i)
{
    if(i>=NoticePostList.length()||i<0)
        return 0;
    else
        return NoticePostList[i].toInt();
}

int DataSystem::getNoticeIsRead(int i)
{
    if(i>=NoticeIsReadList.length()||i<0)
        return 0;
    else
        return NoticeIsReadList[i].toInt();
}

void DataSystem::searchUser(QString str){
    SearchIDList.clear();
    SearchNameList.clear();
    QString out="@searchuser@|||"+str;
    m_Statue="";tcpSocket->write(out.toUtf8());

}

QString DataSystem::getsearchUserID(int i){
    if(i>=SearchIDList.length()||i<0)
        return "";
    else
        return SearchIDList[i];
}

QString DataSystem::getsearchUserName(int i){
    if(i>=SearchNameList.length()||i<0)
        return "";
    else
        return SearchNameList[i];
}

void DataSystem::searchFood(QString str)
{
    SearchFoodDesList.clear();
    SearchFoodNameList.clear();
    SearchFoodPhotoList.clear();
    QString out="@searchfood@|||"+str;
    m_Statue="";tcpSocket->write(out.toUtf8());
}

QString DataSystem::getsearchFoodPhoto(int i)
{
    if(i>=SearchFoodPhotoList.length()||i<0)
        return "";
    else
        return SearchFoodPhotoList[i];
}

QString DataSystem::getsearchFoodName(int i)
{
    if(i>=SearchFoodNameList.length()||i<0)
        return "";
    else
        return SearchFoodNameList[i];
}

QString DataSystem::getsearchFoodDes(int i)
{
    if(i>=SearchFoodDesList.length()||i<0)
        return "";
    else
        return SearchFoodDesList[i];
}

void DataSystem::getFoodMSG(QString str)
{
    MSGFoodPhotoList.clear();
    MSGFoodNameList.clear();
    MSGFoodDesList.clear();
    QString out="@getfoodmsg@"+str;
    m_Statue="";tcpSocket->write(out.toUtf8());
}

QString DataSystem::getMSGFoodPhoto(int i)
{
    if(i>=MSGFoodPhotoList.length()||i<0)
        return "";
    else
        return MSGFoodPhotoList[i];
}

QString DataSystem::getMSGFoodName(int i)
{
    if(i>=MSGFoodNameList.length()||i<0)
        return "";
    else
        return MSGFoodNameList[i];
}

QString DataSystem::getMSGFoodDes(int i)
{
    if(i>=MSGFoodDesList.length()||i<0)
        return "";
    else
        return MSGFoodDesList[i];
}

void DataSystem::checkin(QString userid){
    QString out="@checkin@"+userid;
    m_Statue="";tcpSocket->write(out.toUtf8());
}

void DataSystem::getcheckinday(QString userid){
    QString out="@getcheckinday@"+userid;
    m_Statue="";tcpSocket->write(out.toUtf8());
}

int DataSystem::getcheckinday(){
    return checkinday;
}

QString DataSystem::getdate(){
    return QDate::currentDate().toString("yyyy-MM-dd");
}

void DataSystem::uploadFood(QString a){
    QString out="@uploadfood@"+a;
    m_Statue="";tcpSocket->write(out.toUtf8());
}

void DataSystem::uploadExercise(QString a)
{
    QString out="@uploadExercise@"+a;
    m_Statue="";tcpSocket->write(out.toUtf8());
}

void DataSystem::delusernamepassword(){
#ifdef ANDROID
        JavaMethod java;
        QString path=java.getSDCardPath();
        path=path+"/DShare/db.dbnum";
        QFile filename;
        filename.setFileName(path);
        filename.remove();//删除
#endif
}

void DataSystem::savePhoto(QString url)
{
#ifdef ANDROID
    JavaMethod java;

    QString FileName=url.replace("file://","");


    QString SdcardPath=java.getSDCardPath();
    QString nFileName=SdcardPath+"/DSharePhoto/";
    QDir *tempdir = new QDir;
    bool exist = tempdir->exists(nFileName);
    if(!exist)
        tempdir->mkdir(nFileName);

    QFile file(FileName);
    file.open(QIODevice::ReadOnly);


    QString path=java.getSDCardPath();
    path=path+"/DSharePhoto/"+FileName.replace(SdcardPath+"/DShare/","").replace(".dbnum","");
    QFile LogFile;
    LogFile.setFileName(path);
    LogFile.open(QIODevice::WriteOnly);
    if(LogFile.isOpen()){
        LogFile.write(file.readAll());
        m_Statue="SaveSucceed";
        emit statueChanged(m_Statue);
    }
    else{
        m_Statue="SaveError";
        emit statueChanged(m_Statue);
    }


#endif
}

void DataSystem::getFoodRelation(QString foods)
{
    Reason="";
    RelationType="";
    QString out="@getfoodrelation@"+foods;
    m_Statue="";tcpSocket->write(out.toUtf8());
}

QString DataSystem::getReason()
{
    return Reason;
}

QString DataSystem::getRelationType()
{
    return RelationType;
}

void DataSystem::getFoodDetail(QString food)
{
    FoodDes="";
    QString out="@getfooddetail@"+food;
    m_Statue="";tcpSocket->write(out.toUtf8());
}

QString DataSystem::getFoodDes()
{
    return FoodDes;
}

void DataSystem::getGoodRelation(QString food)
{
    GoodReason="";
    QString out="@getgoodrelation@"+food;
    m_Statue="";tcpSocket->write(out.toUtf8());
}

QString DataSystem::getGoodReason()
{
    return GoodReason;
}

void DataSystem::getBadRelation(QString food)
{
    BadReason="";
    QString out="@getbadrelation@"+food;
    m_Statue="";tcpSocket->write(out.toUtf8());
}

QString DataSystem::getBadReason()
{
    return BadReason;
}

void DataSystem::searchFunc(QString str)
{
    FoodsFunc="";
    QString out="@searchfunc@|||"+str;
    m_Statue="";
    tcpSocket->write(out.toUtf8());
}

QString DataSystem::getsearchFunc()
{
return FoodsFunc;
}

void DataSystem::tcpReadMessage(){
    QString message = QString::fromUtf8(tcpSocket->readAll());//获取服务器返回的信息
    m_Statue="";
    if(message=="@getname@DBError@")
        m_Statue="getnameDBError";
    if(message.indexOf("@getname@Succeed@")>=0){
        Name=message.split("@").at(3);
        m_Statue="getnameSucceed";
    }


    if(message=="@gethead@DBError@")
        m_Statue="getheadDBError";
    if(message.indexOf("@gethead@Succeed@")>=0){
        HeadURL=message.split("@gethead@Succeed@").at(1);
        m_Statue="getheadSucceed";
    }

    if(message=="@checkin@DBError@")
        m_Statue="checkinDBError";
    if(message=="@checkin@Succeed@")
        m_Statue="checkinSucceed";

    if(message=="@getcheckinday@DBError@")
        m_Statue="getcheckindayDBError";

    if(message.indexOf("@getcheckinday@Succeed@")!=-1){
        QStringList inf=message.split("@");
        checkinday=inf[3].toInt();
        m_Statue="getcheckindaySucceed";
    }

    if(message=="@changename@DBError@")
        m_Statue="changenameDBError";
    if(message=="@changename@Succeed@")
        m_Statue="changenameSucceed";

    if(message=="@changepassword@DBError@")
        m_Statue="changepasswordDBError";
    if(message=="@changepassword@Succeed@")
        m_Statue="changepasswordSucceed";

    if(message=="@addfollowing@DBError@")
        m_Statue="addfollowingDBError";
    if(message=="@addfollowing@Succeed@")
        m_Statue="addfollowingSucceed";

    if(message=="@deletefollowing@DBError@")
        m_Statue="deletefollowingDBError";
    if(message=="@deletefollowing@Succeed@")
        m_Statue="deletefollowingSucceed";

    if(message=="@getfollowings@DBError@")
        m_Statue="getfollowingsDBError";
    if(message.indexOf("@getfollowings@Succeed@")>=0){
        QStringList inf=message.split("@");
        for(int i=3;i<inf.length()-1;i=i+2){
            FollowingIDList.append(inf[i]);
        FollowingNameList.append(inf[i+1]);}
        m_Statue="getfollowingsSucceed";
    }


    if(message=="@getfollowers@DBError@")
        m_Statue="getfollowersDBError";
    if(message.indexOf("@getfollowers@Succeed@")>=0){
        QStringList inf=message.split("@");
        for(int i=3;i<inf.length()-1;i=i+2){
            FollowerIDList.append(inf[i]);
        FollowerNameList.append(inf[i+1]);
        }
        m_Statue="getfollowersSucceed";
    }


    if(message=="@getnotices@DBError@")
        m_Statue="getnoticesDBError";
    if(message.indexOf("@getnotices@Succeed@")>=0){
        QStringList inf=message.split("|||");
        for(int i=1;i<inf.length()-1;i++){
            QStringList tempstr=inf[i].split("{|}");

            NoticeSenderList.append(tempstr[0]);
            NoticeTypeList.append(tempstr[1]);
            NoticeTimeList.append(tempstr[2]);
            NoticePostList.append(tempstr[3]);
            NoticeIsReadList.append(tempstr[4]);
        }
        m_Statue="getnoticesSucceed";
    }




    if(message=="@searchuser@DBError@")
        m_Statue="searchuserDBError";
    if(message.indexOf("@searchuser@Succeed@")>=0){
        QStringList inf=message.split("@");
        for(int i=3;i<inf.length()-1;i=i+2){
            SearchIDList.append(inf[i]);
            SearchNameList.append(inf[i+1]);
        }
        m_Statue="searchuserSucceed";
    }

    if(message=="@searchfood@DBError@")
        m_Statue="searchfoodDBError";
    if(message.indexOf("@searchfood@Succeed@")>=0){
        QStringList inf=message.split("@");
        for(int i=3;i<inf.length()-1;i=i+3){
            SearchFoodPhotoList.append(inf[i]);
            SearchFoodNameList.append(inf[i+1]);
            SearchFoodDesList.append(inf[i+2]);
        }
        m_Statue="searchfoodSucceed";
    }

    if(message=="@searchfunc@DBError@")
        m_Statue="searchfuncDBError";
    if(message.indexOf("@searchfunc@Succeed@")>=0){
        QStringList inf=message.split("@");

        FoodsFunc=inf[3];
        if(inf[0]=="full")
            m_Statue="searchfuncSucceedFull";
         else
        m_Statue="searchfuncSucceed";
    }



    if(message=="@getfoodmsg@DBError@")
        m_Statue="getfoodmsgDBError";
    if(message.indexOf("@getfoodmsg@Succeed@")>=0){
        QStringList inf=message.split("@");
        for(int i=3;i<inf.length()-1;i=i+3){
            MSGFoodPhotoList.append(inf[i]);
            MSGFoodNameList.append(inf[i+1]);
            MSGFoodDesList.append(inf[i+2]);
        }
        m_Statue="getfoodmsgSucceed";
    }


    if(message=="@getfoodrelation@DBError@")
        m_Statue="getfoodrelationDBError";
    if(message.indexOf("@getfoodrelation@Succeed@")>=0){
        QStringList inf=message.split("@");

        QStringList alllist=inf[3].split("{|}");

        for(int i=0;i<alllist.length()-1;i++)
        RelationType+=alllist[i].split("|||")[0]+"|||";

        for(int i=0;i<alllist.length()-1;i++)
        Reason+=alllist[i].split("|||")[1]+"|||";


        m_Statue="getfoodrelationSucceed";
    }

    if(message=="@getfooddetail@DBError@")
        m_Statue="getfooddetailDBError";
    if(message.indexOf("@getfooddetail@Succeed@")>=0){
        QStringList inf=message.split("@");
        FoodDes=inf[3];
        m_Statue="getfooddetailSucceed";
    }


    if(message=="@getgoodrelation@DBError@")
        m_Statue="getgoodrelationDBError";
    if(message.indexOf("@getgoodrelation@Succeed@")>=0){
        QStringList inf=message.split("@");
        GoodReason=inf[3];
        m_Statue="getgoodrelationSucceed";
    }

    if(message=="@getbadrelation@DBError@")
        m_Statue="getbadrelationDBError";
    if(message.indexOf("@getbadrelation@Succeed@")>=0){
        QStringList inf=message.split("@");
        BadReason=inf[3];
        m_Statue="getbadrelationSucceed";
    }

    emit statueChanged(m_Statue);//传递消息
}

void DataSystem::tcpSendMessage(){
    m_Statue="InitOK";
    emit statueChanged(m_Statue);
}
