Qt.include("Db.js")
Qt.include("Utils.js")

function populate() {

    console.log("Projects.populate")

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
                console.log("Project in progress: " + inProgress + ", index: " + i)
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
    console.log("total: " + result)
    if (result === "")
        return 0
    else
        return result
}
