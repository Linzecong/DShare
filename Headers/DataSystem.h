/*数据系统，用于各种数据通信*/

#ifndef DATASYSTEM_H
#define DATASYSTEM_H

#include <QObject>
#include <QtNetwork/QtNetwork>
#include<QTimer>
#include<QStringList>


class DataSystem : public QObject{
    Q_OBJECT
    Q_PROPERTY(QString Statue READ Statue WRITE setStatue NOTIFY statueChanged)//用于与qml传递信息
public:
    explicit DataSystem(QObject *parent = 0);
    QTimer ConnectTimer;
    void reconnect();

public:
    QTcpSocket *tcpSocket;


    QString m_Statue;
    void setStatue(QString s);
    QString Statue();

    QMap<QString,int> XZMap;
    QMap<QString,int> YYMap;
    QMap<QString,int> YLMap;
    Q_INVOKABLE QString getXZ(QString food);
    Q_INVOKABLE QString getYY(QString food);
    Q_INVOKABLE QString getYL(QString food);
    void initMap();

    QString Name;
    Q_INVOKABLE void getNameByID(QString userid);//获取用户昵称
    Q_INVOKABLE QString getName();//返回用户昵称

    QString HeadURL;
    Q_INVOKABLE void getHeadByID(QString userid);
    Q_INVOKABLE QString getHead();

    Q_INVOKABLE void changeName(QString userid,QString newname);//修改昵称
    Q_INVOKABLE void changePassword(QString userid,QString newpassword);//修改昵称
    Q_INVOKABLE void addFollowing(QString userid,QString friendid);//添加关注
    Q_INVOKABLE void deleteFollowing(QString userid,QString friendid);//删除关注

    QStringList FollowingIDList;//获取到的关注的用户的ID
    QStringList FollowingNameList;//获取到的关注的用户的昵称
    Q_INVOKABLE void getFollowings(QString userid);//获取关注的用户
    Q_INVOKABLE QString getFollowingID(int i);//返回ID
    Q_INVOKABLE QString getFollowingName(int i);//返回昵称


    QStringList FollowerIDList;
    QStringList FollowerNameList;
    Q_INVOKABLE void getFollowers(QString userid);
    Q_INVOKABLE QString getFollowerID(int i);
    Q_INVOKABLE QString getFollowerName(int i);

    QStringList NoticeSenderList;
    QStringList NoticeTypeList;
    QStringList NoticeTimeList;
    QStringList NoticePostList;
    QStringList NoticeIsReadList;
    Q_INVOKABLE void getNotices(QString userid);
    Q_INVOKABLE QString getNoticeSender(int i);
    Q_INVOKABLE QString getNoticeType(int i);
    Q_INVOKABLE QString getNoticeTime(int i);
    Q_INVOKABLE int getNoticePost(int i);
    Q_INVOKABLE int getNoticeIsRead(int i);

    QStringList SearchIDList;
    QStringList SearchNameList;
    Q_INVOKABLE void searchUser(QString str);
    Q_INVOKABLE QString getsearchUserID(int i);
    Q_INVOKABLE QString getsearchUserName(int i);


    QStringList SearchFoodPhotoList;
    QStringList SearchFoodNameList;
    QStringList SearchFoodDesList;
    Q_INVOKABLE void searchFood(QString str);
    Q_INVOKABLE QString getsearchFoodPhoto(int i);
    Q_INVOKABLE QString getsearchFoodName(int i);
    Q_INVOKABLE QString getsearchFoodDes(int i);

    QStringList MSGFoodPhotoList;
    QStringList MSGFoodNameList;
    QStringList MSGFoodDesList;
    Q_INVOKABLE void getFoodMSG(QString str);//通过一连串食材，获得简要信息
    Q_INVOKABLE QString getMSGFoodPhoto(int i);
    Q_INVOKABLE QString getMSGFoodName(int i);
    Q_INVOKABLE QString getMSGFoodDes(int i);

    int checkinday;
    Q_INVOKABLE void checkin(QString userid);//打卡
    Q_INVOKABLE void getcheckinday(QString userid);//获取连续打卡的天数
    Q_INVOKABLE int getcheckinday();//返回连续打卡的天数

    Q_INVOKABLE QString getdate();//返回日期
    Q_INVOKABLE void uploadFood(QString a);//上传食物
    Q_INVOKABLE void uploadExercise(QString a);//上传运动

    Q_INVOKABLE void delusernamepassword();//注销时删除内存卡中的用户

    Q_INVOKABLE void savePhoto(QString url);//保存图片

    QString Reason;//按顺序
    QString RelationType;
    Q_INVOKABLE void getFoodRelation(QString foods);//获取相生相克
    Q_INVOKABLE QString getReason();
    Q_INVOKABLE QString getRelationType();


    QString FoodDes;
    Q_INVOKABLE void getFoodDetail(QString food);//获取食物详细数据
    Q_INVOKABLE QString getFoodDes();

    QString GoodReason;//包括名字和原因
    Q_INVOKABLE void getGoodRelation(QString food);//获取相生相克
    Q_INVOKABLE QString getGoodReason();

    QString BadReason;//包括名字和原因
    Q_INVOKABLE void getBadRelation(QString food);//获取相生相克
    Q_INVOKABLE QString getBadReason();


    QString FoodsFunc;
    Q_INVOKABLE void searchFunc(QString str);
    Q_INVOKABLE QString getsearchFunc();

public:
    void tcpReadMessage();
    void tcpSendMessage();
signals:

    void statueChanged(const QString& Statue);

public slots:
};
#endif // DATASYSTEM_H
