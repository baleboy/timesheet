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
