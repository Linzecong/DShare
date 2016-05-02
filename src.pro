TEMPLATE = lib
TARGET = material

CONFIG += c++11
QT += qml quick

HEADERS += plugin.h \
           core/device.h \
           core/units.h

SOURCES += plugin.cpp \
           core/device.cpp \
           core/units.cpp

RESOURCES += ../icons/core_icons.qrc

target.path = $$[QT_INSTALL_QML]/Material

material.files += qmldir \
                    components/* \
                    controls/* \
                    core/* \
                    popups/* \
                    window/*
material.path = $$[QT_INSTALL_QML]/Material

extras.files += extras/*
extras.path = $$[QT_INSTALL_QML]/Material/Extras

listitems.files += listitems/*
listitems.path = $$[QT_INSTALL_QML]/Material/ListItems

styles.files += styles/*
styles.path = $$[QT_INSTALL_QML]/QtQuick/Controls/Styles/Material

qmldir.target = $$[QT_INSTALL_QML]/Material/qmldir
qmldir.commands = sed \"s/$$LITERAL_HASH plugin material/plugin material/\" $$PWD/qmldir > $$qmldir.target
qmldir.depends = $$PWD/qmldir
qmldir.path = $$[QT_INSTALL_QML]/Material

INSTALLS += target material extras listitems styles qmldir

OTHER_FILES += $$material.files $$extras.files $$listitems.files $$styles.files
