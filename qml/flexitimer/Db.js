.pragma library

var db = init()
var lastId

function init()
{
    var instance = openDatabaseSync("Flexo", "1.0", "Flexo DB", 1000000);
    instance.transaction(function(tx) {
        tx.executeSql('CREATE TABLE IF NOT EXISTS Projects(name STRING UNIQUE, elapsed INTEGER)');
        tx.executeSql('CREATE TABLE IF NOT EXISTS Details(project STRING, start DATETIME, end DATETIME)');
        tx.executeSql('CREATE TABLE IF NOT EXISTS Properties(name STRING UNIQUE, value STRING)');
        });
    return instance
}

function addProject(name)
{
    db.transaction(function(tx) {
        tx.executeSql('INSERT INTO Projects (name) VALUES (?)', [name])
    });
}

function populateProjectsModel(model)
{
    model.clear();
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM Projects');
        for(var i = 0; i < rs.rows.length; i++) {
            model.append({name: rs.rows.item(i).name, elapsed: 0});
        }
    });
}

function addProjectStart(project)
{
    var now = new Date()
    db.transaction(function(tx) {
                       var rs = tx.executeSql('INSERT INTO Details (project, start) VALUES (?, ?)', [project, now])
                       lastId = rs.insertId
                       console.log("Opened record " + lastId)
    });
}

function addProjectEnd()
{
    var now = new Date()
    db.transaction(function(tx) {
                       tx.executeSql('UPDATE Details SET end=? WHERE ROWID=?', [now, lastId])
                       console.log("Closed record " + lastId)
    });

}

function populateProjectDetails(model, project)
{
    model.clear();
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM Details WHERE project=?', [project]);
        for(var i = 0; i < rs.rows.length; i++) {
            model.append({startTime: rs.rows.item(i).start,
                                    endTime: rs.rows.item(i).end,
                                    date: rs.rows.item(i).start});
        }
    });


}

function clearAll()
{
    db.transaction(function(tx) {
        tx.executeSql('DROP TABLE Projects');
        tx.executeSql('DROP TABLE Details');
        tx.executeSql('DROP TABLE Properties');
    });

}

function setProperty(name, value)
{
    db.transaction(function(tx) {
        tx.executeSql("INSERT OR REPLACE INTO Properties (name, value) VALUES (?,?)", [name, value]);
    });
}

function getProperty(name)
{
    var result = ""
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM Properties WHERE name=?', [name]);
        if (rs.rows.length > 0) {
            result = rs.rows.item(0).value
        }
    });
    return result
}

function printAll()
{
    db.transaction(function(tx) {
                       var rs = tx.executeSql('SELECT * FROM Projects');
                       for(var i = 0; i < rs.rows.length; i++) {
                           console.log(rs.rows.item(i).name)
                       }

                       rs = tx.executeSql('SELECT * FROM Details');
                       for(i = 0; i < rs.rows.length; i++) {
                           console.log(rs.rows.item(i).project + " " + rs.rows.item(i).start + " " + rs.rows.item(i).end)
                       }

                       rs = tx.executeSql('SELECT * FROM Properties');
                       for(i = 0; i < rs.rows.length; i++) {
                           console.log(rs.rows.item(i).name + ", " + rs.rows.item(i).value)
                       }
                   })

    console.log("LastID: " + lastId)
}
