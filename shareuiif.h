/*
 * This file was generated by qdbusxml2cpp version 0.7
 * Command line was: qdbusxml2cpp -v -c ShareUiIf -p shareuiif.h:shareuiif.cpp com.nokia.ShareUiInterface.xml
 *
 * qdbusxml2cpp is Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies).
 *
 * This is an auto-generated file.
 * Do not edit! All changes made to it will be lost.
 */

#ifndef SHAREUIIF_H_1329381295
#define SHAREUIIF_H_1329381295

#include <QtCore/QObject>
#include <QtCore/QByteArray>
#include <QtCore/QList>
#include <QtCore/QMap>
#include <QtCore/QString>
#include <QtCore/QStringList>
#include <QtCore/QVariant>
#include <QtDBus/QtDBus>

/*
 * Proxy class for interface com.nokia.maemo.meegotouch.ShareUiInterface
 */
class ShareUiIf: public QDBusAbstractInterface
{
    Q_OBJECT
public:
    static inline const char *staticInterfaceName()
    { return "com.nokia.maemo.meegotouch.ShareUiInterface"; }

public:
    ShareUiIf(const QString &service, const QString &path, const QDBusConnection &connection, QObject *parent = 0);

    ~ShareUiIf();

public Q_SLOTS: // METHODS
    inline QDBusPendingReply<> share(const QStringList &items)
    {
        QList<QVariant> argumentList;
        argumentList << QVariant::fromValue(items);
        return asyncCallWithArgumentList(QLatin1String("share"), argumentList);
    }

Q_SIGNALS: // SIGNALS
};

namespace com {
  namespace nokia {
    namespace maemo {
      namespace meegotouch {
        typedef ::ShareUiIf ShareUiInterface;
      }
    }
  }
}
#endif
