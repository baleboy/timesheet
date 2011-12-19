.pragma library

Qt.include("Utils.js")
var db = init()
var lastId

function init()
{
    var instance = openDatabaseSync("Flexo", "1.0", "Flexo DB", 1000000);
    instance.transaction(function(tx) {
        tx.executeSql('CREATE TABLE IF NOT EXISTS Projects(name STRING UNIQUE, elapsed INTEGER)');
        tx.executeSql('CREATE TABLE IF NOT EXISTS Details(project STRING, startTime INTEGER, endTime INTEGER)');
        tx.executeSql('CREATE TABLE IF NOT EXISTS Properties(name STRING UNIQUE, value STRING)');
        var rs = tx.executeSql('SELECT * FROM Properties WHERE name=?', ["pendingRecordId"]);
        if (rs.rows.length > 0) {
            lastId = rs.rows.item(0).value
        }
    });

    return instance
}

function addProject(name)
{
    db.transaction(function(tx) {
        tx.executeSql('INSERT INTO Projects (name, elapsed) VALUES (?,?)', [name,0])
    });
}

function populateProjectsModel(model)
{
    model.clear();
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM Projects');
        for(var i = 0; i < rs.rows.length; i++) {
            model.append({name: rs.rows.item(i).name, elapsed: rs.rows.item(i).elapsed});
        }
    });
}

function addProjectStart(project)
{
    var now = new Date()
    db.transaction(function(tx) {
                       var rs = tx.executeSql('INSERT INTO Details (project, startTime) VALUES (?, ?)', [project, now.getTime()])
                       lastId = rs.insertId
                       setProperty("pendingRecordId", lastId)
                       console.log("Opened record " + lastId)
    });
}

function addProjectEnd()
{
    var now = new Date()
    db.transaction(function(tx) {
                       tx.executeSql('UPDATE Details SET endTime=? WHERE ROWID=?', [now.getTime(), lastId])
                       console.log("Closed record " + lastId)
    });

}

function saveElapsed(project, elapsed)
{
    db.transaction(function(tx) {
                       tx.executeSql('UPDATE Projects SET elapsed=? WHERE name=?', [elapsed, project])
    });

}

function populateProjectDetails(model, project)
{
    model.clear();
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM Details WHERE project=?', [project]);
        for(var i = 0; i < rs.rows.length; i++) {
            var date1 = new Date
            date1.setTime(rs.rows.item(i).startTime)
            var endTimeText = qsTr("--:--");
            var elapsed = ""
            if(rs.rows.item(i).endTime !== "") {
                var date2 = new Date
                date2.setTime(rs.rows.item(i).endTime)
                endTimeText = Qt.formatTime(date2, "hh:mm")
                elapsed = toTime(date2.getTime() - date1.getTime())
            }

            model.append({startTime: Qt.formatTime(date1, "hh:mm"),
                             endTime: endTimeText,
                             elapsed: elapsed,
                             date: Qt.formatDate(date1, "dddd, MMMM dd yyyy"),
                             });
        }
    });


}

function clearAll()
{
    db.transaction(function(tx) {
        tx.executeSql('DELETE FROM Projects');
    });

    db.transaction(function(tx) {
        tx.executeSql('DELETE FROM Details');
    });

    db.transaction(function(tx) {
        tx.executeSql('DELETE FROM Properties');
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

function todaysTotal()
{
    var start = new Date()
    start.setHours(0)
    start.setMinutes(0)
    start.setSeconds(0)
    start.setMilliseconds(0)
    var end = new Date()
    end.setHours(23)
    end.setMinutes(59)
    end.setSeconds(59)
    end.setMilliseconds(999)

    var result = 0;
    db.transaction(function(tx) {
                       var rs = tx.executeSql('SELECT SUM (endTime - startTime) AS total FROM DETAILS WHERE startTime >= ? AND startTime <= ?',
                                              [start.getTime(), end.getTime()]);
                       result = rs.rows.item(0).total
    });
    return result
}
