#include "Headers/JavaMethod.h"
#ifdef ANDROID
#include <QtAndroidExtras/QAndroidJniObject>
#include <unistd.h>
#include <QGuiApplication>
#include <QScreen>
#endif

JavaMethod::JavaMethod(QObject *parent) : QObject(parent){

}
//详见Qt for Android一书
void JavaMethod::toastMsg(QString a){
#ifdef ANDROID
    QAndroidJniObject javatoast=QAndroidJniObject::fromString(a);
    QAndroidJniObject::callStaticMethod<void>("an/qt/myjava/MyJava","makeToast","(Ljava/lang/String;)V",javatoast.object<jstring>());
#endif
}

void JavaMethod::getImage(){
#ifdef ANDROID
    QAndroidJniObject::callStaticMethod<void>("an/qt/myjava/MyJava","getImage","()V");
#endif
}

QString JavaMethod::getImagePath(){
#ifdef ANDROID
    QAndroidJniObject str=QAndroidJniObject::callStaticObjectMethod("an/qt/myjava/MyJava","getImagePath","()Ljava/lang/String;");
    return str.toString();
#endif
}

QString JavaMethod::getSDCardPath(){
#ifdef ANDROID
    QAndroidJniObject str=QAndroidJniObject::callStaticObjectMethod("an/qt/myjava/MyJava","getSdcardPath","()Ljava/lang/String;");
    return str.toString();
#endif
}

int JavaMethod::getWidth(){

    return QGuiApplication::screens().first()->availableSize().width();

}

int JavaMethod::getHeight(){

    return QGuiApplication::screens().first()->availableSize().height();
}

QString JavaMethod::getStatusBarHeight()
{
#ifdef ANDROID
    QAndroidJniObject str=QAndroidJniObject::callStaticObjectMethod("an/qt/myjava/MyJava","getStatusBarHeight","()Ljava/lang/String;");
    return str.toString();
#endif
}
