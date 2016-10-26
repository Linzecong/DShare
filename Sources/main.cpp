#include <QApplication>
#include <QQuickView>
#include <QQuickStyle>
#include <QQmlEngine>
#include <QQuickItem>
#include <QObject>
#include"Headers/LoginSystem.h"
#include"Headers/RegistSystem.h"
#include"Headers/PostsSystem.h"
#include"Headers/JavaMethod.h"
#include"Headers/SendImageSystem.h"
#include"Headers/DataSystem.h"
#include"Headers/RecordSystem.h"
#include"Headers/ReportSystem.h"
#include"Headers/SpeechSystem.h"
#include <QFontDatabase>

int main(int argc, char *argv[]){
    QApplication app(argc, argv);



    //将C++注册到QML中
    qmlRegisterType<LoginSystem>("LoginSystem",1,0,"LoginSystem");
    qmlRegisterType<RegistSystem>("RegistSystem",1,0,"RegistSystem");
    qmlRegisterType<PostsSystem>("PostsSystem",1,0,"PostsSystem");
    qmlRegisterType<JavaMethod>("JavaMethod",1,0,"JavaMethod");
    qmlRegisterType<SendImageSystem>("SendImageSystem",1,0,"SendImageSystem");
    qmlRegisterType<DataSystem>("DataSystem",1,0,"DataSystem");
    qmlRegisterType<RecordSystem>("RecordSystem",1,0,"RecordSystem");
    qmlRegisterType<ReportSystem>("ReportSystem",1,0,"ReportSystem");
    qmlRegisterType<SpeechSystem>("SpeechSystem",1,0,"SpeechSystem");

    QQuickView viewer;



    QObject::connect(viewer.engine(), SIGNAL(quit()), &app, SLOT(quit()));
    viewer.setResizeMode(QQuickView::SizeRootObjectToView);
    viewer.setSource(QUrl("qrc:/QML/main.qml"));
    viewer.show();






    return app.exec();
}
