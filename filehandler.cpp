#include "filehandler.h"
#include <QDir>
#include <QFile>
#include <QtDebug>
#include <QSparqlQuery>
#include <QSparqlConnection>
#include <QSparqlResult>
#include <QSparqlError>

#include "shareuiif.h"

const QString SAVEDIR_NAME = "FlexiTimer";
const QString DOCDIR_PATH = "/home/user/MyDocs"; // QDir::homePath() + "/MyDocs";
const QString SAVEDIR_PATH = DOCDIR_PATH + "/" + SAVEDIR_NAME + "/";
const QString SHAREUI_DBUS_SERVICE = "com.nokia.ShareUi";

FileHandler::FileHandler(QObject *parent) :
    QObject(parent)
{
}

bool FileHandler::save(QString filename, QString body)
{
    if (!QDir(SAVEDIR_PATH).exists()) {
        qDebug() << "creating directory " << SAVEDIR_PATH;
        if (!QDir::setCurrent(DOCDIR_PATH)) {
            qDebug() << "Couldn't change to " << DOCDIR_PATH;
            return false;
        }
        if (!QDir::current().mkdir(SAVEDIR_NAME)) {
            qDebug() << "Couldn't create folder " << SAVEDIR_NAME;
            return false;
        }
    }
    QFile file(SAVEDIR_PATH + filename);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qDebug() << "Couldn't open file " << filename;
        return false;
    }
    QTextStream out(&file);
    out << body;
    qDebug() << SAVEDIR_PATH;

    file.close();
    return true;
}

void FileHandler::share(QString name, QString body)
{
    // tell tracker about the file before it's created
    QString queryStr = "INSERT { _:1 a nfo:FileDataObject, nfo:TextDocument ; "
            "nie:mimeType \"text/plain\" ; "
            "nie:url ?:path ; "
            "nie:byteSize ?:size ."
            "}";

    m_path = SAVEDIR_PATH + name;
    // QFileInfo fileInfo(file);
    // m_path = "file://" + fileInfo.canonicalFilePath();

    QSparqlQuery query (queryStr, QSparqlQuery::InsertStatement);
    query.bindValue ("path", "file://" + m_path);
    query.bindValue ("size", body.size());
    qDebug() << query.preparedQueryText();

    QSparqlConnection connection("QTRACKER_DIRECT");
    if (!connection.isValid()) {
        qDebug() << "Invalid tracker connection";
        return;
    }

    QSparqlResult* result = connection.syncExec(query);
    if (result->hasError()) {
        qDebug() << "Query error";
        qDebug() << result->lastError();
    }

    save(name, body);
    startShareUi();
}


void FileHandler::startShareUi()
{
    QStringList itemList;
    QString fileUri = "file://" +  m_path;

    qDebug() << "Share file path uri" << fileUri;
    itemList << fileUri;

    // Create a interface object
    qDebug() << "Connecting to service" << SHAREUI_DBUS_SERVICE;
    ShareUiIf shareIf(SHAREUI_DBUS_SERVICE, "/", QDBusConnection::sessionBus());

    // You can check if interface is valid
   // if (shareIf.isValid()) {
        // Start ShareUI application with selected files.
        qDebug() << "Signalling share-ui daemon...";
        shareIf.share (itemList);
 //   } else {
 //       qCritical() << "Invalid interface";
//    }

}
