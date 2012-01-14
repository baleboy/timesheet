Qt.include("Db.js")
Qt.include("Utils.js")

function populate() {

    console.log("Projects.populate")

    projectList.model.clear();
    db.transaction(function(tx) {
                       var now = new Date()
                          var rs = tx.executeSql('SELECT \
                                                 project \
                                                 ,SUM(CASE WHEN endTime IS NOT NULL THEN endTime - startTime ELSE 0 END) AS elapsedTotal \
                                                 ,SUM(CASE WHEN startTime >= ? AND startTime <= ? AND endTime IS NOT NULL THEN endTime - startTime ELSE 0 END) AS elapsedToday \
                                             FROM \
                                                 (SELECT Projects.name as project, Details.startTime, Details.endTime \
                                                 FROM Projects \
                                                 LEFT JOIN Details \
                                                 ON Projects.name=Details.project) \
                                             GROUP BY \
                                                 project', [dayStart(now).getTime(), dayEnd(now).getTime()]);
                          for(var i = 0; i < rs.rows.length; i++) {
                              projectList.model.append({name: rs.rows.item(i).project, elapsedTotal: rs.rows.item(i).elapsedTotal, elapsedToday: rs.rows.item(i).elapsedToday});

                          }
                      });

}

function restoreOngoingSession()
{
    projectList.inProgress = getProperty("projectInProgress")

    if (projectList.inProgress !== "") {
        for (var i = 0 ; i < projectList.model.count ; i++) {
            if (projectList.model.get(i).name === projectList.inProgress) {
                projectList.inProgressIndex = i
                console.log("Project in progress: " + projectList.inProgress + ", index: " + i)
            }
        }

    }
}

function deleteProject(name, index)
{
    db.transaction(function(tx) {
                       var now = new Date()
                       var rs = tx.executeSql('DELETE FROM Projects WHERE name = ?', [name])
                   })

    db.transaction(function(tx) {
                       var now = new Date()
                       var rs = tx.executeSql('DELETE FROM Details WHERE project = ?', [name])
                   })
    if (index === projectList.inProgressIndex) {
        workTimer.stop()
        projectList.inProgress = ""
    }
    projectsPage.todaysTotal -= projectsModel.get(index).elapsedToday
    projectsModel.remove(index)
    if (projectList.inProgressIndex > index)
        projectList.inProgressIndex--
}
