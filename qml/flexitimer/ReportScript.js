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

Qt.include("Db.js")
Qt.include("Utils.js")

function handleReport(message)
{
    var reportModel = message.model
    var projectString = message.projectString
    var startTime = message.startTime
    var endTime = message.endTime
    var monthFirst = message.monthFirst

    reportModel.clear();

    // build query to include list of project names filter if needed

    var query = "SELECT * FROM Details WHERE startTime >= ? AND startTime <= ?"
    if (projectString !== "") {
        query += " AND project IN (" + projectString + ")"
    }
    query += " ORDER BY startTime DESC"

    db.readTransaction(function(tx) {
                           var rs = tx.executeSql(query,
                                                  [startTime.getTime(), endTime.getTime()]);
                           var totalElapsed = 0;

                           for(var i = 0; i < rs.rows.length; i++) {
                               var date1 = new Date
                               date1.setTime(rs.rows.item(i).startTime)
                               var elapsed = ""


                               if(rs.rows.item(i).endTime !== "") {
                                   var date2 = new Date
                                   date2.setTime(rs.rows.item(i).endTime)
                                   var delta = date2.getTime() - date1.getTime()
                                   elapsed = toTime(delta)
                                   totalElapsed += delta
                                   reportModel.append({
                                                          project: rs.rows.item(i).project,
                                                          startTimeUTC: date1.getTime(),
                                                          endTimeUTC: date2.getTime(),
                                                          elapsed: elapsed,
                                                          elapsedUTC: delta,
                                                          date: localizedShortDate(date1, monthFirst),
                                                          comments: rs.rows.item(i).comments
                                                      });
                               }

                           }
                           reportModel.sync()
                           WorkerScript.sendMessage({ 'elapsed': toTime(totalElapsed) })
                       })
}

WorkerScript.onMessage = function(message) {
            handleReport(message)
        }

