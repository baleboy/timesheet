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
