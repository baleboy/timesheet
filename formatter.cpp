#include <MLocale>
#include <MApplication>

#include <QtDebug>

#include "formatter.h"

Formatter::Formatter(QObject *parent) :
    QObject(parent), m_mLocale(new MLocale())
{
    QObject::connect(m_mLocale, SIGNAL(settingsChanged()), this, SLOT(onLocaleSettingsChanged()));
    m_mLocale->connectSettings();
    m_monthFirst = this->isMonthFirst();
}

Formatter::~Formatter()
{
    delete m_mLocale;
}

QString Formatter::formatTime(QDateTime dateTime)
{
    return m_mLocale->formatDateTime(dateTime, MLocale::DateNone, MLocale::TimeShort);
}

QString Formatter::formatTimeLong(QDateTime dateTime)
{
    return m_mLocale->formatDateTime(dateTime, MLocale::DateNone, MLocale::TimeLong);
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
    m_monthFirst = this->isMonthFirst();
    emit localeChanged();
}

// Ugly hack to let the javascript side know how to format the date
// according to locale. Needed because WorkerScript cannot use this object
bool Formatter::isMonthFirst()
{
    QDate testDate(2012, 12, 1);
    QString formatted = m_mLocale->formatDateTime(QDateTime(testDate), MLocale::DateShort);
    formatted.truncate(2);
    return (formatted == "12");
}

bool Formatter::monthFirst()
{
    return m_monthFirst;
}
