


TEMPLATE = app
QT+=androidextras
QT += qml quick
CONFIG += c++11
QT += qml quick quickcontrols2
SOURCES += main.cpp \
    LoginSystem.cpp \
    RegistSystem.cpp \
    PostsSystem.cpp \
    JavaMethod.cpp \
    SendImageSystem.cpp \
    DataSystem.cpp \
    RecordSystem.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    LoginSystem.h \
    RegistSystem.h \
    Framework/Core.h \
    Framework/News.h \
    Framework/Post.h \
    Framework/Record.h \
    Framework/System.h \
    Framework/User.h \
    PostsSystem.h \
    JavaMethod.h \
    SendImageSystem.h \
    DataSystem.h \
    RecordSystem.h

DISTFILES += \
    MainPage.qml \
    NewsPage.qml \
    SendPage.qml \
    RecordPage.qml \
    SearchPage.qml \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    android/src/an/qt/myjava/MyJava.java \
    UsersPage.qml \
    PostsPage.qml \
    SettingPage.qml

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

