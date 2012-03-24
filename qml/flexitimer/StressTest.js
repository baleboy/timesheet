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
