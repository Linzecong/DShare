#ifndef POST
#define POST
#include<QString>
#include<QImage>

//#include"Core.h"
//#include"User.h"

class Comment{
public:
    int ID;
    QString Message;

    QString CommentatorName;
    QString BeCommentatorName;

    QString CommentatorID;

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
    int CommentCount;

public:
    Post(){}
    ~Post(){}

};

#endif // POST

