var db = openDatabaseSync("Flexo", "1.0", "Flexo DB", 1000000);
var lastId

function init()
{
    db.transaction(function(tx) {
        tx.executeSql('CREATE TABLE IF NOT EXISTS Projects(name STRING, elapsed INTEGER)');
        tx.executeSql('CREATE TABLE IF NOT EXISTS Details(id INT IDENTITY(1,1) PRIMARY KEY, project STRING, start DATETIME, end DATETIME)');
        });
}

function addProject(name)
{
    db.transaction(function(tx) {
        tx.executeSql('INSERT INTO Projects (name) VALUES (?)', [name])
    });
}

function populateProjectsModel()
{
    projectsModel.clear();
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM Projects');
        for(var i = 0; i < rs.rows.length; i++) {
            projectsModel.append({name: rs.rows.item(i).name, elapsed: 0});
        }
    });
}

function addProjectStart(project)
{
    var now = new Date()
    db.transaction(function(tx) {
                       var rs = tx.executeSql('INSERT INTO Details (project, start) VALUES (?, ?)', [project, now])
                       lastId = rs.insertId
    });
}

function addProjectEnd(project)
{
    var now = new Date()
    db.transaction(function(tx) {
                       tx.executeSql('UPDATE Details SET end=? WHERE ROWID=?', [now, lastId])
    });

}

function populateProjectDetails(project)
{
    detailsModel.clear();
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM Details WHERE project=?', [project]);
        for(var i = 0; i < rs.rows.length; i++) {
            detailsModel.append({startTime: rs.rows.item(i).start,
                                    endTime: rs.rows.item(i).end,
                                    date: rs.rows.item(i).start});
        }
    });

}

function clearAll()
{
    db.transaction(function(tx) {
        tx.executeSql('DROP TABLE Projects');
    });

    db.transaction(function(tx) {
        tx.executeSql('DROP TABLE Details');
    });
}

