#ifndef SPEECHSYSTEM_H
#define SPEECHSYSTEM_H

#include <QObject>

#include<QSound>
#include <QAudioInput>
#include <QFile>
#include <QBuffer>
#include <QtNetwork/QtNetwork>
class SpeechSystem : public QObject
{
    Q_OBJECT
public:
    explicit SpeechSystem(QObject *parent = 0);
    Q_PROPERTY(QString Statue READ Statue WRITE setStatue NOTIFY statueChanged)
    QString m_Statue;
    void setStatue(QString s);
    QString Statue();

    Q_INVOKABLE void inclick();
    Q_INVOKABLE void outclick(QString lan);
    QString TypeLabel;
    QString FileNameLabel;
    void uploadClick();
    QNetworkAccessManager *manager;

    char *cuid;
    char *audiodata;
    int content_len;
    std::string base64_encode(unsigned char const* bytes_to_encode, unsigned int in_len);
    std::string base64_decode(std::string const& encoded_string);
    void replyFinish(QNetworkReply *reply);
     QNetworkAccessManager *manager2;
     void getResult(QNetworkReply *reply);


     QFile outputFile;   // class member.
     QAudioInput* audio_in; // class member.
     QFile inputFile;   // class member.
     QIODevice *myBuffer_in;


     QString SplitSpeechText;
     Q_INVOKABLE void splitSpeech(QString str);
     Q_INVOKABLE QString getSplitSpeech();

     QNetworkAccessManager *manager3;
     void getSplitSpeechResult(QNetworkReply *reply);


signals:
void statueChanged(const QString& Statue);


};

#endif // SPEECHSYSTEM_H
