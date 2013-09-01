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

#ifndef FORMATTER_H
#define FORMATTER_H

#include <QObject>
#include <QDateTime>

class MLocale;

class Formatter : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool monthFirst READ monthFirst NOTIFY localeChanged)

public:
    explicit Formatter(QObject *parent = 0);
    ~Formatter();

    Q_INVOKABLE QString formatTime(QDateTime dateTime);
    Q_INVOKABLE QString formatTimeLong(QDateTime dateTime);
    Q_INVOKABLE QString formatDateLong(QDateTime dateTime);
    Q_INVOKABLE QString formatDateShort(QDateTime dateTime);
    Q_INVOKABLE QString formatDateFull(QDateTime dateTime);
    Q_INVOKABLE QString formatDateYearAndMonth(QDateTime dateTime);
    Q_INVOKABLE QString formatDateTime(QDateTime dateTime);
    bool monthFirst();


public slots:

    void onLocaleSettingsChanged();

signals:

    void localeChanged();

private:
    MLocale* m_mLocale;
    bool m_monthFirst;

    bool isMonthFirst();
};

#endif // FORMATTER_H
