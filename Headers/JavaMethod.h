/*在C++中使用Android API*/

#ifndef JAVAMETHOD_H
#define JAVAMETHOD_H
#include <QObject>
#include <QFile>
#include <QPixmap>
#include <QQuickWindow>

class JavaMethod : public QObject{
    Q_OBJECT
public:
    explicit JavaMethod(QObject *parent = 0);
    Q_INVOKABLE void toastMsg(QString a);//Android消息显示框
    Q_INVOKABLE void shareImage(QString url);//分享图片

    Q_INVOKABLE void getImage();//打开图库并选择照片
    Q_INVOKABLE QString getImagePath();//返回选择的照片的地址
    Q_INVOKABLE QString getSDCardPath();//返回SDcard地址

     Q_INVOKABLE int getWidth();//返回SDcard地址
     Q_INVOKABLE int getHeight();//返回SDcard地址


    Q_INVOKABLE QString getStatusBarHeight();//返回SDcard地址

//    Q_INVOKABLE void screenShot(QObject *obj) {
//        QQuickWindow* window = qobject_cast<QQuickWindow*>(obj);
//        QPixmap pixmap = QPixmap::fromImage(window->grabWindow());
//        QString path=getSDCardPath();
//        path=path+"/DSharePhoto/"+"your_name.png";

//        QFile f(path);
//        f.open(QIODevice::WriteOnly);
//        if(f.isOpen()) {
//            pixmap.save(&f,"PNG");
//        }
//    }


signals:

public slots:
};

#endif // JAVAMETHOD_H
