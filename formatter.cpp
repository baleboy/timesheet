#include <MLocale>
#include <MApplication>

#include <QtDebug>

#include "formatter.h"

Formatter::Formatter(QObject *parent) :
    QObject(parent), m_mLocale(new MLocale())
{
    QObject::connect(m_mLocale, SIGNAL(settingsChanged()), this, SLOT(onLocaleSettingsChanged()));
    m_mLocale->connectSettings();
}

Formatter::~Formatter()
{
    delete m_mLocale;
}

QString Formatter::formatTime(QDateTime dateTime)
{
    return m_mLocale->formatDateTime(dateTime, MLocale::DateNone, MLocale::TimeShort);
}

QString Formatter::formatDateLong(QDateTime dateTime)
{
    return m_mLocale->formatDateTime(dateTime, MLocale::DateLong, MLocale::TimeNone);
}

QString Formatter::formatDateShort(QDateTime dateTime)
{
    return m_mLocale->formatDateTime(dateTime, MLocale::DateShort, MLocale::TimeNone);
}

QString Formatter::formatDateTime(QDateTime dateTime)
{
    return m_mLocale->formatDateTime(dateTime, MLocale::DateShort, MLocale::TimeShort);
}

QString Formatter::formatDateFull(QDateTime dateTime)
{
    return m_mLocale->formatDateTime(dateTime, MLocale::DateFull, MLocale::TimeNone);
}

QString Formatter::formatDateYearAndMonth(QDateTime dateTime)
{
    return m_mLocale->formatDateTime(dateTime, MLocale::DateYearAndMonth, MLocale::TimeNone);
}

void Formatter::onLocaleSettingsChanged()
{
    qDebug() << "locale changed";
    emit localeChanged();
}
