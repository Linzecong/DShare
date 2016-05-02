#ifndef USER
#define USER
#include<QString>
#include<QList>
#include<QImage>

#include"Post.h"



class BaseUser{
public:
    double ID;
    QString Name;
    QString Des;
    bool Sex;
    int Age;
    Location Home;

    QImage HeadImage;

    QList<double> Followers;
    QList<double> Followings;

    QList<Post> Posts;

    bool IsShowPosts;

    BaseUser(){}
    ~BaseUser(){}

};

class MainUser:public BaseUser{
public:

    QString Username;
    QString Password;


    QList<double> PostCollections;
    QList<double> NewsCollections;


    QList<Post> FriendsPosts;

MainUser(){}
~MainUser(){}

};



#endif // USER

