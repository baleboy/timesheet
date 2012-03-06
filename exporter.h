#ifndef EXPORTER_H
#define EXPORTER_H

#include <QObject>

class Exporter : public QObject
{
    Q_OBJECT
public:

    explicit Exporter(QObject *parent = 0);
    
    Q_PROPERTY(QString fileName READ fileName WRITE setFileName)
    Q_PROPERTY(QString folderName READ folderName WRITE setFolderName)
    Q_PROPERTY(QString body READ body WRITE setBody)
    Q_PROPERTY(QString fullPath READ fullPath)
    Q_PROPERTY(QString mimeType READ mimeType WRITE setMimeType)

public slots:

    void share();

public:

    Q_INVOKABLE QString fileName() { return m_fileName; }
    Q_INVOKABLE void setFileName(const QString& fileName) { m_fileName = fileName; }

    Q_INVOKABLE QString folderName() { return m_folderName; }
    Q_INVOKABLE void setFolderName(const QString& folderName );

    Q_INVOKABLE const QString& body() { return m_body; }
    Q_INVOKABLE void setBody(const QString& body) { m_body = body; }

    Q_INVOKABLE const QString& mimeType() { return m_mimeType; }
    Q_INVOKABLE void setMimeType(const QString& mimeType) { m_mimeType = mimeType; }

    Q_INVOKABLE QString fullPath() { return ROOT_PATH + m_folderName + "/" + m_fileName; }
    Q_INVOKABLE QString fileUrl() { return URL_PREFIX + fullPath(); }

signals:

    void error(const QString& msg);
    void fileSaved();

private:

    void startShareUi();
    void indexInTracker();

    QString m_fileName;
    QString m_folderName;
    QString m_body;
    QString m_mimeType;

    static const QString ROOT_PATH;
    static const QString URL_PREFIX;
    static const QString SHAREUI_DBUS_SERVICE;
};

#endif // EXPORTER_H
