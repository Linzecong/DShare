#include <QGuiApplication>
#include <QQuickView>
#include <QQmlEngine>
#include <QQuickItem>
#include <QObject>
#include"LoginSystem.h"
#include"RegistSystem.h"
#include"PostsSystem.h"
#include"JavaMethod.h"
#include"SendImageSystem.h"
#include"DataSystem.h"
#include"RecordSystem.h"
int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    qmlRegisterType<LoginSystem>("LoginSystem",1,0,"LoginSystem");
    qmlRegisterType<RegistSystem>("RegistSystem",1,0,"RegistSystem");
    qmlRegisterType<PostsSystem>("PostsSystem",1,0,"PostsSystem");
    qmlRegisterType<JavaMethod>("JavaMethod",1,0,"JavaMethod");
    qmlRegisterType<SendImageSystem>("SendImageSystem",1,0,"SendImageSystem");
    qmlRegisterType<DataSystem>("DataSystem",1,0,"DataSystem");
    qmlRegisterType<RecordSystem>("RecordSystem",1,0,"RecordSystem");

    QQuickView viewer;
    viewer.setResizeMode(QQuickView::SizeRootObjectToView);
    viewer.setSource(QUrl("qrc:/main.qml"));
    viewer.show();


    return app.exec();
}
