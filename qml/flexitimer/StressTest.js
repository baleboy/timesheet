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

function createData() {
    
    var projects = 10
    var sessions = 180
    var clock = new Date(2012, 1, 1, 0, 0, 0)
    var p,s
    var projectName

    for (p = 0 ; p < projects ; p++) {
        projectName = "project" + p
        console.log('project: ' + projectName)
        db.transaction(function(tx) {
                           tx.executeSql('INSERT INTO Projects (name, timeStamp) VALUES (?, ?)', [projectName, 0])
                       });
        for (s = 0 ; s < sessions ; s++) {
            var startTime, endTime
            startTime= clock.getTime()
            clock.setMinutes(clock.getMinutes() + 5)
            endTime = clock.getTime()
            clock.setMinutes(clock.getMinutes() + 5)
            db.transaction(function(tx) {
                               tx.executeSql('INSERT INTO Details (recordId, project, startTime, endTime, comments) VALUES(?,?,?,?,?)', [startTime, projectName, startTime, endTime, "comment"])
            });
        }
    }
}
