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

import QtQuick 1.1
import com.nokia.extras 1.0

TumblerDialog {
    id: root
    acceptButtonText: qsTr("Accept")
    rejectButtonText: qsTr("Cancel")
    titleText: qsTr("Select Date and Time")

    property int month: 1
    property int day: 1
    property int hour: 0
    property int minute: 0
    property int year: 0

    signal picked

    onMonthChanged: monthColumn.selectedIndex = month - 1
    onDayChanged: dayColumn.selectedIndex = day - 1
    onHourChanged: hourColumn.selectedIndex = hour
    onMinuteChanged: minuteColumn.selectedIndex = minute

    function setUtcTime(utc)
    {
        var d = new Date
        d.setTime(utc)

        month = d.getMonth() + 1
        day = d.getDate()
        hour = d.getHours()
        minute = d.getMinutes()
        year = d.getFullYear()

        update()
    }


    function update()
    {
        monthColumn.selectedIndex = root.month - 1
        dayColumn.selectedIndex = root.day - 1
        hourColumn.selectedIndex = root.hour
        minuteColumn.selectedIndex = root.minute

    }

    function toDateTime() {
        var date = new Date(year, month - 1,day,hour,minute,0)
        return date
    }


    function toDateTimeUTC() {
        var date = new Date(year, month - 1,day,hour,minute,0)
        return date.getTime()
    }

    columns: [ monthColumn, dayColumn, hourColumn, minuteColumn ]

    TumblerColumn {
        id: monthColumn
        label: qsTr("MONTH")

        onSelectedIndexChanged: {
            // adjust the number of days that can be selected
            var maxDays = dateTime.daysInMonth(root.year, selectedIndex + 1)
            if (dayList.count > maxDays) {
                // remove days
                var oldDays = dayList.count
                for (var i = 0 ; i < oldDays - maxDays ; i++) {
                    dayList.remove(dayList.count - 1)
                }
            }
            else if (dayList.count < maxDays) {
                // add days
                for (i = dayList.count ; i < maxDays ; i++)
                    dayList.append({"value": i + 1})
            }
        }
        items: ListModel {
            id: monthList
        }
    }

    TumblerColumn {
        id: dayColumn
        label: qsTr("DAY")

        items: ListModel {
            id: dayList
        }
    }

    TumblerColumn {
        id: hourColumn
        label: qsTr("HOUR")

        items: ListModel {
            id: hourList
        }
    }

    TumblerColumn {
        id: minuteColumn
        label: qsTr("MIN")

        items: ListModel {
            id: minuteList
        }
    }

    onAccepted: {
        root.month = monthColumn.selectedIndex + 1
        root.day = dayColumn.selectedIndex + 1
        root.hour = hourColumn.selectedIndex
        root.minute = minuteColumn.selectedIndex
        root.picked()
    }

    function initializeDataModels()
    {
        var i
        for (i = 1 ; i <= 12 ; i++)
            monthList.append({"value": dateTime.shortMonthName(i)})
        for (i = 1 ; i <= dateTime.daysInMonth(dateTime.currentYear, root.month) ; i++)
            dayList.append({"value": i})
        for (i = 0 ; i <= 23 ; i++)
            hourList.append({"value": (i <= 9 ? "0" : "") + i })
        for (i = 0 ; i <= 59 ; i++)
            minuteList.append({"value": (i <= 9 ? "0" : "") + i })
    }

    Component.onCompleted: initializeDataModels()
}
