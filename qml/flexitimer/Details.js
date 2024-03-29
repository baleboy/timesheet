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

function populateProjectDetails()
{
    detailsList.model.clear();

    var now = new Date

    db.readTransaction(function(tx) {
                       var rs = tx.executeSql('SELECT * FROM Details WHERE project=? AND startTime >= ? AND startTime <= ? ORDER BY endTime DESC',
                                              [project, 0, now.getTime()]);
        for(var i = 0; i < rs.rows.length; i++) {
            var date1 = new Date
            date1.setTime(rs.rows.item(i).startTime)
            var endTimeText = "";
            var elapsed = ""
            if(rs.rows.item(i).endTime !== "") {
                var date2 = new Date
                date2.setTime(rs.rows.item(i).endTime)
                endTimeText = formatter.formatTime(date2)
                elapsed = toTime(date2.getTime() - date1.getTime())
            }

            if (endTimeText !== "") {
            detailsList.model.append({startTime: formatter.formatTime(date1),
                             endTime: endTimeText,
                             elapsed: elapsed,
                             date: formatter.formatDateFull(date1),
                             recordId: rs.rows.item(i).recordId,
                             comments: rs.rows.item(i).comments
                             })
            }
            else {
                detailsList.model.insert(0, {
                                 startTime: formatter.formatTime(date1),
                                 endTime: endTimeText,
                                 elapsed: elapsed,
                                 date: formatter.formatDateFull(date1),
                                 recordId: rs.rows.item(i).recordId,
                                 comments: rs.rows.item(i).comments
                                 })
            }
        }
    });

}

function deleteRecord(project, recordId, index)
{
    db.transaction(function(tx) {
                       var rs = tx.executeSql('DELETE FROM Details WHERE project=? AND recordId = ?',
                                              [project, recordId])});
    detailsModel.remove(index)
}

function populateEditSessionPage()
{
    db.readTransaction(function(tx) {
                       var rs = tx.executeSql('SELECT * FROM Details WHERE recordId = ? ',
                                              [recordId]);
                       projectName = rs.rows.item(0).project
                       startTimeUTC = rs.rows.item(0).startTime
                       if (rs.rows.item(0).endTime !== "") {
                           endTimeUTC = rs.rows.item(0).endTime
                           inProgress = false
                       }
                       else
                           inProgress = true

                       if (rs.rows.item(0).comments !== undefined)
                           text1.text = rs.rows.item(0).comments
                   })
}

function saveComments(recordId, text)
{
    db.transaction(function(tx) {
                       tx.executeSql('UPDATE Details SET comments=? WHERE recordId=?', [text, recordId])
    });
}

function saveStartTime(recordId, t)
{
    db.transaction(function(tx) {
                       tx.executeSql('UPDATE Details SET startTime=? WHERE recordId=?', [t, recordId])
    });
}

function saveEndTime(recordId, t)
{
    db.transaction(function(tx) {
                       tx.executeSql('UPDATE Details SET endTime=? WHERE recordId=?', [t, recordId])
    });
}

function addRecord(recordId, project, startTime, endTime, comment)
{
    db.transaction(function(tx) {
                       tx.executeSql('INSERT INTO Details (recordId, project, startTime, endTime, comments) VALUES(?,?,?,?,?)', [recordId, project, startTime, endTime, comment])
    });
}

function updateRecord(recordId, startTime, comment, endTime)
{
    if (endTime)
        db.transaction(function(tx) {
                           tx.executeSql('UPDATE Details SET startTime=?, endTime=?, comments=? WHERE recordId=?', [startTime, endTime, comment, recordId])
                       });
    else
        db.transaction(function(tx) {
                           tx.executeSql('UPDATE Details SET startTime=?, comments=? WHERE recordId=?', [startTime, comment, recordId])
        });
}

function deleteAll(project)
{
    db.transaction(function(tx) {
                       tx.executeSql('DELETE FROM Details WHERE project=?', [project])
    });
    detailPage.update()
    mainPage.update()
}
