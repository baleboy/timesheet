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

function populate() {

    projectList.model.clear();
    db.readTransaction(function(tx) {
                       var now = new Date()
                          var rs = tx.executeSql('SELECT \
                                                 project, timeStamp \
                                                 ,SUM(CASE WHEN endTime IS NOT NULL THEN endTime - startTime ELSE 0 END) AS elapsedTotal \
                                                 ,SUM(CASE WHEN startTime >= ? AND startTime <= ? AND endTime IS NOT NULL THEN endTime - startTime ELSE 0 END) AS elapsedToday \
                                             FROM \
                                                 (SELECT Projects.name as project, Projects.timeStamp as timeStamp, Details.startTime, Details.endTime \
                                                 FROM Projects \
                                                 LEFT JOIN Details \
                                                 ON Projects.name=Details.project) \
                                             GROUP BY \
                                                 project \
                                             ORDER BY timeStamp DESC', [dayStart(now).getTime(), dayEnd(now).getTime()]);
                          for(var i = 0; i < rs.rows.length; i++) {
                              projectList.model.append({name: rs.rows.item(i).project, elapsedTotal: parseFloat(rs.rows.item(i).elapsedTotal),
                                                           elapsedToday: parseFloat(rs.rows.item(i).elapsedToday)});

                          }
                      });

}

function restoreOngoingSession()
{
    inProgress = getProperty("projectInProgress")

    if (inProgress !== "") {
        for (var i = 0 ; i < projectList.model.count ; i++) {
            if (projectList.model.get(i).name === inProgress) {
                inProgressIndex = i

            }
        }
        // set the timer start time to the start time of the ongoing session
        db.readTransaction(function(tx) {
                           var rs = tx.executeSql('SELECT startTime FROM Details WHERE ROWID=?', [lastId]);
                           if (rs.rows.length > 0) {
                               workTimer.setStartTime(parseFloat(rs.rows.item(0).startTime))
                               workTimer.resumeTimer()
                           }
                       })
    }
}

function addProject(name)
{
    db.transaction(function(tx) {
                       tx.executeSql('INSERT INTO Projects (name, timeStamp) VALUES (?, ?)', [name, 0])
                   });
}

function deleteProject(name, index)
{
    db.transaction(function(tx) {
                       var rs = tx.executeSql('DELETE FROM Projects WHERE name = ?', [name])
                   })

    db.transaction(function(tx) {
                       var rs = tx.executeSql('DELETE FROM Details WHERE project = ?', [name])
                   })
    if (index === inProgressIndex) {
        workTimer.stop()
        inProgress = ""
    }
    appWindow.todaysTotal -= projectsModel.get(index).elapsedToday
    projectsModel.remove(index)
    if (inProgressIndex > index)
        inProgressIndex--
}

function renameProject(oldName, newName, index)
{
    db.transaction(function(tx) {
                       var rs = tx.executeSql('UPDATE Projects SET name=? WHERE name=?', [newName, oldName])
                       rs = tx.executeSql('UPDATE Details SET project=? WHERE project=?', [newName, oldName])
                   });
    projectsModel.setProperty(index, "name", newName)
}

function totalWork(startTime, endTime)
{
    var result;
    db.transaction(function(tx) {
                       var rs = tx.executeSql('SELECT SUM (endTime - startTime) AS total FROM DETAILS WHERE startTime >= ? AND startTime <= ?',
                                              [startTime.getTime(), endTime.getTime()]);
                       result = rs.rows.item(0).total
    });
    if (result === "")
        return 0
    else
        return result
}
