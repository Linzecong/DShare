


TEMPLATE = app
QT+=androidextras
QT += qml quick
CONFIG += c++11
QT += qml quick quickcontrols2
QT += charts

QT+=network
QT       += script
QT += multimedia

SOURCES += \
    Sources/DataSystem.cpp \
    Sources/JavaMethod.cpp \
    Sources/LoginSystem.cpp \
    Sources/main.cpp \
    Sources/PostsSystem.cpp \
    Sources/RecordSystem.cpp \
    Sources/RegistSystem.cpp \
    Sources/ReportSystem.cpp \
    Sources/SendImageSystem.cpp \
    Sources/SpeechSystem.cpp \
    Sources/NewsSystem.cpp

RESOURCES += \
    qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    Framework/Core.h \
    Framework/News.h \
    Framework/Post.h \
    Framework/Record.h \
    Framework/System.h \
    Framework/User.h \
    Headers/ReportData.h \
    Headers/SpeechSystem.h \
    Headers/NewsSystem.h

HEADERS += \
    Headers/DataSystem.h \
    Headers/JavaMethod.h \
    Headers/LoginSystem.h \
    Headers/PostsSystem.h \
    Headers/RecordSystem.h \
    Headers/RegistSystem.h \
    Headers/ReportSystem.h \
    Headers/SendImageSystem.h


DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    android/src/an/qt/myjava/MyJava.java


ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

