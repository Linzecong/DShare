#include "Headers/SpeechSystem.h"
#include "Headers/JavaMethod.h"
#include<QSound>
#include <QAudioInput>
#include <QFile>
#include <QBuffer>
#define MAX_BUFFER_SIZE 512
SpeechSystem::SpeechSystem(QObject *parent) : QObject(parent)
{
    manager = new QNetworkAccessManager(this);
    QObject::connect(manager,&QNetworkAccessManager::finished,this,&SpeechSystem::replyFinish);
    manager2 = new QNetworkAccessManager(this);
    QObject::connect(manager2,&QNetworkAccessManager::finished,this,&SpeechSystem::getResult);

    manager3 = new QNetworkAccessManager(this);
    QObject::connect(manager3,&QNetworkAccessManager::finished,this,&SpeechSystem::getSplitSpeechResult);

SplitSpeechText="";
}

void SpeechSystem::setStatue(QString s)
{
    m_Statue=s;
    emit statueChanged(m_Statue);
}


QString SpeechSystem::Statue(){
    return m_Statue;
}

void SpeechSystem::inclick()
{
    JavaMethod java;

    QString path=java.getSDCardPath();

    path=path+"/DShare/temp.wav";

    outputFile.setFileName(path);
    outputFile.open(QIODevice::WriteOnly|QIODevice::Truncate);
    QAudioFormat format;
    // set up the format you want, eg.
    format.setSampleRate(8000);
    format.setChannelCount(1);
    format.setSampleSize(16);
    format.setCodec("audio/pcm");
    format.setByteOrder(QAudioFormat::LittleEndian);
    format.setSampleType(QAudioFormat::UnSignedInt);
    audio_in = new QAudioInput(format, this);
    audio_in->start(&outputFile);
}

void SpeechSystem::outclick(QString lan)
{
    TypeLabel=lan;
    JavaMethod java;

    QString path=java.getSDCardPath();

    path=path+"/DShare/temp.wav";


    audio_in->stop();

    outputFile.close();




//    QFile www;

//    www.setFileName(path);
//    www.open(QIODevice::ReadOnly );

//    QByteArray raw(www.readAll());
//    www.close();

//    QString path2=java.getSDCardPath();

//    path2=path2+"/DShare/test.wav";

//    QFile f;
//    f.setFileName(path2);
//    f.open(QIODevice::WriteOnly|QIODevice::Truncate );

//    typedef struct{
//        char riff_fileid[4];//"RIFF"
//        unsigned long riff_fileLen;
//        char waveid[4];//"WAVE"

//        char fmt_chkid[4];//"fmt"
//        unsigned long fmt_chkLen;

//        unsigned short    wFormatTag;        /* format type */
//        unsigned short    nChannels;         /* number of channels (i.e. mono, stereo, etc.) */
//        unsigned long   nSamplesPerSec;    /* sample rate */
//        unsigned long   nAvgBytesPerSec;   /* for buffer estimation */
//        unsigned short    nBlockAlign;       /* block size of data */
//        unsigned short    wBitsPerSample;


//        char data_chkid[4];//"DATA"
//        unsigned short data_chkLen;
//    }WaveHeader;

//    QAudioFormat format;
//    // set up the format you want, eg.
//    format.setSampleRate(8000);
//    format.setChannelCount(1);
//    format.setSampleSize(16);
//    format.setCodec("audio/pcm");
//    format.setByteOrder(QAudioFormat::LittleEndian);
//    format.setSampleType(QAudioFormat::UnSignedInt);

//    WaveHeader wh={0};
//    strcpy(wh.riff_fileid, "RIFF");
//    wh.riff_fileLen = raw.length() + 32;
//    strcpy(wh.waveid, "WAVE");

//    strcpy(wh.fmt_chkid, "fmt ");
//    wh.fmt_chkLen = 16;

//    wh.wFormatTag = 0x0001;
//    wh.nChannels = format.channelCount();
//    wh.nSamplesPerSec = format.sampleRate();
//    wh.wBitsPerSample = format.sampleSize();
//    wh.nBlockAlign =wh.nChannels*wh.wBitsPerSample/8;
//    wh.nAvgBytesPerSec =   wh.nBlockAlign*wh.nSamplesPerSec;

//    strcpy(wh.data_chkid, "data");



//    wh.data_chkLen = raw.length();


//    f.write((char *)&wh, sizeof(wh));
//    f.write(raw);
//    f.close();

    FileNameLabel=path;

    if(TypeLabel!="short")
    uploadClick();
}

void SpeechSystem::uploadClick()
{
    FILE *fp = NULL;
    fp = fopen(FileNameLabel.toStdString().c_str(), "r");

    if (NULL == fp)
    {
        return ;
    }

    fseek(fp, 0, SEEK_END);
    content_len = ftell(fp);
    fseek(fp, 0, SEEK_SET);
    audiodata = (char *)malloc(content_len);
    fread(audiodata, content_len, sizeof(char), fp);


    //put your own params here
    cuid = "8763554";
    char *apiKey = "DZTIB0fNi4hfI97WslZV3msU";
    char *secretKey = "e50de1ae064c9f445e0c40ebdfd1be9b";

    char host[MAX_BUFFER_SIZE];
    snprintf(host, sizeof(host),
             "http://openapi.baidu.com/oauth/2.0/token?grant_type=client_credentials&client_id=%s&client_secret=%s",
             apiKey, secretKey);



    manager->get(QNetworkRequest(QUrl(host)));

    //QNetworkRequest temp(QUrl("http://api.microsofttranslator.com/V2/Ajax.svc/Translate?appId=AFC76A66CF4F434ED080D245C30CF1E71C22959C&from=en&to=zh-cn&text=i%20played%20basketball%20yesturday"));

    //manager->get(temp);

    memset(host, 0, sizeof(host));
}

static const std::string base64_chars =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        "abcdefghijklmnopqrstuvwxyz"
        "0123456789+/";

static inline bool is_base64(unsigned char c) {
    return (isalnum(c) || (c == '+') || (c == '/'));
}

std::string SpeechSystem::base64_encode(const unsigned char *bytes_to_encode, unsigned int in_len)
{
    std::string ret;
    int i = 0;
    int j = 0;
    unsigned char char_array_3[3];
    unsigned char char_array_4[4];

    while (in_len--) {
        char_array_3[i++] = *(bytes_to_encode++);
        if (i == 3) {
            char_array_4[0] = (char_array_3[0] & 0xfc) >> 2;
            char_array_4[1] = ((char_array_3[0] & 0x03) << 4) + ((char_array_3[1] & 0xf0) >> 4);
            char_array_4[2] = ((char_array_3[1] & 0x0f) << 2) + ((char_array_3[2] & 0xc0) >> 6);
            char_array_4[3] = char_array_3[2] & 0x3f;

            for(i = 0; (i <4) ; i++)
                ret += base64_chars[char_array_4[i]];
            i = 0;
        }
    }

    if (i)
    {
        for(j = i; j < 3; j++)
            char_array_3[j] = '\0';

        char_array_4[0] = (char_array_3[0] & 0xfc) >> 2;
        char_array_4[1] = ((char_array_3[0] & 0x03) << 4) + ((char_array_3[1] & 0xf0) >> 4);
        char_array_4[2] = ((char_array_3[1] & 0x0f) << 2) + ((char_array_3[2] & 0xc0) >> 6);
        char_array_4[3] = char_array_3[2] & 0x3f;

        for (j = 0; (j < i + 1); j++)
            ret += base64_chars[char_array_4[j]];

        while((i++ < 3))
            ret += '=';

    }

    return ret;
}

std::string SpeechSystem::base64_decode(const std::string &encoded_string)
{
    int in_len = encoded_string.size();
    int i = 0;
    int j = 0;
    int in_ = 0;
    unsigned char char_array_4[4], char_array_3[3];
    std::string ret;

    while (in_len-- && ( encoded_string[in_] != '=') && is_base64(encoded_string[in_])) {
        char_array_4[i++] = encoded_string[in_]; in_++;
        if (i ==4) {
            for (i = 0; i <4; i++)
                char_array_4[i] = base64_chars.find(char_array_4[i]);

            char_array_3[0] = (char_array_4[0] << 2) + ((char_array_4[1] & 0x30) >> 4);
            char_array_3[1] = ((char_array_4[1] & 0xf) << 4) + ((char_array_4[2] & 0x3c) >> 2);
            char_array_3[2] = ((char_array_4[2] & 0x3) << 6) + char_array_4[3];

            for (i = 0; (i < 3); i++)
                ret += char_array_3[i];
            i = 0;
        }
    }

    if (i) {
        for (j = i; j <4; j++)
            char_array_4[j] = 0;

        for (j = 0; j <4; j++)
            char_array_4[j] = base64_chars.find(char_array_4[j]);

        char_array_3[0] = (char_array_4[0] << 2) + ((char_array_4[1] & 0x30) >> 4);
        char_array_3[1] = ((char_array_4[1] & 0xf) << 4) + ((char_array_4[2] & 0x3c) >> 2);
        char_array_3[2] = ((char_array_4[2] & 0x3) << 6) + char_array_4[3];

        for (j = 0; (j < i - 1); j++) ret += char_array_3[j];
    }

    return ret;
}

void SpeechSystem::replyFinish(QNetworkReply *reply)
{
    qDebug()<<"Token：";


    QJsonDocument TokenJson=QJsonDocument::fromJson(reply->readAll());//这个返回的JSON包所携带的所有信息
    qDebug()<<TokenJson.toJson(QJsonDocument::Indented);


    QString strText = TokenJson.object()["access_token"].toString();


    qDebug()<<strText;


    QJsonObject json;
    json.insert("format", "pcm");
    json.insert("rate", 8000);
    json.insert("channel", 1);
    json.insert("token", strText.toStdString().c_str());
    json.insert("cuid", cuid);

    json.insert("len", content_len);
    json.insert("lan", TypeLabel);
    json.insert("speech",QString::fromStdString(base64_encode((const unsigned char *)audiodata, content_len)));

    QJsonDocument document;
    document.setObject(json);
    QByteArray byte_array = document.toJson(QJsonDocument::Compact);



    QUrl url("http://vop.baidu.com/server_api");


    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader,QVariant("application/json; charset=utf-8"));
    request.setHeader(QNetworkRequest::ContentLengthHeader,QVariant(byte_array.length()));

    manager2->post(request,byte_array);
}

void SpeechSystem::getResult(QNetworkReply *reply)
{
    QJsonDocument TokenJson=QJsonDocument::fromJson(reply->readAll());//这个返回的JSON包所携带的所有信息
    qDebug()<<TokenJson.toJson(QJsonDocument::Indented);

    QJsonArray list=TokenJson.object()["result"].toArray();


    m_Statue=list.at(0).toString().replace(",","").replace("，","");

    qDebug()<<m_Statue;
    emit statueChanged(m_Statue);


}

void SpeechSystem::splitSpeech(QString str)
{
    str=QString::fromStdString(str.toStdString())+"&param1=0&param2=0";

    QUrl url("http://api.pullword.com/get.php?source="+str);


    QNetworkRequest request(url);
    qDebug()<<request.url().toString();
    manager3->get(request);
}

QString SpeechSystem::getSplitSpeech()
{
    QString temp=SplitSpeechText;
    return temp;
}

void SpeechSystem::getSplitSpeechResult(QNetworkReply *reply)
{

    SplitSpeechText="";

    QStringList temp;


    while(reply->canReadLine())
    temp.append(reply->readLine());

    SplitSpeechText=temp.join("@");
    qDebug()<<SplitSpeechText;
    SplitSpeechText=SplitSpeechText.replace("\r\n","").replace("@@@","").replace("@@","")+"@";

    if(SplitSpeechText.indexOf("error")>=0)
    m_Statue="";
    else
    m_Statue="splitdone";


    emit statueChanged(m_Statue);
}

