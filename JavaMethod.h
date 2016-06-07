/*在C++中使用Android API*/

#ifndef JAVAMETHOD_H
#define JAVAMETHOD_H
#include <QObject>

class JavaMethod : public QObject{
    Q_OBJECT
public:
    explicit JavaMethod(QObject *parent = 0);
    Q_INVOKABLE void toastMsg(QString a);//Android消息显示框
    Q_INVOKABLE void getImage();//打开图库并选择照片
    Q_INVOKABLE QString getImagePath();//返回选择的照片的地址
    Q_INVOKABLE QString getSDCardPath();//返回SDcard地址
signals:

public slots:
};

#endif // JAVAMETHOD_H
