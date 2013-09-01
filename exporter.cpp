/*

Copyright (C) 2012 Francesco Balestrieri

This file is part of Timesheet for N9

Timesheet for N9 is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Timesheet for N9 is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Timesheet for N9.  If not, see <http://www.gnu.org/licenses/>.

*/

#include "exporter.h"

#include <QFile>
#include <QDir>
#include <QtDebug>
#include <QSparqlQuery>
#include <QSparqlConnection>
#include <QSparqlResult>
#include <QSparqlError>

#include "shareuiif.h"

const QString Exporter::ROOT_PATH = "/home/user/MyDocs/";
const QString Exporter::URL_PREFIX = "file://";
const QString Exporter::SHAREUI_DBUS_SERVICE = "com.nokia.ShareUi";

Exporter::Exporter(QObject *parent) :
    QObject(parent),
    m_mimeType("text/plain")
{
}

void Exporter::setFolderName(const QString& folderName)
{
    QString folderPath = ROOT_PATH + folderName;
    QString errorMsg;
    if (!QDir(folderPath).exists()) {
        qDebug() << "creating directory " << folderPath;
        if (!QDir::setCurrent(ROOT_PATH)) {
            errorMsg = ("Couldn't change to " + ROOT_PATH);
        }
        else {
            if (!QDir::current().mkdir(folderName)) {
                errorMsg =  "Couldn't create folder " + folderPath;
            }
        }
    }

    if (errorMsg.isEmpty()) {
        m_folderName = folderName;
    }
    else {
        qDebug() << errorMsg;
        emit error(errorMsg);
    }

}

void Exporter::share()
{
    if (!QFile::exists(fullPath())) {
        indexInTracker();
    }

    QFile file(fullPath());
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qDebug() << "Couldn't open file " << fullPath();
        emit error("Save failed");
        return;
    }

    QTextStream out(&file);
    out << m_body;
    file.close();

    emit fileSaved();

    startShareUi();
}

void Exporter::startShareUi()
{
    QStringList itemList;

    qDebug() << "Share file path uri" << fileUrl();
    itemList << fileUrl();

    qDebug() << "Connecting to service" << SHAREUI_DBUS_SERVICE;
    ShareUiIf shareIf(SHAREUI_DBUS_SERVICE, "/", QDBusConnection::sessionBus());

    qDebug() << "Signalling share-ui daemon...";
    shareIf.share (itemList);
}

void Exporter::indexInTracker()
{
    static QString queryStr = "INSERT { _:1 a nfo:FileDataObject, nfo:TextDocument ; "
            "nie:mimeType ?:mime ; "
            "nie:url ?:path ; "
            "nie:byteSize ?:size ."
            "}";

    QSparqlQuery query (queryStr, QSparqlQuery::InsertStatement);
    query.bindValue ("path", fileUrl());
    query.bindValue ("mime", m_mimeType);
    query.bindValue ("size", m_body.size());
    qDebug() << "Tracker query: " << query.preparedQueryText();

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
}

