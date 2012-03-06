#ifndef FILEHANDLER_H
#define FILEHANDLER_H

#include <QObject>

class FileHandler : public QObject
{
    Q_OBJECT
public:
    explicit FileHandler(QObject *parent = 0);

    // Q_INVOKABLE QString getAvailableFilename(QString base);
    Q_INVOKABLE bool save(QString name, QString body);
    Q_INVOKABLE void share(QString name, QString body);

public slots:

    void startShareUi();

private:

    QString m_path;
};

#endif // FILEHANDLER_H
