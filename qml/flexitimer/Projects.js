Qt.include("Db.js")
Qt.include("Utils.js")

function populate() {

    console.log("Projects.populate")

    // initialize model and ongoing project if any
    projectList.inProgress = getProperty("projectInProgress")
    projectList.model.clear();
    db.transaction(function(tx) {
                       var now = new Date()
                          var rs = tx.executeSql('SELECT \
                                                 project \
                                                 ,SUM(endTime - startTime) AS elapsedTotal \
                                                 ,SUM(CASE WHEN startTime >= ? AND startTime <= ? THEN endTime - startTime ELSE 0 END) AS elapsedToday \
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

function findInProgressIndex()
{
    for (var i = 0 ; i < projectList.model.count ; i++) {
        if (projectList.model.get(i).name === projectList.inProgress) {
            projectList.inProgressIndex = i
            console.log("Project in progress: " + projectList.inProgress + ", index: " + i)
        }
    }
}
