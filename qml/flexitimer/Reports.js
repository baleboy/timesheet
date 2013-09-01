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

Qt.include("Db.js")
Qt.include("Utils.js")

Date.prototype.getWeek = function() {
    var onejan = new Date(this.getFullYear(),0,1);
    return Math.ceil((((this - onejan) / 86400000) + onejan.getDay()+1)/7);
}

function getTitle(type)
{
    switch (type) {
    case "all":
        return qsTr("All Time")

    case "month":
        return formatter.formatDateYearAndMonth(startTime)

    case "week":
        return "Week " + startTime.getWeek() + ", " + startTime.getFullYear()

    case "day":
        return formatter.formatDateLong(startTime)
    }
}

function getProjectList(model)
{
    model.clear()
    // fixed item used to remove all selections
    model.append({ "name": qsTr("All Projects") })
    db.readTransaction(function(tx) {
                           var rs = tx.executeSql('SELECT name FROM Projects ORDER BY name ASC')
                           for(var i = 0; i < rs.rows.length; i++) {
                               model.append({"name": rs.rows.item(i).name})
                           }

                       });

}

function selectedProjectsText(list, total)
{
    if (list.length === 0 || list.length === total)
        return qsTr("All projects")

    if (list.length === 1)
        return qsTr("1 project")

    return list.length + " projects"
}

function setPreviousPeriod(periodType)
{
    var refTime = startTime
    switch (periodType) {
    case "day":
        refTime.setDate(refTime.getDate() - 1)
        startTime = dayStart(refTime)
        endTime = dayEnd(refTime)
        break;
    case "week":
        refTime.setDate(refTime.getDate() - 7)
        startTime = weekStart(refTime)
        endTime = weekEnd(refTime)
        break;
    case "month":
        refTime.setMonth(refTime.getMonth() - 1)
        startTime = monthStart(refTime)
        endTime = monthEnd(refTime)
        break;
    }
}

function setNextPeriod(periodType)
{
    var refTime = startTime
    switch (periodType) {
    case "day":
        refTime.setDate(refTime.getDate() + 1)
        startTime = dayStart(refTime)
        endTime = dayEnd(refTime)
        break;
    case "week":
        refTime.setDate(refTime.getDate() + 7)
        startTime = weekStart(refTime)
        endTime = weekEnd(refTime)
        break;
    case "month":
        refTime.setMonth(refTime.getMonth() + 1)
        startTime = monthStart(refTime)
        endTime = monthEnd(refTime)
        break;
    }

}
