#ifndef POST
#define POST
#include<QString>
#include<QImage>

//#include"Core.h"
//#include"User.h"

class Comment{
public:
    double ID;
    QString Message;
    QString Commentator;
    QString BeCommentator;

    double CommentatorID;
    double BeCommentatorID;

    QString CommentTime;
    Comment(){}
    ~Comment(){}
};

class Post{
public:
    int ID;
    QString Publisher;
    QString PostTime;
    QString PublisherID;

    QString Message;
    QString ImageURL;
    QString HeadURL;

    QList<Comment> Comments;

    QList<double> Likers;
    QString LikersString;


    bool HasImage;

public:
    Post(){}
    ~Post(){}

};

#endif // POST

