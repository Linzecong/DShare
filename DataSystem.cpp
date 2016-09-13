#include "DataSystem.h"
#include "JavaMethod.h"

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
    tcpSocket->write(out.toUtf8());

}

QString DataSystem::getName(){
    return Name;
}

void DataSystem::changeName(QString userid, QString newname){
    QString out="@changename@|||"+userid+"|||"+newname;
    tcpSocket->write(out.toUtf8());


}

void DataSystem::addFollowing(QString userid, QString friendid){
    QString out="@addfollowing@|||"+userid+"|||"+friendid;
    tcpSocket->write(out.toUtf8());


}

void DataSystem::deleteFollowing(QString userid, QString friendid){
    QString out="@deletefollowing@|||"+userid+"|||"+friendid;
    tcpSocket->write(out.toUtf8());

}

void DataSystem::getFollowings(QString userid){
    FollowingIDList.clear();
    FollowingNameList.clear();
    QString out="@getfollowings@|||"+userid;
    tcpSocket->write(out.toUtf8());

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
    tcpSocket->write(out.toUtf8());

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

void DataSystem::searchUser(QString str){
    SearchIDList.clear();
    SearchNameList.clear();
    QString out="@searchuser@|||"+str;
    tcpSocket->write(out.toUtf8());

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

void DataSystem::checkin(QString userid){
    QString out="@checkin@"+userid;
    tcpSocket->write(out.toUtf8());
}

void DataSystem::getcheckinday(QString userid){
    QString out="@getcheckinday@"+userid;
    tcpSocket->write(out.toUtf8());
}

int DataSystem::getcheckinday(){
    return checkinday;
}

QString DataSystem::getdate(){
    return QDate::currentDate().toString("yyyy-MM-dd");
}

void DataSystem::uploadFood(QString a){
    QString out="@uploadfood@"+a;
    tcpSocket->write(out.toUtf8());
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

void DataSystem::tcpReadMessage(){
    QString message = QString::fromUtf8(tcpSocket->readAll());//获取服务器返回的信息
    if(message=="@getname@DBError@")
        m_Statue="getnameDBError";
    if(message.indexOf("@getname@Succeed@")>=0){
        Name=message.split("@").at(3);
        m_Statue="getnameSucceed";
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

    emit statueChanged(m_Statue);//传递消息
}

void DataSystem::tcpSendMessage(){
    m_Statue="InitOK";
    emit statueChanged(m_Statue);
}
