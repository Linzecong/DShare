#ifndef JAVAMETHOD_H
#define JAVAMETHOD_H

#include <QObject>

class JavaMethod : public QObject
{
    Q_OBJECT
public:
    explicit JavaMethod(QObject *parent = 0);
    Q_INVOKABLE void toastMsg(QString a);
    Q_INVOKABLE void getImage();
    Q_INVOKABLE QString getImagePath();
    Q_INVOKABLE QString getSDCardPath();

signals:

public slots:
};

#endif // JAVAMETHOD_H
