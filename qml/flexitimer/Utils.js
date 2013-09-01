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

.pragma library

function zeroPad(n) {
    var s = n.toString()
    if (s.length === 1)
        s = '0' + s
    return s
}

function toTime(msec) {
    var hours = Math.floor(msec / 3600000)
    return  zeroPad(hours) + "h " +
            zeroPad(Math.floor((msec % 3600000) / 60000)) + "m"
}

function toTimeForReport(msec) {
    var hours = Math.floor(msec / 3600000)
    return  zeroPad(hours) + ":" +
            zeroPad(Math.floor((msec % 3600000) / 60000)) + ":" +
            zeroPad(Math.floor((msec % 60000) / 1000))
}

function toTimeWithSeconds(msec) {
    var hours = Math.floor(msec / 3600000)
    return  zeroPad(hours) + "h " +
            zeroPad(Math.floor((msec % 3600000) / 60000)) + "m " +
            zeroPad(Math.floor((msec % 60000) / 1000)) + "s"
}


function dayStart(date)
{
    if (date === undefined)
        date = new Date()

    return new Date(date.getFullYear(),
                          date.getMonth(),
                          date.getDate())
}

function dayEnd(date)
{
    if (date === undefined)
        date = new Date()

    return new Date(date.getFullYear(),
                          date.getMonth(),
                          date.getDate(),
                          23, 59, 59)
}

function monthStart(date)
{
    if (date === undefined)
        date = new Date()

    return new Date(date.getFullYear(),
                          date.getMonth())
}

function monthEnd(date)
{
    if (date === undefined)
        date = new Date()

    return new Date(date.getFullYear(),
                          date.getMonth() + 1,
                          0,
                          23, 59, 59)
}

function weekStart(date)
{
    if (date === undefined)
        date = new Date()
    return new Date(date.getFullYear(),
                    date.getMonth(),
                    date.getDate() - date.getDay())
}

function weekEnd(date)
{
    if (date === undefined)
        date = new Date()
    return new Date(date.getFullYear(),
                    date.getMonth(),
                    date.getDate() + (7 - date.getDay()))
}

function localizedShortDate(date, monthFirst)
{
    return monthFirst ? Qt.formatDate(date, "MM/dd/yyyy") : Qt.formatDate(date, "dd/MM/yyyy")
}
