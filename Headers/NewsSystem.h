#ifndef NEWSSYSTEM_H
#define NEWSSYSTEM_H

#include <QObject>
#include <QtNetwork/QtNetwork>

struct NewsComment{
    int ID;
    QString Message;

    QString CommentatorName;
    QString BeCommentatorName;

    QString CommentatorID;

};

class NewsSystem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString Statue READ Statue WRITE setStatue NOTIFY statueChanged)
public:
    explicit NewsSystem(QObject *parent = 0);
    ~NewsSystem();
public:
     QTcpSocket *tcpSocket;

     QString m_Statue;
     void setStatue(QString s);
     QString Statue();


     QString NewsList;
     Q_INVOKABLE void getNews(int count);//分析一定时间内运动时间分布
     Q_INVOKABLE QString getNewsList();


     QString NewsContent;
     Q_INVOKABLE void getContent(QString id);//分析一定时间内运动时间分布
     Q_INVOKABLE QString getNewsContent();

     Q_INVOKABLE void likeNews(QString id);
     Q_INVOKABLE void dislikeNews(QString id);

     Q_INVOKABLE bool saveMarked(QString str);
     Q_INVOKABLE QString loadMarked();

     QList<NewsComment> CommentList;//保存获取到的评论

     Q_INVOKABLE void getcomments(QString postid);//1有更多
     Q_INVOKABLE QString getcommentatorname(int i);
     Q_INVOKABLE QString getbecommentatorname(int i);
     Q_INVOKABLE QString getcommentmessage(int i);
     Q_INVOKABLE QString getcommentatorid(int i);
     Q_INVOKABLE int getcommentid(int i);

     Q_INVOKABLE void sendComment(QString postid,QString commentatorid,QString becommentatorid,QString msg);//发送分享
     Q_INVOKABLE void deleteComment(int commentid);//删除分享





public:
     void tcpReadMessage();
     void tcpSendMessage();

signals:
void statueChanged(const QString& Statue);

};




#endif // REPORTSYSTEM_H
