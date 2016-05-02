#ifndef SYSTEM_H
#define SYSTEM_H
#include<QString>
#include<QStringList>
#include <QtNetwork/QtNetwork>
#include<QMessageBox>
#include<QTimer>

#include"User.h"
#include"Core.h"
#include"Post.h"
//#include"Record.h"
//#include"News.h"



class UserSystem:public QObject{
public:
    QString Username;
    QString Password;
    MainUser* User;

    QTcpSocket *tcpSocket;
    QTimer ConnectTimer;

    void setError(){Error=ConnentionFail;}
    void setOK(){Error=OK;}
    void tcpReadMessage();
    void tcpTimeOut(){
        static int i=0;
        if(i++==10){
            Error=ConnentionFail;
            tcpSocket->disconnectFromHost();
            ConnectTimer.stop();
            i=0;
        }
    }

public:
    UserSystem(QString user, QString pass, MainUser *us);
    ~UserSystem(){}
public:
    enum ErrorType{NoUser,ConnentionFail,OK,Connecting}Error;
public: 

    bool getData();

    MainUser* getUser();


    bool upDatePostCollections();
    // void upDateNewsCollections();


};

UserSystem::UserSystem(QString user, QString pass,MainUser* us){
    Username=user;
    Password=pass;
    User=us;
    tcpSocket = new QTcpSocket;
    QObject::connect(tcpSocket,&QTcpSocket::readyRead,this,&UserSystem::tcpReadMessage);
    QObject::connect(tcpSocket,&QTcpSocket::connected,this,&UserSystem::setOK);
    QObject::connect(&ConnectTimer,&QTimer::timeout,this,&UserSystem::tcpTimeOut);
    tcpSocket->connectToHost("119.29.15.43",8520);
    // tcpSocket->connectToHost(QHostAddress::LocalHost,8520);
    Error=Connecting;
}

bool UserSystem::getData(){
    if(Error==OK){
        QString out="@getmainuser@|||"+Username+"|||"+Password;
        tcpSocket->write(out.toUtf8());
        QMessageBox::information(NULL,"...","...");
        ConnectTimer.start(1000);
        Error=Connecting;
        return true;
    }
    else
        return false;

}

bool UserSystem::upDatePostCollections(){
    if(Error==OK){
        QString out="@updatepostcollections@|||"+Username+"|||"+Password+"|||"+QString::number(User->PostCollections.last());
        tcpSocket->write(out.toUtf8());
        ConnectTimer.start(1000);
        Error=Connecting;
        return true;
    }
    else
        return false;
}


void UserSystem::tcpReadMessage(){
    ConnectTimer.stop();
    QString message =  QString::fromUtf8(tcpSocket->readAll());
    if(message=="@getmainuser@DBError@"){
        Error=ConnentionFail;

        return;
    }

    if(message=="@updatepostcollections@OK@"){
        Error=OK;

        return;
    }
    if(message=="@updatepostcollections@DBError@"){
        Error=ConnentionFail;

        return;
    }


    if(message.indexOf("@getmainuser@OK@")>=0){
        Error=OK;
        QStringList inf=message.split("@");
        User->ID=inf[3].toInt();
        User->Name=inf[4];
        User->Des=inf[5];
        User->Sex=inf[6].toInt();
        User->Age=inf[7].toInt();
        User->Home.Country=inf[8];
        User->Home.Province=inf[9];
        User->Home.City=inf[10];
        User->IsShowPosts=inf[11].toInt();
        User->Username=Username;
        User->Password=Password;

        return;
    }


}








class PostSystem:public QObject{
private:
    QString Username;
    QString Password;

    int PostListType;//0首页,1个人
    QTcpSocket *tcpSocket;
    QTimer ConnectTimer;

    void setError(){Error=ConnentionFail;}
    void setOK(){Error=OK;}
    void tcpTimeOut(){
        static int i=0;
        if(i++==10){
            Error=ConnentionFail;
            tcpSocket->disconnectFromHost();
            ConnectTimer.stop();
            i=0;
        }
    }

    int NowCount;

    void tcpReadMessage();
public:
    PostSystem(QString user, QList<Post>* list, QString pass);
    ~PostSystem(){}
public:
    QList<Post>* PostList;
    enum ErrorType{ConnentionFail,OK,Connecting}Error;

    bool getMorePosts();//1有更多
    bool reflashPosts();//1成功

};


bool PostSystem::reflashPosts(){
    if(Error==OK){
    if(PostListType){
        QString out="@getpersonalposts@|||"+Username;
        tcpSocket->write(out.toUtf8());
        QMessageBox::information(NULL,"...","...");
        ConnectTimer.start(1000);
        Error=Connecting;
    }
    else{
        QString out="@getfriendsposts@|||"+Username+"|||"+Password;
        tcpSocket->write(out.toUtf8());
        QMessageBox::information(NULL,"...","...");
        ConnectTimer.start(1000);
        Error=Connecting;
    }
    return true;
    }
    else
        return false;
}

void PostSystem::tcpReadMessage(){
    QMessageBox::information(NULL,"...","...");
    ConnectTimer.stop();
    QString message =  QString::fromUtf8(tcpSocket->readAll());
    if(message=="@getfriendsposts@DBError@"){
        Error=ConnentionFail;
        return;
    }

    if(message=="@getmorefriendsposts@DBError@"){
        Error=ConnentionFail;
        return;
    }

    if(message.indexOf("{|}getfriendsposts{|}Geting{|}")>=0){
        QStringList inf=message.split("{|}");
        Post temp;
        temp.ID=inf[3].toDouble();
        temp.Publisher=inf[4];
        temp.PostTime=Time::fromString(inf[5]);
        temp.Message=inf[6];

        Comment tempCom;
        QStringList infCom=inf[7].split("{:}");
        tempCom.ID=infCom[0].toDouble();
        tempCom.Message=infCom[1];
        tempCom.Commentator=infCom[2];
        tempCom.CommentatorID=infCom[3].toDouble();
        tempCom.CommentTime=Time::fromString(infCom[4]);
        if(tempCom.ID!=0)
        temp.Comments.append(tempCom);

        infCom=inf[8].split("{:}");
        tempCom.ID=infCom[0].toDouble();
        tempCom.Message=infCom[1];
        tempCom.Commentator=infCom[2];
        tempCom.CommentatorID=infCom[3].toDouble();
        tempCom.CommentTime=Time::fromString(infCom[4]);
        if(tempCom.ID!=0)
        temp.Comments.append(tempCom);

        infCom=inf[9].split("{:}");
        tempCom.ID=infCom[0].toDouble();
        tempCom.Message=infCom[1];
        tempCom.Commentator=infCom[2];
        tempCom.CommentatorID=infCom[3].toDouble();
        tempCom.CommentTime=Time::fromString(infCom[4]);
        if(tempCom.ID!=0)
        temp.Comments.append(tempCom);

        temp.LikersString=inf[10];
        temp.HasImage=inf[11].toInt();


        PostList->append(temp);
        NowCount++;
        return;
    }

    if(message.indexOf("{|}getfriendsposts{|}Done{|}")>=0){
        Error=OK;
        return;
    }


    if(message.indexOf("{|}getmorefriendsposts{|}Geting{|}")>=0){
        QStringList inf=message.split("{|}");
        Post temp;
        temp.ID=inf[3].toDouble();
        temp.Publisher=inf[4];
        temp.PostTime=Time::fromString(inf[5]);
        temp.Message=inf[6];

        Comment tempCom;
        QStringList infCom=inf[7].split("{:}");
        tempCom.ID=infCom[0].toDouble();
        tempCom.Message=infCom[1];
        tempCom.Commentator=infCom[2];
        tempCom.CommentatorID=infCom[3].toDouble();
        tempCom.CommentTime=Time::fromString(infCom[4]);
        temp.Comments.append(tempCom);

        infCom=inf[8].split("{:}");
        tempCom.ID=infCom[0].toDouble();
        tempCom.Message=infCom[1];
        tempCom.Commentator=infCom[2];
        tempCom.CommentatorID=infCom[3].toDouble();
        tempCom.CommentTime=Time::fromString(infCom[4]);
        temp.Comments.append(tempCom);

        infCom=inf[9].split("{:}");
        tempCom.ID=infCom[0].toDouble();
        tempCom.Message=infCom[1];
        tempCom.Commentator=infCom[2];
        tempCom.CommentatorID=infCom[3].toDouble();
        tempCom.CommentTime=Time::fromString(infCom[4]);
        temp.Comments.append(tempCom);

        temp.LikersString=inf[10];
        temp.HasImage=inf[11].toInt();


        PostList->append(temp);
        NowCount++;
        return;
    }

    if(message.indexOf("{|}getmorefriendsposts{|}Done{|}")>=0){
        Error=OK;
        return;
    }

}

PostSystem::PostSystem(QString user, QList<Post> *list,QString pass=""){
    NowCount=0;
    Username=user;
    Password=pass;
    PostList=list;
    Password==""?PostListType=1:PostListType=0;

    tcpSocket = new QTcpSocket;
    QObject::connect(tcpSocket,&QTcpSocket::readyRead,this,&PostSystem::tcpReadMessage);
    QObject::connect(tcpSocket,&QTcpSocket::connected,this,&PostSystem::setOK);
    QObject::connect(&ConnectTimer,&QTimer::timeout,this,&PostSystem::tcpTimeOut);
    tcpSocket->connectToHost("119.29.15.43",8520);
    // tcpSocket->connectToHost(QHostAddress::LocalHost,8520);
    Error=Connecting;
}

bool PostSystem::getMorePosts(){
    if(Error==OK){
    if(PostListType){
        QString out="@getmorepersonalposts@|||"+Username+"|||"+QString::number(NowCount);
        tcpSocket->write(out.toUtf8());
        QMessageBox::information(NULL,"...","...");
        ConnectTimer.start(1000);
        Error=Connecting;
    }
    else{
        QString out="@getmorefriendsposts@|||"+Username+"|||"+Password+"|||"+QString::number(NowCount);
        tcpSocket->write(out.toUtf8());
        QMessageBox::information(NULL,"...","...");
        ConnectTimer.start(1000);
        Error=Connecting;
    }
    return true;
    }
    else
        return false;
}








class UniquePostSystem:public QObject{
private:
    QTcpSocket *tcpSocket;
    QTimer ConnectTimer;

    void setError(){Error=ConnentionFail;}
    void setOK(){Error=OK;}
    void tcpTimeOut(){
        static int i=0;
        if(i++==10){
            Error=ConnentionFail;
            tcpSocket->disconnectFromHost();
            ConnectTimer.stop();
            i=0;
        }
    }

    void tcpReadMessage();


public:
    UniquePostSystem(Post* p);
    ~UniquePostSystem(){}
public:
    Post* UniquePost;
    enum ErrorType{ConnentionFail,OK,Connecting}Error;

    bool updataLikers();
    bool updataComments();
};

void UniquePostSystem::tcpReadMessage(){
    ConnectTimer.stop();
    QString message =  QString::fromUtf8(tcpSocket->readAll());
    if(message=="@updatalikers@OK@"){
        Error=OK;
        return;
    }
    if(message=="@updatacomments@OK@"){
        Error=OK;
        return;
    }

}

UniquePostSystem::UniquePostSystem(Post *p){
    UniquePost=p;
    tcpSocket = new QTcpSocket;
    QObject::connect(tcpSocket,&QTcpSocket::readyRead,this,&UniquePostSystem::tcpReadMessage);
    QObject::connect(tcpSocket,&QTcpSocket::connected,this,&UniquePostSystem::setOK);
    QObject::connect(&ConnectTimer,&QTimer::timeout,this,&UniquePostSystem::tcpTimeOut);
    tcpSocket->connectToHost("119.29.15.43",6666);
    // tcpSocket->connectToHost(QHostAddress::LocalHost,6666);
    Error=Connecting;
}

bool UniquePostSystem::updataLikers(){
    if(Error==OK){

    QString out="@updatalikers@|||"+QString::number(UniquePost->Likers.last())+"|||"+UniquePost->LikersString;
    tcpSocket->write(out.toUtf8());
    ConnectTimer.start(1000);
    Error=Connecting;
    return true;
    }
    else
        return false;

}

bool UniquePostSystem::updataComments(){
    if(Error==OK){
    Comment temp=UniquePost->Comments.last();
    QString out="@updatacomments@|||"+temp.Message+"|||"+temp.Commentator+"|||"+temp.BeCommentator+"|||"+QString::number(temp.CommentatorID)+"|||"+QString::number(temp.BeCommentatorID);
    //服务器记得写时间
    tcpSocket->write(out.toUtf8());
    ConnectTimer.start(1000);
    Error=Connecting;
    return true;
    }
    else
        return false;
}











class CommentSystem{

};

class NewsSystem{
public:


};

class SuggestSystem{
public:


};

class RecordSystem{
public:


};

class SearchSystem{
public:


};


class System{
public:
    MainUser m_MainUser;
    UserSystem* m_UserSystem;
    PostSystem* m_PostSystem;
public:
    System(QString user, QString pass);
    ~System(){}


};

System::System(QString user, QString pass){
    m_UserSystem=new UserSystem(user,pass,&m_MainUser);
    m_PostSystem=new PostSystem(user,&m_MainUser.FriendsPosts,pass);
}





#endif // SYSTEM_H









